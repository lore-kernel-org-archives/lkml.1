Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbYBGTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbYBGTFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbYBGTEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:04:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49292 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbYBGTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:04:54 -0500
Date: Thu, 7 Feb 2008 11:04:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: lkml <linux-kernel@vger.kernel.org>, shemminger@linux-foundation.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] apanel: fix kconfig dependencies
Message-Id: <20080207110412.792db623.randy.dunlap@oracle.com>
In-Reply-To: <20080207174251.1b895234@hyperion.delvare>
References: <20080206162754.73114579.randy.dunlap@oracle.com>
	<20080207174251.1b895234@hyperion.delvare>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 17:42:51 +0100 Jean Delvare wrote:

> Hi Randy,
> 
> On Wed, 6 Feb 2008 16:27:54 -0800, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Add I2C to config since the driver makes several i2c*() calls.
> 
> Correct.
> 
> > 
> > Add PCI to config because the config selects I2C_I801, which depends
> > on PCI, but currently config* does not follow dependency chains,
> > so randconfig can enable INPUT_APANEL even when PCI is not enabled,
> > which leads to these warnings:
> > linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:641: error: implicit declaration of function 'pci_request_region'
> > /linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:681: error: implicit declaration of function 'pci_release_region'
> 
> I'd rather drop the "select I2C_I801" if the config system can't handle
> it properly. It's not strictly needed (not a build-time dependency), an
> addition to the help text would work as well. Adding dependencies to
> make our selections happy is a bit confusing and likely to cause
> trouble in the future (as dependencies can change...)

OK.  What did you have in mind for the help text.  I changed it
a small bit.

I also added "depends on LEDS_CLASS" since defconfig didn't have that
set, but the build failed with wanting symbols that it provides.

Updated patch:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From: Randy Dunlap <randy.dunlap@oracle.com>

Add I2C to config since the driver makes several i2c*() calls.

Add to help text that the Intel I2C ICH (i801) driver is also needed
for this kernel.

Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/input/misc/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-mm1.orig/drivers/input/misc/Kconfig
+++ linux-2.6.24-mm1/drivers/input/misc/Kconfig
@@ -42,14 +42,14 @@ config INPUT_M68K_BEEP
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86
-	select I2C_I801
+	depends on X86 && I2C && LEDS_CLASS
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
 	help
 	 Say Y here for support of the Application Panel buttons, used on
 	 Fujitsu Lifebook. These are attached to the mainboard through
-	 an SMBus interface managed by the I2C Intel ICH (i801) driver.
+	 an SMBus interface managed by the I2C Intel ICH (i801) driver,
+	 which you should also build for this kernel.
 
 	 To compile this driver as a module, choose M here: the module will
 	 be called apanel.
