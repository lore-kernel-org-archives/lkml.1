Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYC3SSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYC3SSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 14:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYC3SSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:18:45 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:33316 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYC3SSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:18:44 -0400
Date: Sun, 30 Mar 2008 20:18:40 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
 ->ata_*put_data methods
In-Reply-To: <200803301714.04527.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0803302012560.16372@anakin>
References: <200803301714.04527.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Bart,

On Sun, 30 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> * Add ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods to
>   falconide and q40ide host drivers (->ata_* methods are implemented on
>   top of ->atapi_* methods so they also do byte-swapping now).
> 
> * Cleanup atapi_{in,out}put_bytes().

Thanks!

One remaining issue (for which the fix has never been submitted upstream so
far) with Atari and Q40 is that due to the byteswapped interface, the driveid
is also byteswapped, so it has to be unswapped again in ide_fix_driveid().

Here's a very old and unclean but working patch:

--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -284,6 +284,23 @@ void ide_fix_driveid (struct hd_driveid 
 	int i;
 	u16 *stringcast;
 
+#ifdef __mc68000__
+	if (!MACH_IS_AMIGA && !MACH_IS_MAC && !MACH_IS_Q40 && !MACH_IS_ATARI)
+		return;
+
+#ifdef M68K_IDE_SWAPW
+	if (M68K_IDE_SWAPW) {	/* fix bus byteorder first */
+		u_char *p = (u_char *)id;
+		u_char t;
+		for (i = 0; i < 512; i += 2) {
+			t = p[i];
+			p[i] = p[i+1];
+			p[i+1] = t;
+		}
+	}
+#endif
+#endif /* __mc68000__ */
+
 	id->config         = __le16_to_cpu(id->config);
 	id->cyls           = __le16_to_cpu(id->cyls);
 	id->reserved2      = __le16_to_cpu(id->reserved2);

Note that include/asm-m68k/ide.h has

    #define M68K_IDE_SWAPW  (MACH_IS_Q40 || MACH_IS_ATARI)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
