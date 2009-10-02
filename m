Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZJBBdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZJBBdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZJBBdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:01 -0400
Received: from kroah.org ([198.145.64.141]:33058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbZJBBc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:11 2009
Message-Id: <20091002012411.802166167@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Massimo Cirillo <maxcir@gmail.com>,
       Alexey Korolev <akorolev@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [039/136] mtd: cfi_cmdset_0002: add 0xFF intolerance for M29W128G
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=mtd-cfi_cmdset_0002-add-0xff-intolerance-for-m29w128g.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Massimo Cirillo <maxcir@gmail.com>

commit 23af51ecfb04ff65bae51bd8e2270f4449abc789 upstream.

The M29W128G Numonyx flash devices are intolerant to any 0xFF command:
in the Cfi_util.c the function cfi_qry_mode_off() (that resets the device
after the autoselect mode) must have a 0xF0 command after the 0xFF command.
This fix solves also the cause of the fixup_M29W128G_write_buffer() fix,
that can be removed now.
The following patch applies to 2.6.30 kernel.

Signed-off-by: Massimo Cirillo <maxcir@gmail.com>
Acked-by: Alexey Korolev <akorolev@infradead.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/chips/cfi_cmdset_0002.c |   11 -----------
 drivers/mtd/chips/cfi_util.c        |    4 ++++
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -282,16 +282,6 @@ static void fixup_s29gl032n_sectors(stru
 	}
 }
 
-static void fixup_M29W128G_write_buffer(struct mtd_info *mtd, void *param)
-{
-	struct map_info *map = mtd->priv;
-	struct cfi_private *cfi = map->fldrv_priv;
-	if (cfi->cfiq->BufWriteTimeoutTyp) {
-		pr_warning("Don't use write buffer on ST flash M29W128G\n");
-		cfi->cfiq->BufWriteTimeoutTyp = 0;
-	}
-}
-
 static struct cfi_fixup cfi_fixup_table[] = {
 	{ CFI_MFR_ATMEL, CFI_ID_ANY, fixup_convert_atmel_pri, NULL },
 #ifdef AMD_BOOTLOC_BUG
@@ -308,7 +298,6 @@ static struct cfi_fixup cfi_fixup_table[
 	{ CFI_MFR_AMD, 0x1301, fixup_s29gl064n_sectors, NULL, },
 	{ CFI_MFR_AMD, 0x1a00, fixup_s29gl032n_sectors, NULL, },
 	{ CFI_MFR_AMD, 0x1a01, fixup_s29gl032n_sectors, NULL, },
-	{ CFI_MFR_ST,  0x227E, fixup_M29W128G_write_buffer, NULL, },
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers, NULL, },
 #endif
--- a/drivers/mtd/chips/cfi_util.c
+++ b/drivers/mtd/chips/cfi_util.c
@@ -81,6 +81,10 @@ void __xipram cfi_qry_mode_off(uint32_t 
 {
 	cfi_send_gen_cmd(0xF0, 0, base, map, cfi, cfi->device_type, NULL);
 	cfi_send_gen_cmd(0xFF, 0, base, map, cfi, cfi->device_type, NULL);
+	/* M29W128G flashes require an additional reset command
+	   when exit qry mode */
+	if ((cfi->mfr == CFI_MFR_ST) && (cfi->id == 0x227E || cfi->id == 0x7E))
+		cfi_send_gen_cmd(0xF0, 0, base, map, cfi, cfi->device_type, NULL);
 }
 EXPORT_SYMBOL_GPL(cfi_qry_mode_off);
 


