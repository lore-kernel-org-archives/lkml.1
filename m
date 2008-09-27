Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYI0Ipn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYI0Ipn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 04:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYI0Ipf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 04:45:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59718 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYI0Ipd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 04:45:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20080926152031.GA30831@x200.localdomain>
	<alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
Date: Sat, 27 Sep 2008 01:44:07 -0700
In-Reply-To: <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 26 Sep 2008 08:47:51 -0700 (PDT)")
Message-ID: <m1bpyadlm0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0768]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 26 Sep 2008, Alexey Dobriyan wrote:
>>
>> Gentlemen, this happened while script was slowly rebuilding 300+ configs
>> sequentially. Very little recompling activity itself, much seeking.
>> 
>> This is first time I see this. No debugging was on, no preemption.

Consistent with the fact that is new code.

>> Version: 2.6.27-rc7-c0f4d6d4b14a75a341d972ff73fb9740e1ceb634 +
>> 	atl1 fixlet + "notes" kobject fixlet, but they don't matter.
>> 
>> ffffffff802bc690 <proc_sys_compare>:
> ....
>> ffffffff802bc6c0: 75 dd jne ffffffff802bc69f <proc_sys_compare+0xf>
>> ffffffff802bc6c2:	49 8b 40 e0          	mov    -0x20(%r8),%rax
>> ffffffff802bc6c6: ===> 48 8b 78 f0 mov -0x10(%rax),%rdi <===
>> ffffffff802bc6ca: e8 71 96 f7 ff callq ffffffff80235d40 <sysctl_is_seen>
>
> That would be the
>
> 	sysctl_is_seen(PROC_I(dentry->d_inode)->sysctl)
>
> call, and it really looks like 'dentry->d_inode' is NULL:

Agreed.

>> [16526.029537] BUG: unable to handle kernel paging request at fffffffffffffff0
>
> The whole PROC_I() thing just offsets from the inode:
>
> 	container_of(inode, struct proc_inode, vfs_inode);
>
> and 'sysctl' is indeed 16 bytes below the vfs inode on x86-64:
>
> 	struct proc_inode {
> 		...
> 	        struct ctl_table_header *sysctl;
> 	        struct ctl_table *sysctl_entry;
> 	        struct inode vfs_inode;
> 	};
>
> and as far as I can tell, there is nothing to say that a /proc inode 
> cannot be a negative dentry. Sure, we try to get rid of them, but during a 
> parallel lookup, we will have added the dentry with a NULL inode in the 
> other lookup.

Where is that? 

This is an issue because if we can get negative dentries the other
dentry operations are wrong as well.n

We hold the directory mutex in real_lookup
before calling i_op->lookup.  So lookups should be serialized.
proc_sys_lookup always either succeeds and calls d_add with
a valid inode or fails and returns an error code in which case
real_lookup puts the dentry before it is hashed.

We hold the directory mutex in readdir before calling
file->f_op->readdir.  Deep inside of proc_sys_readdir
proc_sys_fill_cache only adds the dentry if it has an inode.

do_revalidate doesn't look like it could get us there.
Nor does any of the paths that call ->d_delete.

It looks like don't free the inode from an non-negative
dentry until after it is unhashed.

So I'm totally stumped as to how we can get there.

> So assuming that you have an inode at that point seems to be utter crap.

Clearly we don't have an inode there but I don't see we can end up with
a negative inode.

> Now, the whole _function_ is utter crap and should probably be dropped, 
> but whatever. That's just another sysctl insanity. In the meantime, 
> something like this does look appropriate, no?

If we can't avoid negative dentries that looks appropriate.

But won't .d_revalidate and .d_delete be susceptible to the same
problem if we do have negative dentries?  

Eric
