Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbXJXHXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbXJXHXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXJXHXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:23:09 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56301 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163AbXJXHXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:23:08 -0400
Date: Wed, 24 Oct 2007 09:23:05 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jeff Garzik <jeff@garzik.org>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg KH <greg@kroah.com>
Subject: Re: const vs __{dev}initdata
In-Reply-To: <471E7151.8070805@garzik.org>
Message-ID: <Pine.LNX.4.62.0710240919590.6034@pademelon.sonytel.be>
References: <200710232335.56766.bzolnier@gmail.com> <471E7151.8070805@garzik.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-306859401-1193210456=:6034"
Content-ID: <Pine.LNX.4.62.0710240921150.6034@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-306859401-1193210456=:6034
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0710240921151.6034@pademelon.sonytel.be>

On Tue, 23 Oct 2007, Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > It seems that const cannot be (officialy) mixed with __{dev}initdata,
> > 
> > include/linux/init.h:
> > ...
> >  *
> >  * Also note, that this data cannot be "const".
> >  */
> > ...
> > 
> > [ BTW Greg: this doesn't seem to be mentioned in LDD3. ]
> > 
> > Any reason for this limitation (other than not having .init.rodata section
> > and __const__{dev}initdata tag)?  There are places where we really would
> > like
> > to have both, i.e. struct ide_port_info in drivers/ide.
> 
> Thank you for asking this question...  we really do need a solution for this.
> 
> As you point out, there are many valid cases for both const and initdata.

Indeed. And sometimes it works, depending on the toolchain version. Cfr.
the patch below which I couldn't submit due to this.

Patch monkeys: DO NOT APPLY ;-)

Subject: fbdev: move logo externs to header file

Move the external declarations for the various linux logo structures to
<linux/linux_logo.h>. As a consequence, I had to change scripts/pnmtologo.c to
add the appropriate `const' to the generated logo source code.

FIXME: This one is really tricky and cannot be applied!
  - gcc 3.4.6 20060404 (Red Hat 3.4.6-3) needs xxx_data[] and
    xxx_clut[] to be const too, else it complains about a section type conflict
  - ppu-gcc 4.1.0 20060304 (Red Hat 4.1.0-3) needs xxx_data[] and xxx_clut[] to
    be non-const, else it complains about a section type conflict
Anyone with a suggestion how to fix this?

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-By: James Simmons <jsimmons@infradead.org>
---
 arch/powerpc/kernel/prom_init.c |    3 ---
 drivers/video/logo/logo.c       |   13 -------------
 include/linux/linux_logo.h      |   13 +++++++++++++
 scripts/pnmtologo.c             |    2 +-
 4 files changed, 14 insertions(+), 17 deletions(-)

--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -44,10 +44,7 @@
 #include <asm/sections.h>
 #include <asm/machdep.h>
 
-#ifdef CONFIG_LOGO_LINUX_CLUT224
 #include <linux/linux_logo.h>
-extern const struct linux_logo logo_linux_clut224;
-#endif
 
 /*
  * Properties whose value is longer than this get excluded from our
--- a/drivers/video/logo/logo.c
+++ b/drivers/video/logo/logo.c
@@ -21,19 +21,6 @@
 #include <asm/bootinfo.h>
 #endif
 
-extern const struct linux_logo logo_linux_mono;
-extern const struct linux_logo logo_linux_vga16;
-extern const struct linux_logo logo_linux_clut224;
-extern const struct linux_logo logo_dec_clut224;
-extern const struct linux_logo logo_mac_clut224;
-extern const struct linux_logo logo_parisc_clut224;
-extern const struct linux_logo logo_sgi_clut224;
-extern const struct linux_logo logo_sun_clut224;
-extern const struct linux_logo logo_superh_mono;
-extern const struct linux_logo logo_superh_vga16;
-extern const struct linux_logo logo_superh_clut224;
-extern const struct linux_logo logo_m32r_clut224;
-
 
 const struct linux_logo *fb_find_logo(int depth)
 {
--- a/include/linux/linux_logo.h
+++ b/include/linux/linux_logo.h
@@ -32,6 +32,19 @@ struct linux_logo {
 	const unsigned char *data;
 };
 
+extern const struct linux_logo logo_linux_mono;
+extern const struct linux_logo logo_linux_vga16;
+extern const struct linux_logo logo_linux_clut224;
+extern const struct linux_logo logo_dec_clut224;
+extern const struct linux_logo logo_mac_clut224;
+extern const struct linux_logo logo_parisc_clut224;
+extern const struct linux_logo logo_sgi_clut224;
+extern const struct linux_logo logo_sun_clut224;
+extern const struct linux_logo logo_superh_mono;
+extern const struct linux_logo logo_superh_vga16;
+extern const struct linux_logo logo_superh_clut224;
+extern const struct linux_logo logo_m32r_clut224;
+
 extern const struct linux_logo *fb_find_logo(int depth);
 
 #endif /* _LINUX_LINUX_LOGO_H */
--- a/scripts/pnmtologo.c
+++ b/scripts/pnmtologo.c
@@ -244,7 +244,7 @@ static void write_header(void)
 static void write_footer(void)
 {
     fputs("\n};\n\n", out);
-    fprintf(out, "struct linux_logo %s __initdata = {\n", logoname);
+    fprintf(out, "const struct linux_logo %s __initdata = {\n", logoname);
     fprintf(out, "    .type\t= %s,\n", logo_types[logo_type]);
     fprintf(out, "    .width\t= %d,\n", logo_width);
     fprintf(out, "    .height\t= %d,\n", logo_height);

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-306859401-1193210456=:6034--
