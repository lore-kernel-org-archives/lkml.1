Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYHHANh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYHHANh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYHHAN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:13:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51785 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbYHHANY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:13:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu>
	<20080807222751.GA28412@us.ibm.com>
Date: Thu, 07 Aug 2008 17:07:01 -0700
In-Reply-To: <20080807222751.GA28412@us.ibm.com> (Serge E. Hallyn's message of
	"Thu, 7 Aug 2008 17:27:51 -0500")
Message-ID: <m1prokgyje.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4735]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
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

> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> Here's a git tree of the unprivileged mounts patchset:
>> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
> unprivileged-mounts
>> 
>> Could this be added to -mm (and dropped if it's in the way of
>> something) for some testing and added visibility until it's reviewed
>> by Christoph/Al?
>> 
>> I'm not reposting the whole patchset, since it's essentially the same
>> as the last submission, only updated to the latest git.  But if
>> somebody wants it I can post them.
>> 
>> Thanks,
>> Miklos
>> 
>> 
>>  Documentation/filesystems/fuse.txt |   88 ++++++++-
>>  Documentation/filesystems/proc.txt |   40 ++++
>>  fs/filesystems.c                   |   60 ++++++
>>  fs/fuse/inode.c                    |   21 ++
>>  fs/internal.h                      |    3 +-
>> fs/namespace.c | 366 +++++++++++++++++++++++++++---------
>>  fs/pnode.c                         |   22 ++-
>>  fs/pnode.h                         |    2 +
>>  fs/super.c                         |   26 ---
>>  include/linux/fs.h                 |    7 +
>>  include/linux/mount.h              |    4 +
>>  kernel/sysctl.c                    |   16 ++
>>  12 files changed, 527 insertions(+), 128 deletions(-)
>> 
>> Miklos Szeredi (10):
>>       unprivileged mounts: add user mounts to the kernel
>>       unprivileged mounts: allow unprivileged umount
>>       unprivileged mounts: propagate error values from clone_mnt
>>       unprivileged mounts: account user mounts
>>       unprivileged mounts: allow unprivileged bind mounts
>>       unprivileged mounts: allow unprivileged mounts
>>       unprivileged mounts: add sysctl tunable for "safe" property
>>       unprivileged mounts: make fuse safe
>>       unprivileged mounts: propagation: inherit owner from parent
>>       unprivileged mounts: add "no submounts" flag
>
> Hi Miklos,
>
> so on the bright side I pulled this tree today and it compiled and
> passed ltp with no problems.
>
> But then I played around a bit and found I could do the following:
>
> (hmm, i'm trying to remember the exact order :)
>
> as root:
> 	mmount --bind -o user=500 /home/hallyn/etc/ /home/hallyn/etc/
> 	mount --bind /mnt /mnt
> 	mount --make-rshared /mnt
> 	mount --bind /dev /mnt/dev
>
> as hallyn:
> 	mmount --bind /mnt /home/hallyn/etc/mnt
> 	/usr/src/mmount-0.3/mmount --bind mnt/dev mnt/src

You are using relative directory names here which makes it confusing.
I'm assuming you in /home/hallyn/etc ?

>
> Now /mnt/src contained /dev.
>
> Is this what we want?

I don't think so.

I think the simplest answer is to not allow mounting of shared
subtrees controlled by a different user.

Serge I think you are right downgrading the mount from shared to slave
looks like the sane thing to do if the mount owners match.

> Do we want to tell the admin it's his fault for
> not somehow forcing a slave relationship between /mnt and
> /home/hallyn/etc/mnt?  Except I don't think he can do that preemptively,
> it has to be done after hallyn does the mmount.
>
> So does that mean that if non-root user X does:
>
> 	mount a b
>
> where b is user=X but a is not, then if a is shared we should force it
> to be mounted as slave at b?
>
> -serge
