Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZFCLgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZFCLgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 07:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZFCLg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 07:36:29 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38523 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZFCLg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 07:36:28 -0400
Date: Wed, 3 Jun 2009 14:36:17 +0300
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: ext OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 0/5] FAT errors, user space notifications
Message-ID: <20090603113617.GA9917@smart.research.nokia.com>
Mail-Followup-To: ext OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-kernel@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
	"Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
References: <1243866494-31011-1-git-send-email-ext-denis.2.karpov@nokia.com> <87bpp6nhet.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpp6nhet.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Jun 2009 11:36:18.0098 (UTC) FILETIME=[828AD920:01C9E43F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 05:08:10AM +0200, ext OGAWA Hirofumi wrote:
> Denis Karpov <ext-denis.2.karpov@nokia.com> writes:
> 
> > 1. Options for FAT file system behavior on errors (continue, panic, 
> >    remount r/o)
> >
> >    Current FAT behavior is to remount itself read-only on critical errors.
> >    Quite often this causes more harm to user space applications than if the
> >    error would be ignored - file system suddenly becoming r/o leads to all 
> >    kind of surprises from applications (yes, I know applications should be
> >    written properly, this is not always the case). 
> >
> >    'errors' mount option (equivalent to the one in 
> >    ext2 fs) offers possibility for user space to specify the desired behavior.
> >    Default behavior is still as it was: remount read-only.
> >    [PATCH 1]
> 
> I can't see why more harm with r/o though, this would be useful for some
> people. 

Not 'harm' really, but not a nice thing either - for an user space application
having open fds or pwd on a partition that has become read-only. Anyway,
the default behavior is unchanged and alternatives are optional.

> Please see the comment to this patch.
Thank you for the review, fixed according to comments.

> > 2. Generic mechanism for notifications of user space about file system's 
> >    errors/inconsistency on a particular partition using:
> >
> >      - sysfs entry /sys/block/<bdev>/<part>/fs_unclean
> >      - uevent KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]
> >
> >    User space might want to monitor these notifications (poll2() on sysfs
> >    file or udevd's rule for uevent) and fix the fs damage.
> >    File system can be marked clean again by writing '0' to the corresponding 
> >    'fs_unclean' sysfs file.
> >
> >    Reason for this feature: doing full scale fsck on a file system 
> >    at mounting time (especially residing on a slow and error prone media 
> >    such as flash) takes long. Full fsck results e.g. in slow boot times.
> >    Alternative approach is to run limited fsck (or none at all) at 
> >    mounting/boot time. At run-rime if an fs error is encountered, notify 
> >    the user space and expect it to fix the file system.
> >    [PATCH 2]
> 
> This means you are assuming the fs driver can detect all kind of
> corruption?  It is not true. Mounting corrupted fs is dangerous, and the
> fs driver might corrupt the another part of fs silently. (e.g. corrupted
> pointer to object wouldn't be detected usually. etc.)

I realise that, but in this particular case I deal with non-critical data 
on a large FAT partition and can probably afford certain risk of damaging
the data. What I can't afford is to spend several minutes fsck'ing huge FAT
partition on slow SD/MMC media during bootup.

So I choose to optionally receive notification of errors encountered 
during 'run time' and act upon them.

Otherwise, nothing stops you from doing proper fsck before mounting.

IMO, receivng notification of errors is benefitial in any case:
together with the 1st patch above it gives full flexibility to user space
to implement fs 'run-time' errors handling policy (at least for FAT,EXT2),
e.g.:

- do nothing: remount r/o on errors, don't monitor kernel notifications (old/default
 behavior)
- remount-ro on errors, get notified; unmount partition, fsck, mount
  partition back r/w;
- ignore errors (continue), get notified: unmount the partition later at
suitable time, fsck, mount back r/w
 
> Or, limited check and repair on userspace, and other check is going into
> fs driver?
> 
> > 3. Make FAT and EXT2 file systems use the above mechanism to optionally 
> >    notify user space about errors. Implemented as 'notify' mount option.
> >    FAT error reporting facilities had to be re-factored in order to 
> >    simplify sending error notifications.
> >    [PATCH 3,4,5]
> 
> Thanks.

'user space notification' patches 2-5 above need a bit more work, I'll resend
them.

best regards,
Denis
