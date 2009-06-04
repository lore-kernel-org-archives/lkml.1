Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbZFDGBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbZFDGBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbZFDF72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:59:28 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49844 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbZFDF70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:59:26 -0400
Message-ID: <4A276266.8000409@nokia.com>
Date: Thu, 04 Jun 2009 08:57:58 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603115611.6bbbaf55.akpm@linux-foundation.org>
In-Reply-To: <20090603115611.6bbbaf55.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Jun 2009 05:58:04.0381 (UTC) FILETIME=[6CF520D0:01C9E4D9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> hm, I'm uncertain on the desirability or otherwise of the overall feature.
> 
> Are there users or distros or device manufacturers asking for this? 
> Where did the requirement come from?
> 
> What downstream application will handle the uevent messages?  Do you
> have some userspace design/plan in mind?
> 
> IOW, it would be useful if we were told more about all of this, rather
> than just staring at a kernel patch!

As the original idea came from me, while whole implementation
and design was done by Denis, I'll comment on this.

Our use-case is about hand-held devices. We are particularly
working with large FAT volumes on MMC. Do not question please
why it is FAT and not something else :-) Anyway, FAT is very
unreliable, and often hits errors, in which case it simply
switches to read-only mode, and usually prints something to
the printk ring buffer.

When FAT becomes read only out of the blue, the user-space
reaction if very different. Often applications just start
failing, dying, etc. From users' perspective, the hand-held
just becomes weird.

What we want instead is to teach FAT to send the user-space a
notification. What our user-space people think to do is to
catch the notification and show a dialog window which tells
something like "Please, check your FS, blah blah", and may
be offer the user to run fsck.vfat, not exactly sure.

> One part of the design which you didn't describe, but which I inferred
> is that you intend that userspace will see the FS_UNCLEAN=1 messages
> and will then poll all the /sys/block/<bdev>/<part>/fs_unclean files to
> work out which partition(s) got the error, correct?  Please spell all
> that out in the changelog.

I think this part of the design needs more thought. Not
all FSes have block devices (UBIFS, JFFS2), and some FSes
may (theoretically) span more than one block device (btrfs?).

Probably it is better to go without any sysfs file and
just send udev events.

> What use is the FS_UNCLEAN=0 message?  I don't get that.  Again, please
> cover this in the description.

Yes, the description should be improved. I think the idea is that
we add an udev rule which invokes a certain user-space script/app
on "FAT became R/O" events.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
