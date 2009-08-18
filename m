Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZHRXHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZHRXHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZHRXHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:07:44 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:40427 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbZHRXHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:07:43 -0400
X-Greylist: delayed 1660 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 19:07:42 EDT
Date: Wed, 19 Aug 2009 00:39:36 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, Andries Brouwer <aeb@cwi.nl>
Subject: Re: completely hide parts of the partition table from Windows?
Message-ID: <20090818223936.GA30029@citd.de>
References: <19083.7062.710265.941247@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19083.7062.710265.941247@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.08.2009 23:22, Mikael Pettersson wrote:
> The BIOS on my laptop clips disk capacities to 128GB. There's no BIOS
> update or BIOS setup option to fix this. Passing libata.ignore_hpa=1
> allows the Linux kernel to access larger disks, so Linux does work Ok
> with larger disks.
> 
> However, the laptop dual-boots Windows (for work-related stuff), and
> Windows has a major problem: if any entry in the msdos partition table
> refers to a sector above the BIOS 128GB limit, the Windows kernel
> crashes and reboots early in its boot sequence. The type of the
> partition doesn't matter, the fact that it describes an area above
> the stupid BIOS limit is enough to trigger the crash.
> 
> So what I'm looking for is some sub-partition table format with the
> following two properties:
> 1. resides in an msdos partition entry of a type that Windows does
>    not inspect (for whatever extended partitions or Apple/BSD/Sun
>    stuff that Windows may have been taught to recognize)
> 2. the locations and sizes of the sub-partitions are NOT limited by
>    the parent msdos partition entry
> 
> I've looked at the code in fs/partitions/msdos.c, and it seems that
> most of the extended/BSD/Sun formats don't give me property #2 above.
> 
> The minix and Unixware format parsers look like they ignore the parent
> msdos partion entry boundaries, but I'm not sure if that's by design
> or just sloppy coding.
> 
> Any recommendations? If no existing partition table format is suitable
> for my use case then I'm perfectly willing to invent a simple new format
> and add the corresponding parser to the kernel.

This is problem sligtly similar to my "I don't care about partitions i 
only want to use the whole HDD for storage".

The solution i use for my problem is 'loop' (My HDDs are encrypted so 
the loop(-AES) wasn't optional anyway). With a loop you can use any 
place in any size on the HDD like it is a partition, you just have to be 
careful to place it correctly.

The first time you have to losetup the loop so that you can mkfs it:
losetup /dev/loop<whatever> /dev/sd<whatelse> -o <offset> --sizelimit=<size_in_byte>

After the filesystem is created you can use something along this lines:
mount /dev/sd<whatelse> /<mountpoint> -oloop,offset=<offset>,sizelimit=<size_in_bytes>[...]

If you place the area last on the device, you can skip sizelimit then 
the loop uses the whole avaiable space to the end of the device.


AFAIK you can also use "device-mapper" in a similar way, i just don't 
have any personal experiences.

And last but not least, the documentation of GRUB meantions a 'hide'-bit 
for partitions and suggests that DOS/Windows honours it. Maybe setting 
the 'hide'-bit is enough.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

