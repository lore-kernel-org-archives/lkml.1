Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYAFOvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYAFOvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbYAFOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51253 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbYAFOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:40:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4780E814.4050405@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 15:39:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <200801051546.SAA08947@raad.intranet> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <200801060803.27101.a1426z@gawab.com>
In-Reply-To: <200801060803.27101.a1426z@gawab.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Sam Ravnborg wrote:
>> And that requires you to use select only to select symbols with
>> no dependencies.
>>
>> In this case we do not know if BLOCK is enabled or not.
> 
> Good point!  How about we solve it like this:
> 
>   	menuconfig USB_STORAGE
>   	tristate "USB Mass Storage support"
> -	depends on USB && SCSI
> +	depends on USB && BLOCK
> +	select SCSI

Still wrong.  SCSI also needs HAS_DMA and SCSI_DMA.  HAS_DMA furthermore
depends on !NO_DMA.  So that would mean

menuconfig USB_STORAGE
	tristate "USB Mass Storage support"
	depends on USB && BLOCK && HAS_DMA
	select SCSI
	select SCSI_DMA

But copying all (currently existing) dependencies of SCSI to USB_STORAGE
is arguably a bad solution.  There are four other potential solutions:

  - Let kconfig look up the dependencies of SCSI.  If they are
    fulfilled, present the option USB_STORAGE and switch on SCSI if
    the user chooses USB_STORAGE.

  - Let kconfig recursively look up all dependencies of SCSI and their
    subsequent dependencies.  Try to switch them all on if the user
    chooses USB_STORAGE.  If that fails for whatever reason, say to
    the user:  I'm sorry Dave, I'm afraid I can't do that.

  - Don't use 'select' on options which have further dependencies.

  - Design and implement UIs which don't need 'select' in the first
    place.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
