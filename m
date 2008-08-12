Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbYHLFC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbYHLFC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYHLFB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:01:58 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:38267 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYHLFB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:01:57 -0400
Message-ID: <48A11952.6090203@keyaccess.nl>
Date: Tue, 12 Aug 2008 07:02:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linuxfoundation.org,
       fritz@isdn4linux.de, kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
References: <489DD669.2090207@keyaccess.nl>	<20080809215020.1bb602e7@lxorguk.ukuu.org.uk> <20080811164814.db41c20b.akpm@linux-foundation.org>
In-Reply-To: <20080811164814.db41c20b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-08 01:48, Andrew Morton wrote:

> otoh it's a bit sad to break allyesconfig kernels - there is
> regression-testing value in being able to run such kernels.
> 
> I wonder if we can add a new boot option `allyesconfig-test' or
> something like that, and then, within the offending drivers, test that
> flag and take suitable avoiding action.
> 
> Or we could do it at compile-time - define
> CONFIG_ALLYESCONFIG_TESTING in some fashion.

Yes, latter I'd feel with the thing most against it that there aren't 
actually many that need it. Here's the list that was posted:

http://lkml.org/lkml/2008/8/1/96

Three legacy ISA driver from that list can now be stricken. Hurrah.

There's always going to be at least a few that'll remain though. For 
example, what are you going to do with:

--- linux.orig/drivers/ide/Kconfig
+++ linux/drivers/ide/Kconfig
@@ -9,6 +9,11 @@ config HAVE_IDE
  menuconfig IDE
  	tristate "ATA/ATAPI/MFM/RLL support"
  	depends on HAVE_IDE
+
+	# my test box expects /dev/sda, not /dev/hda
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT if IDE = y
+
  	depends on BLOCK
  	---help---
  	  If you say Y here, your kernel will be able to manage low cost

The hda->sda thing was just a disaster -- personally I have to remember 
to change things around till this very day before I boot into my distro 
kernel to test things. I wouldn't be the one suggesting a patch to 
drivers/ide to "fix" that though including really a patch to its Kconfig 
marking it as breaking anything in a global way rather than a 
user-specific way as was done here.

Maybe the test boxes should always boot with ide_core.noprobe=<all> for 
a suitable value of <all> or some such...

Others are the video ones. FB_VESA, FB_VGA16FB and even MDA_CONSOLE are 
in there which seems to imply some decidly non-legacy hardware and I 
sort of doubt willingness to assume global validity of such a setup.

But yes, there is value in the testing so perhaps still worh something 
generic.

(I'll continue some specific looking through the list first although I 
don't believe there is much else that really wants specific fixing).

Rene.
