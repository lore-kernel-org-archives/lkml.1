Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbXCHQAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbXCHQAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXCHQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:00:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbXCHQAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:00:20 -0500
Message-ID: <45F03305.8040507@redhat.com>
Date: Thu, 08 Mar 2007 11:00:05 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: johan henriksson <jhn98032@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Radeon xpress 200m and radeonfb kinda work
References: <45ECB2D0.3080205@telia.com> <45EEEBC9.1010002@redhat.com> <45EF275E.4060300@gmail.com>
In-Reply-To: <45EF275E.4060300@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090602060509040701020102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090602060509040701020102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

johan henriksson wrote:
> As you can see in the patch I have disabled "Dynamic Clock PM"
> since it makes my card freak out (Don't know why :(  ).
> Is there a reason why the "default_dynclk" parameter only is available
> when radeonfb is built as a module or should it be added to radeonfb_setup?

I don't have a clue how that works; I just merged your patch
into a Fedora test kernel and it worked. (And it looks a lot
nicer than vesafb.)

Our X driver guru says the patch is OK and Xpress 200M is
the same as normal Radeon for 2D so framebuffer should be OK.

So we can add this to the patch:

Tested-by: Chuck Ebbert <cebbert@redhat.com>

Please repost it as a reply-to-all and add a decent description
and a signed-off-by per this document:

http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

--------------090602060509040701020102
Content-Type: text/plain;
 name="linux-2.6-20_radeon_fb_200M.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-20_radeon_fb_200M.patch"

Hi!

I have gotten the radeon xpress 200m (the version without dedicated vmem)
to work with radeonfb.
The attached patch (against linux-2.6.20.1) works for me.
Since I don't have any docs for the card I am unsure if the patch is 100% correct.
Can someone else with a 200m try it out?
(I have tested it by enabling  fbcon and radeonfb in the kernel  and
added "video=radeonfb" to lilo. This gave me a nice 1280x800 console :) )

/Johan Henriksson

Please CC, I'm not on the list.



diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1-vanilla/drivers/video/aty/ati_ids.h linux-2.6.20.1/drivers/video/aty/ati_ids.h
--- linux-2.6.20.1-vanilla/drivers/video/aty/ati_ids.h	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/ati_ids.h	Tue Mar  6 00:31:16 2007
@@ -209,4 +209,4 @@
 #define PCI_CHIP_R423_5D57              0x5D57
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
-
+#define PCI_CHIP_RS480_5955             0x5955
diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1-vanilla/drivers/video/aty/radeon_base.c linux-2.6.20.1/drivers/video/aty/radeon_base.c
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeon_base.c	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeon_base.c	Tue Mar  6 00:31:19 2007
@@ -100,6 +100,8 @@
 	{ PCI_VENDOR_ID_ATI, id, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (flags) | (CHIP_FAMILY_##family) }
 
 static struct pci_device_id radeonfb_pci_table[] = {
+        /* Radeon Xpress 200m */
+	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility M6 */
 	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
@@ -1990,7 +1992,8 @@ static void radeon_identify_vram(struct 
 	/* framebuffer size */
         if ((rinfo->family == CHIP_FAMILY_RS100) ||
             (rinfo->family == CHIP_FAMILY_RS200) ||
-            (rinfo->family == CHIP_FAMILY_RS300)) {
+            (rinfo->family == CHIP_FAMILY_RS300) ||
+	    (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
@@ -2329,7 +2332,7 @@ static int __devinit radeonfb_pci_regist
 		/* -2 is special: means  ON on mobility chips and do not
 		 * change on others
 		 */
-		radeonfb_pm_init(rinfo, rinfo->is_mobility ? 1 : -1, ignore_devlist, force_sleep);
+		radeonfb_pm_init(rinfo, -1,ignore_devlist, force_sleep);//rinfo->is_mobility ? 1 : -1);
 	} else
 		radeonfb_pm_init(rinfo, default_dynclk, ignore_devlist, force_sleep);
diff -uprN -X linux-2.6.20.1-vanilla/Documentation/dontdiff linux-2.6.20.1-vanilla/drivers/video/aty/radeonfb.h linux-2.6.20.1/drivers/video/aty/radeonfb.h
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeonfb.h	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeonfb.h	Tue Mar  6 00:31:16 2007
@@ -48,6 +48,7 @@ enum radeon_family {
 	CHIP_FAMILY_RV350,
 	CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
 	CHIP_FAMILY_R420,     /* R420/R423/M18 */
+	CHIP_FAMILY_RS480,
 	CHIP_FAMILY_LAST,
 };
 
@@ -64,7 +65,8 @@ enum radeon_family {
 				((rinfo)->family == CHIP_FAMILY_RV350) || \
 				((rinfo)->family == CHIP_FAMILY_R350)  || \
 				((rinfo)->family == CHIP_FAMILY_RV380) || \
-				((rinfo)->family == CHIP_FAMILY_R420))
+				((rinfo)->family == CHIP_FAMILY_R420)  || \
+		                ((rinfo)->family == CHIP_FAMILY_RS480) )
 
 /*
  * Chip flags

--------------090602060509040701020102--
