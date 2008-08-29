Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYH2HFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYH2HFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYH2HFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:05:08 -0400
Received: from aglcosbs04.cos.agilent.com ([192.25.218.38]:49436 "EHLO
	aglcosbs04.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYH2HFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:05:06 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 03:05:06 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 00:57:54 -0600
Message-ID: <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com>
In-Reply-To: <200808281858.42486.korgull@home.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: add USB test and measurement class driver - round 2
Thread-Index: AckJL2NNrSIEZWzQQfGcdhJgATZmigAcn2QQ
References: <20080827183615.GA15692@kroah.com> <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org> <20080827234720.GC31264@kroah.com> <200808281858.42486.korgull@home.nl>
From: <stefan_kopp@agilent.com>
To: <korgull@home.nl>, <greg@kroah.com>
Cc: <stern@rowland.harvard.edu>, <oliver@neukum.org>,
       <linux-usb@vger.kernel.org>, <me@felipebalbi.com>,
       <linux-kernel@vger.kernel.org>, <stefan_kopp@agilent.com>
X-OriginalArrivalTime: 29 Aug 2008 06:57:55.0751 (UTC) FILETIME=[90547370:01C909A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I haven't been able to follow all the enhancements you did to the driver, but I can comment on the ratioale behind the orignal driver.

The original driver used minor number 0 for "driver communication" (in contrast to "device communication"). The main purpose was to get a list of the USBTMC devices attached by doing a "cat /dev/usbtmc0" (which would point to minor number 0). The first device found would then use the next free minor number, usually 1. I believe the concept of "driver communication" has been removed from the driver, so a single minor number for a single device should be it.

The issue with using cat on the shell level is that it uses fread which has the (in this case) ugly behaviour of recalling the driver's read method until the full number of characters requested has been accumulated (or until zero characters are returned, indicating the end of file). With USBTMC instruments, this behavour is bad because the retry will not just return zero characters, it will cause a timeout with the associated error condition in the device. So, to enable the use of echo/cat, I added some fread handling to the driver (which catches the retries). I believe this also has been removed, so I assume cat/fread will not work (?).

BTW, removing these "features" is not a problem IMHO -- actually I have been working on a "scaled down" version of the driver myself. The reason is that I have been adding a user space library which hides the details of the USB driver and adds portability/exchangability between USB/LAN/serial devices. I expect most users to use this level and it is unlikely they will still want to use echo/cat.

Best regards,
Stefan

-----Original Message-----
From: Marcel Janssen [mailto:korgull@home.nl] 
Sent: Donnerstag, 28. August 2008 18:59
To: Greg KH
Cc: Alan Stern; Oliver Neukum; USB list; KOPP,STEFAN (A-Germany,ex1); Felipe Balbi; Kernel development list
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2

On Thursday 28 August 2008 01:47:20 Greg KH wrote:
> Great, all done now.
>
> Here's the updated version.

I've just installed this version.

Here's what I see so far :

The driver inserts well and when I connect my device it shows /dev/usbtmc0 with major 180 and minor 176.
It only creates one device (Stefan's driver created two) but I'm not sure if that has changed for a reason so just let you know.

When I disconnect my device, usbtmc0 will not be destroyed. After connecting the device a couple of times I have a lot of /dev/usbtmc.. files.

I would expect the following to work :
echo :*IDN?>/dev/usbtmc0
But it returns : No such device

Using echo and cat to test the device is quite convenient, but is this supposed to work yet ?

I checked /sys a bit and found that the endpoints are correctly found.    

I also had an issue applying the patch (documentation and makefile). Not sure if that's related to my system though, I'll check that later.

regards,
Marcel




