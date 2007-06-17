Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbXFQLip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbXFQLip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbXFQLig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:38:36 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:58778 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612AbXFQLie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:38:34 -0400
Message-ID: <46751D37.5020608@dgreaves.com>
Date: Sun, 17 Jun 2007 12:38:31 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: David Robinson <zxvdr.au@gmail.com>
Cc: LVM general discussion and development <linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com>
In-Reply-To: <4674645F.5000906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Robinson wrote:
> David Greaves wrote:
>> This isn't a regression.
>>
>> I was seeing these problems on 2.6.21 (but 22 was in -rc so I waited 
>> to try it).
>> I tried 2.6.22-rc4 (with Tejun's patches) to see if it had improved - no.
>>
>> Note this is a different (desktop) machine to that involved my recent 
>> bugs.
>>
>> The machine will work for days (continually powered up) without a 
>> problem and then exhibits a filesystem failure within minutes of a 
>> resume.
>>
>> I know xfs/raid are OK with hibernate. Is lvm?
> 
> I have LVM working with hibernate w/o any problems (w/ ext3). If there 
> were a problem it wouldn't be with LVM but with device-mapper, and I 
> doubt there's a problem with either. The stack trace shows that you're 
> within XFS code (but it's likely its hibernate).

Thanks - that's good to know.
The suspicion arises because I have xfs on raid1 as root and have *never* had a 
problem with that filesystem. It's *always* xfs on lvm on raid5. I also have 
another system (previously discussed) that reliably hibernated xfs on raid6.

(Clearly raid5 is in my suspect list)

> You can easily check whether its LVM/device-mapper:
> 
> 1) check "dmsetup table" - it should be the same before hibernating and 
> after resuming.
> 
> 2) read directly from the LV - ie, "dd if=/dev/mapper/video_vg-video_lv 
> of=/dev/null bs=10M count=200".
> 
> If dmsetup shows the same info and you can read directly from the LV I 
> doubt it would be a LVM/device-mapper problem.

OK, that gave me an idea.

Freeze the filesystem
md5sum the lvm
hibernate
resume
md5sum the lvm

so:


haze:~# xfs_freeze -f /scratch/

Without this sync, the next two md5sums differed..
haze:~# sync
haze:~# dd if=/dev/video_vg/video_lv bs=10M count=200 | md5sum
200+0 records in
200+0 records out
2097152000 bytes (2.1 GB) copied, 41.2495 seconds, 50.8 MB/s
f42539366bb4269623fa4db14e8e8be2  -
haze:~# dd if=/dev/video_vg/video_lv bs=10M count=200 | md5sum
200+0 records in
200+0 records out
2097152000 bytes (2.1 GB) copied, 41.8111 seconds, 50.2 MB/s
f42539366bb4269623fa4db14e8e8be2  -


haze:~# echo platform > /sys/power/disk
haze:~# echo disk > /sys/power/state


haze:~# dd if=/dev/video_vg/video_lv bs=10M count=200 | md5sum
200+0 records in
200+0 records out
2097152000 bytes (2.1 GB) copied, 42.0478 seconds, 49.9 MB/s
f42539366bb4269623fa4db14e8e8be2  -
haze:~# xfs_freeze -u /scratch/

So the lvm and below looks OK...

I'll see how it behaves now the filesystem has been frozen/thawed over the 
hibernate...

David

