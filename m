Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZFIGXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZFIGXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZFIGW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:22:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44752 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZFIGW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:22:57 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<m1oct739xu.fsf@fess.ebiederm.org>
	<20090606080334.GA15204@ZenIV.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Jun 2009 23:22:50 -0700
In-Reply-To: <20090606080334.GA15204@ZenIV.linux.org.uk> (Al Viro's message of "Sat\, 6 Jun 2009 09\:03\:34 +0100")
Message-ID: <m1k53mylhh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Jun 01, 2009 at 02:45:17PM -0700, Eric W. Biederman wrote:
>> 
>> I found myself looking at the uio, seeing that it does not support pci
>> hot-unplug, and thinking "Great yet another implementation of
>> hotunplug logic that needs to be added".
>> 
>> I decided to see what it would take to add a generic implementation of
>> the code we have for supporting hot unplugging devices in sysfs, proc,
>> sysctl, tty_io, and now almost in the tun driver.
>> 
>> Not long after I touched the tun driver and made it safe to delete the
>> network device while still holding it's file descriptor open I someone
>> else touch the code adding a different feature and my careful work
>> went up in flames.  Which brought home another point at the best of it
>> this is ultimately complex tricky code that subsystems should not need
>> to worry about.
>> 
>> What makes this even more interesting is that in the presence of pci
>> hot-unplug it looks like most subsystems and most devices will have to
>> deal with the issue one way or another.
>> 
>> This infrastructure could also be used to implement both force
>> unmounts and sys_revoke.  When I could not think of a better name for
>> I have drawn on that and used revoke.
>
> To be honest, the longer I'm looking at it, the less I like the approach...
> It really looks as if we'd be much better off with functionality sitting
> in a set of library helpers to be used by instances that need this stuff.
> Do we really want it for generic case?

I think so.  I do know I have seen enough weird cases actually being
used and not being done correctly we want a clean pattern for handling
the general case that works and is complete.

The problem seems to break up into several pieces.
- unmap support.
- Getting a list of the files that are open for an inode.
- Waking up interruptible sleepers.
- A test to see if we are executing any of the functions in 
  the file_operations structure. (needed before we can free state)
- Calling frelease and generally releasing of the state held by the
  file.

It might be possible to solve the entire problem outside of the vfs

> Note that "we might someday implement real force-umount" doesn't count;
> the same kind of arguments had been given nine years ago in case of AIO
> ("oh, sure, we'll eventually cover foo_get_block() too - it will all be
> a state machine, fully asynchronous; whaddya mean 'it's not feasible'?").
> Of course, it was _not_ feasible and had never been implemented.

> Frankly, I very much suspect that force-umount is another case like that;
> we'll need a *lot* of interesting cooperation from fs for that to work and
> to be useful.  I'd be delighted to be proven incorrect on that one, so
> if you have anything serious in that direction, please share the details.

So far nothing but thought experiments, but you have a good point at
least a proof of concept should be done of the various pieces.  To flush
out some niggling little detail that messes up the design.

So I hereby sign up for writing a sys_revoke patch, a forced umount patch
and a writing a patch to ext2 to support it.  Supporting proc and
sysfs while easy is not really the common case of an nfs exportable block
filesystem so it is not complete.

> As for the patchset in the current form...  Could you explain what's to prevent
> POSIX locks and dnotify entries from outliving a struct file you'd revoked,
> seeing that filp_close() will skip killing them in that case.

Good catch that looks like a big fat bug to me.  It seems I overlooked
the fact that we actually free things in filp_close.

Given that posix_remove_file calls vfs_lock_file which calls
file->f_op->lock it looks like something really needs to be done here.

dnotify_flush doesn't look to hard to spin a special case for revoke.

I am going to have to spend I while longer studying the rest of the
code in filp_close.  I hope I don't need to figure out the various
fl_owner_t values to safely revoke a file, but it looks like I might.

Eric
