Return-Path: <linux-kernel-owner+w=401wt.eu-S934514AbXEHWNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514AbXEHWNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXEHWNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:13:07 -0400
Received: from xenotime.net ([66.160.160.81]:60558 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752141AbXEHWNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:13:05 -0400
Date: Tue, 8 May 2007 15:17:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@osdl.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-usb-devel@lists.sourceforge.net,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>,
       Tony Olech <tony.olech@elandigitalsystems.com>
Subject: [PATCH] different values for OHCI_QUIRK_ZFMICRO
Message-Id: <20070508151753.8a8df27c.rdunlap@xenotime.net>
In-Reply-To: <200703291524.01834.david-b@pacbell.net>
References: <20070111222627.66bb75ab.akpm@osdl.org>
	<20070220000654.GK13958@stusta.de>
	<20070329150638.83dcf1fa.randy.dunlap@oracle.com>
	<200703291524.01834.david-b@pacbell.net>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 15:24:00 -0700 David Brownell wrote:

> On Thursday 29 March 2007 3:06 pm, Randy Dunlap wrote:
> > On Tue, 20 Feb 2007 01:06:54 +0100 Adrian Bunk wrote:
> > 
> > > On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
> > > > On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
> > > > > <--  snip  -->
> > > > 
> > > > Waiting for Tony to submit bugfixes to his driver...
> > > 
> > > Still unfixed as of 2.6.20-mm1.
> >
> > so is there a patch around for this yet?
> > 
> > or shall someone other than Tony (??) make one?
> 
> ISTR posting the appended patch back in January; it's been
> refreshed since then.  Presumably it still works.
> 
> - Dave

Oh, Greg, can we get this merged some day soon, please?
David posted this patch on 2007-FEB-08.


From: David Brownell <dbrownell@users.sourceforge.net>

Partial fix for bogosity in the ftdi-elan and u13-hcd drivers ... these
have no business including with the internals of other drivers, much less
doing so in a broken way!!

Updated for 2.6.21-git10.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/host/u132-hcd.c  |   12 +++++++-----
 drivers/usb/misc/ftdi-elan.c |   12 ++++++++----
 2 files changed, 15 insertions(+), 9 deletions(-)

--- linux-2.6.21-git10.orig/drivers/usb/host/u132-hcd.c
+++ linux-2.6.21-git10/drivers/usb/host/u132-hcd.c
@@ -57,6 +57,13 @@
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
@@ -173,11 +180,6 @@ struct u132_ring {
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
--- linux-2.6.21-git10.orig/drivers/usb/misc/ftdi-elan.c
+++ linux-2.6.21-git10/drivers/usb/misc/ftdi-elan.c
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
@@ -2300,10 +2307,7 @@ static int ftdi_elan_checkingPCI(struct 
         offsetof(struct ohci_regs, member), 0, data);
 #define ftdi_write_pcimem(ftdi, member, data) ftdi_elan_write_pcimem(ftdi, \
         offsetof(struct ohci_regs, member), 0, data);
-#define OHCI_QUIRK_AMD756 0x01
-#define OHCI_QUIRK_SUPERIO 0x02
-#define OHCI_QUIRK_INITRESET 0x04
-#define OHCI_BIG_ENDIAN 0x08
+
 #define OHCI_CONTROL_INIT OHCI_CTRL_CBSR
 #define OHCI_INTR_INIT (OHCI_INTR_MIE | OHCI_INTR_UE | OHCI_INTR_RD | \
         OHCI_INTR_WDH)

