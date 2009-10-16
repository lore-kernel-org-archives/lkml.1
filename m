Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZJPWYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZJPWYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZJPWYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:24:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:3661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZJPWYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ttd+ubNrFV4LZoEarlFbJnTsz/HrNel5eH0hshS4BfztaS1o6JYhOZ7TnGVONPj8HL
         zUhQFScTEkgqh2Uaor7XSE4KqHwgSC+QCiTPyZjQb0qJhq9kXWD9zCxWw4hdxihs7U5t
         MpUzOdzDIQ9ZVWrU6Z20V3DJrhmO3cDB9qFi8=
MIME-Version: 1.0
In-Reply-To: <20091016091558.GA10184@mit.edu>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
	 <20091016091558.GA10184@mit.edu>
Date: Fri, 16 Oct 2009 18:24:18 -0400
Message-ID: <f7848160910161524j36876b80ma559426b00c98050@mail.gmail.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
From: Parag Warudkar <parag.lkml@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Parag Warudkar <parag.lkml@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 5:15 AM, Theodore Tso <tytso@mit.edu> wrote:
>
> A number of people have reported this, and there is some discussion
> and some suggestions that I've made here:
>
>        http://bugzilla.kernel.org/show_bug.cgi?id=14354

Ok, I went through this bug report and here are some immediately
useful things to note -
1) I am not running Karmic - I am running Jaunty x86_64 clean install
2) I am not using dm/lvm or anything fancy for that matter
3) So far, I have been able to reproduce this problem by just hitting
the power button on my laptop when it is doing nothing. It also
happens when waking up from s2ram and the laptop wasn't doing anything
when it was suspended (I mean I wasn't copying/deleting stuff, wasn't
running make - laptop was

> So if you can come up with a reliable reproduction case, and don't
> mind doing some experiments and/or exchanging debugging correspondance
> with me, please let me know.  I'd **really** appreciate the help.

My laptop is a reliable test case - for me at least! I tried just now
to abruptly reset the laptop and upon reboot there was fsck followed
by another reboot only to have X fail to start and NetWorkManager
segfault. At this point I am pretty sure I can reproduce it just be
power cycling the laptop using the power button.
After another fsck and a reboot it finally comes up.

>
> Information that would be helpful to me would be:
>
> a) Detailed hardware information (what type of disk/SSD, what type of
> laptop, hardware configuration, etc.)

SSD is a Corsair P256 latest firmware, been used on other machine
without any issues.
Laptop is HP EliteBook 8530p, 4GB RAM, Intel T9400 CPU, Intel WiFi,
ATI 3650 GPU.
No proprietary drivers ever loaded.


>
> b) Detailed software information (what version of the kernel are you
> using including any special patches, what distro and version are you
> using, are you using LVM or dm-crypt, what partition or partitions did
> you have mounted, was the failing partition a root partition or some
> other mounted partition, etc.)
It happens on current custom compiled git - both on custom and minimal
localmodconfig.
It also happens on Ubuntu daily kernel PPA builds.

>
> c) Detailed reproduction recipe (what programs were you running before
> the crash/failed suspend/resume, etc.)
>
Really nothing special - I boot to desktop, may be open FireFox for
few minutes and then try reset.
fsck then reports a bunch of errors and forces reboot. On reboot X
fails to start, file system although mounted rw cannot be written to -
vim for instance won't open any file due to write errors. Another fsck
finds few more problems (or sometimes not) and reboot brings it back
to desktop.

So my problem is not corruption really but the amount and nature of
errors fsck encounters and corrects on unclean shutdown and the write
failures until another fsck -f finds more problems and reboots. None
of this happens on any other filesystem including the /boot ext3 fs on
the same disk.

>
> If you do decide to go hunting this problem, one thing I would
> strongly suggest is that either to use "tune2fs -c 1 /dev/XXX" to
> force a fsck after every reboot, or if you are using LVM, to use the
> e2croncheck script (found as an attachment in the above bugzilla entry
> or in the e2fsprogs sources in the contrib directory) to take a
> snapshot and then check the snapshot right after you reboot and login
> to your system.  The reported file system corruptions seem to involve
> the block allocation bitmaps getting corrupted, and so you will
> significantly reduce the chances of data loss if you run e2fsck as
> soon as possible after the file system corruption happens.  This helps
> you not lose data, and it also helps us find the bug, since it helps
> pinpoint the earliest possible point where the file system is getting
> corrupted.

I have enabled fsck on every mount but I am not certain ongoing "clean
state" corruption is the problem in my case.
Things have worked well without any trouble if I don't end up doing a
unclean shutdown.

[ snip]

> I'm going to be at the kernel summit in Tokyo next week, so my e-mail
> latency will be a bit longer than normal, which is one of the reason
> why I've left a goodly list of potential experiments for people to
> try.  If you can come up with a reliable regression, and are willing
> to work with me or to try some of the above mentioned tests, I'll
> definitely buy you a real (or virtual) beer.
>

I will try the things you mentioned - finding if this happens in pre
.32 kernels is the first one on my list followed by reverting the
specific commits you mentioned, followed if necessary by complete
bisection.

I am afraid however this is not a regression - at least not a recent
one, as I have had this experience with ext4 and unclean shutdowns
since long time.
And that's on different hardware/different disks.

Thanks,

Parag
