Return-Path: <linux-kernel-owner+w=401wt.eu-S1945905AbXC2WYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945905AbXC2WYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945895AbXC2WYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:24:08 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:24571 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1945907AbXC2WYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:24:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FnP7dercEMUmExZfh82zam3+4GUItyt+ZtnHgeyuszlWa6MZ/cLa+C74HnDwdRkCrpQGm1xwPyrNC5hOcw2xn/0raR3TjreKVpIna+Z6Ei4ozfkPEaDghHXHVXSPEGec6SRMDlofo2FksVGeDnI7l2Wfd0QtGwmTaPITFsmlw44=  ;
X-YMail-OSG: t1FEXMkVM1nRlTYE182WTKPb1dlGqayUlIhhrGd3GWGvuNaoLDAB0sbdBFHEgOTPGJRZ_mohxA--
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.20-rc4-mm1: different values for OHCI_QUIRK_ZFMICRO
Date: Thu, 29 Mar 2007 15:24:00 -0700
User-Agent: KMail/1.7.1
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Olech <tony.olech@elandigitalsystems.com>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070220000654.GK13958@stusta.de> <20070329150638.83dcf1fa.randy.dunlap@oracle.com>
In-Reply-To: <20070329150638.83dcf1fa.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291524.01834.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 3:06 pm, Randy Dunlap wrote:
> On Tue, 20 Feb 2007 01:06:54 +0100 Adrian Bunk wrote:
> 
> > On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
> > > On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
> > > > <--  snip  -->
> > > 
> > > Waiting for Tony to submit bugfixes to his driver...
> > 
> > Still unfixed as of 2.6.20-mm1.
>
> so is there a patch around for this yet?
> 
> or shall someone other than Tony (??) make one?

ISTR posting the appended patch back in January; it's been
refreshed since then.  Presumably it still works.

- Dave

=============	CUT HERE
Partial fix for bogosity in the ftdi-elan and u13-hcd drivers ... these
have no business including with the internals of other drivers, much less
doing so in a broken way!!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Index: g26/drivers/usb/misc/ftdi-elan.c
===================================================================
--- g26.orig/drivers/usb/misc/ftdi-elan.c	2007-01-02 20:05:33.000000000 -0800
+++ g26/drivers/usb/misc/ftdi-elan.c	2007-02-08 18:45:13.000000000 -0800
@@ -73,6 +73,13 @@ static struct list_head ftdi_static_list
 #include "usb_u132.h"
 #include <asm/io.h>
 #include "../core/hcd.h"
+
+	/* FIXME ohci.h is ONLY for internal use by the OHCI driver.
+	 * If you're going to try crap like this, you need to split
+	 * out the common stuff (register declarations?) into a
+	 * sharable file, maybe name <linux/usb/ohci.h>
+	 */
+
 #include "../host/ohci.h"
 /* Define these values to match your devices*/
 #define USB_FTDI_ELAN_VENDOR_ID 0x0403
@@ -2300,11 +2307,7 @@ static int ftdi_elan_checkingPCI(struct 
         offsetof(struct ohci_regs, member), 0, data);
 #define ftdi_write_pcimem(ftdi, member, data) ftdi_elan_write_pcimem(ftdi, \
         offsetof(struct ohci_regs, member), 0, data);
-#define OHCI_QUIRK_AMD756 0x01
-#define OHCI_QUIRK_SUPERIO 0x02
-#define OHCI_QUIRK_INITRESET 0x04
-#define OHCI_BIG_ENDIAN 0x08
-#define OHCI_QUIRK_ZFMICRO 0x10
+
 #define OHCI_CONTROL_INIT OHCI_CTRL_CBSR
 #define OHCI_INTR_INIT (OHCI_INTR_MIE | OHCI_INTR_UE | OHCI_INTR_RD | \
         OHCI_INTR_WDH)
Index: g26/drivers/usb/host/u132-hcd.c
===================================================================
--- g26.orig/drivers/usb/host/u132-hcd.c	2007-01-02 20:05:33.000000000 -0800
+++ g26/drivers/usb/host/u132-hcd.c	2007-02-08 18:45:06.000000000 -0800
@@ -58,6 +58,13 @@
 #include <asm/system.h>
 #include <asm/byteorder.h>
 #include "../core/hcd.h"
+
+	/* FIXME ohci.h is ONLY for internal use by the OHCI driver.
+	 * If you're going to try crap like this, you need to split
+	 * out the common stuff (register declarations?) into a
+	 * sharable file, maybe name <linux/usb/ohci.h>
+	 */
+
 #include "ohci.h"
 #define OHCI_CONTROL_INIT OHCI_CTRL_CBSR
 #define OHCI_INTR_INIT (OHCI_INTR_MIE | OHCI_INTR_UE | OHCI_INTR_RD | \
@@ -174,11 +181,6 @@ struct u132_ring {
         struct u132_endp *curr_endp;
         struct delayed_work scheduler;
 };
-#define OHCI_QUIRK_AMD756 0x01
-#define OHCI_QUIRK_SUPERIO 0x02
-#define OHCI_QUIRK_INITRESET 0x04
-#define OHCI_BIG_ENDIAN 0x08
-#define OHCI_QUIRK_ZFMICRO 0x10
 struct u132 {
         struct kref kref;
         struct list_head u132_list;
