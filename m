Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYINDPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYINDPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 23:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYINDPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 23:15:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54484 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYINDPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 23:15:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
	<E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
	<20080905153134.GA18367@us.ibm.com>
	<E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu>
	<m11vzrge86.fsf@frodo.ebiederm.org>
	<E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
	<20080911152033.GA29318@us.ibm.com>
	<m13ak6ecoi.fsf@frodo.ebiederm.org>
	<20080912220802.GA23230@us.ibm.com>
	<m1tzck68od.fsf@frodo.ebiederm.org>
	<20080914015646.GC18604@us.ibm.com>
Date: Sat, 13 Sep 2008 20:06:46 -0700
In-Reply-To: <20080914015646.GC18604@us.ibm.com> (Serge E. Hallyn's message of
	"Sat, 13 Sep 2008 20:56:46 -0500")
Message-ID: <m1od2r1l4p.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0089]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: unprivileged mounts git tree
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

>> > So in order for me as an unprivileged user to pin a dentry by mounting
>> > over it, I have to have write permission to the dentry to begin with
>> > as well as the dentry being under a user=hallyn mount.
>> 
>> That second condition is interesting requiring write permission of the
>> dentry.  I thought we had obviated the need for that when we added
>> ownership to the mounts themselves.  In this case at least it shouldn't
>> it be write permission on the directory containing the dentry.
>
> Oh no, it seems I'm wrong, that's not a condition.  Just tested it.

Ok.  I couldn't find Mikolos's code when I looked quickly.
What are the current rules?  It sounds like my original example could apply.

>> This seems to mess up things like revoke.
>
> Hey, do we have revoke now?  :)

Periodically someone works on revoke ;)

>> At a practical level it is a real annoyance, regardless of the security
>> implications.
>> 
>> As a point of comparison plan9 does not have that restriction.
>
> Why doesn't it have that restriction?  

I haven't heard the reason.

> Does it always allow you to rm a mounted-over file?

Yes.

The implementation of mounts in plan9 is a bit different.  In
plan9 mounts are looked up by mount namespace and qid (effectively
the inode number).  So the semantics are slightly different.
Requiring a new mount namespace if you want to see what a filesystem
looks like without a mount on top of a given file.

It also looks like plan9 is likely to have a unmountable and unusable mount
if you actually delete an file, from another mount namespace.

Linux actually has a very similar case where we can loose a mount if you rename
the directory that contains it to be somewhere higher in the mount hierarchy
than the location the mount was under.

All of that said there is a very good practical justification for it all.
In a filesystem where not all changes come through our local VFS the
VFS cannot prevent changes to a filesystem it can only cache and respond
to changes that do occur.

So things like sysfs_rename_dir and sysfs_move_dir routinely bypass
the VFS restriction against changes happening under mount points.  It
isn't a problem in practice because people don't mount on sysfs but the
problem is very much there today.

It looks to me like the right solution is very much to do the lazy
unmount we do for expired mounts, and purge everything that happens
and then we just don't have to worry about mounts causing a denial
of service attack and life gets simpler.

Rename is a bit trickier than unlink and rmdir in that we should allow
it on the underlying filesystem and only remove the directory if the
rename goes out of scope for the overlying mount.

Eric
