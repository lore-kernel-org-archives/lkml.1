Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbYEAO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbYEAO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYEAO3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:29:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47398 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEAO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:28:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4819D38A.2010905@s5r6.in-berlin.de>
Date: Thu, 01 May 2008 16:28:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Kristian Hoegsberg <krh@redhat.com>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git16 -- IEEE 1394 device has ROM CRC error -- No /dev/video0
 device
References: <a44ae5cd0805010641j34243377wd7d4b76efd7e670d@mail.gmail.com>
In-Reply-To: <a44ae5cd0805010641j34243377wd7d4b76efd7e670d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(We don't really need to Cc Kristian on this, since it is about 
drivers/ieee1394, not about drivers/firewire.)

Miles Lane wrote:
> I noticed that no /dev/video0 device was being created, so I enabled
> all the video driver options and rebuilt my kernel with ieee1394
> debugging enabled.
> Unfortunately, I still don't get a /dev/video0 device for my
> OrangeMicro iBot.  Is this simply due to the CRC error?  If so, is
> there a way of working around this, since the webcam works okay under
> Windows?

The video1394 driver, if built modular, has the following module aliases 
built in:
alias:          ieee1394:ven*mo*sp0000A02Dver00000102*
alias:          ieee1394:ven*mo*sp0000A02Dver00000101*
alias:          ieee1394:ven*mo*sp0000A02Dver00000100*

These are the codes of Unit_Spec_ID = 1394 Trade Association and 
Unit_SW_Version = 1394 Based Digital Camera Specification (IIDC) version 
1.04, 1.20, and 1.30 respectively.

Whenever an IIDC compliant device is plugged in, the kernel will emit an 
uevent (formerly called hotplug event) with a string which can be 
matched against module aliases.  Modern distributions contain scripts 
which will the modprobe all kernel modules which contain matching aliases.

The raw1394 driver, if built modular, contains the same aliases as 
video1394 (because it is required as well to work with IIDC cameras) and 
an alias for AV/C devices.  BTW, video1394 is also being used for 
devices other than IIDC, but it has to be manually loaded for those.

Once the video1394 is present in the kernel (either because it was 
modprobed automatically or manually or because it was linked in 
statically to begin with), it will register a character device interface 
for each host adapter.  This also works with adapters which are added 
later, e.g. CardBus cards.

Now, modern distributions have scripts (udev scripts) which recognize 
the addition or removal of a character device interface and will create 
or remove corresponding character device files in /dev on the fly.

If your distro doesn't do so, you need to create these files yourself 
with mknod, specifying the correct major and minor device number:
http://wiki.linux1394.org/video1394
(Note, this contains outdated references to devfs which is no longer in 
use and not supported by video1394 anymore since Linux 2.6.17 or 
probably even earlier.)

Both autoloading of video1394 and automatic creation of video1394 
character device files work for me on 2.6.25 + latest linux1394-2.6.git 
on Gentoo Linux --- without me having a clue how all the details work. I 
hope you too get it working with these hints.  On Gentoo, the video1394 
character device files are called /dev/video1394-?, ? being 0 or more 
for each host adapter.
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/
