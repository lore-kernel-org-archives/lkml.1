Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZAATPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZAATPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZAATPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:15:05 -0500
Received: from main.gmane.org ([80.91.229.2]:33052 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZAATPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:15:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't
 be   unplugged safely
Date: Thu, 01 Jan 2009 13:09:59 -0600
Message-ID: <495D1507.5080306@shaw.ca>
References: <20090101160343.GA4278@thyme.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <20090101160343.GA4278@thyme.bj.intel.com>
Cc: linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> Hello List,
> 
> By default CONFIG_USB_SUSPEND is not enabled and today I got bite by
> this when I got a new WDC My Book hard drive. I have no way to unplug
> it safely, according to it's manual, with a kernel that doesn't have
> CONFIG_USB_SUSPEND=y.
> 
> On it's manual read "you should unplug and remove the device only when
> the light is off." On Linux unmounting it won't turn it's light off
> and I can feel it's motor is still running.  The only way to unplug it
> properly on a Linux system, as to my knowledge, is to echo `suspend'
> to `/sys/bus/usb/devices/$DEV/power/level'. And one has to have
> CONFIG_USB_SUSPEND=y to do this.
> 
> On Windows and Mac OS, `safely remove this device' function effectly
> turns it into `suspend' mode, and it's light off.
> 
> I'm new in this field and I understood people's concern on enabling
> autosuspend.  As to my understanding, `enabling suspend' and `enabling
> autosuspend' should be controlled by two different knobs.  I did a
> quick search in LKML and haven't found specific oppose to enable USB
> suspend by default, and Debian has started shipping a kernel with
> it turned on since 2.6.26.
> 
> Perhaps we should consider turning it on by default?  Thanks!

It's probably not a bad idea. I'm not sure how big of a problem it 
actually is, though. As long as the filesystem is unmounted before 
unplug you'll probably be OK (unless you ripped out the cable/power so 
quickly afterwards that there was still data in the write cache).

Ideally before disconnecting a removable hard drive one should flush the 
write cache and park the heads (the latter being somewhat important for 
2.5" drives in order to avoid emergency head unloads that would reduce 
the life of the drive). I believe that there's a command one can echo 
into the sd driver in sysfs somewhere that will trigger this.. Therefore 
the right sequence would be:

-unmount filesystem
-remove SCSI disk (synchronize cache and stop unit)
-suspend SCSI device

Thing is that some USB storage devices don't support both of those 
commands (I've got a USB-to-IDE enclosure with a Genesys chipset that 
doesn't translate SCSI START STOP UNIT into an IDE Standby Immediate 
command as it really should, think it just throws "invalid field in CDB" 
errors). However if we've done the above we've really done the best we 
can do..

