Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZGEN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZGEN6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZGEN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:58:09 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:62312 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZGEN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=MmdFQnMJv/8Ygmkp/EOygkjH6uYLtAA/C9sHJx20RCBM/V0i9XTgbRfaDHzBYwBiol
         kqbzA1UvKm+lvuFIho/0/EWH+vCxtlq79Wq+2C8SJaFzi9sopQGJb7nnUqGIWZ+KEl0O
         7YMCrcXKTCOV1kJ6hlVlA8ABjgxeaSxClA5a0=
Date: Sun, 5 Jul 2009 15:58:06 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Len Brown <lenb@kernel.org>
Cc: Peter Feuerer <peter@piie.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] Acerhdf: fix fan control for BIOS 3309
Message-ID: <20090705135806.GB9778@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Len Brown <lenb@kernel.org>, Peter Feuerer <peter@piie.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

please apply.

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 5 Jul 2009 14:35:01 +0200
Subject: [PATCH] Acerhdf: fix fan control for BIOS 3309

With BIOS update v3309, the Aspire One has had some changes to how
the fan is being controlled. Reads to the fanreg (0x55) do not simply
return the on/off values of the fan anymore but rather a different
fan stage based on the current temperature. Empirically, I could
observe the fan stage being 0x1 when booting the machine, then the
temperature went up and the BIOS switched the fan to stage 0x2, making
it rotate faster with final stage being fan state 0x3, aka max.

This requires some changes to the controlling code so that it can still
be done adequately. Also, the OFF switch has changed from 0x21 to 0x20.
It seems almost as if they're using the least significant nibble of the
command written to the ioport for the different fan stages.

While at it, convert the fancmd[] array to a real struct thus
disambiguating command handling and making code more readable.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index bdfee17..b2ef9f5 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -108,13 +108,18 @@ MODULE_PARM_DESC(verbose, "Enable verbose dmesg output");
 module_param_string(force_bios, force_bios, 16, 0);
 MODULE_PARM_DESC(force_bios, "Force BIOS version and omit BIOS check");
 
+struct fancmd {
+	u8 cmd_off;
+	u8 cmd_auto;
+};
+
 /* BIOS settings */
 struct bios_settings_t {
 	const char *vendor;
 	const char *version;
 	unsigned char fanreg;
 	unsigned char tempreg;
-	unsigned char fancmd[2]; /* fan off and auto commands */
+	struct fancmd cmd;
 };
 
 /* Register addresses and values for different BIOS versions */
@@ -125,7 +130,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
 	{"Acer", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
 	{"Gateway", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
 	{"Packard Bell", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
@@ -134,7 +139,6 @@ static const struct bios_settings_t bios_tbl[] = {
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
 
-
 static int acerhdf_get_temp(int *temp)
 {
 	u8 read_temp;
@@ -150,13 +154,14 @@ static int acerhdf_get_temp(int *temp)
 static int acerhdf_get_fanstate(int *state)
 {
 	u8 fan;
-	bool tmp;
 
 	if (ec_read(bios_cfg->fanreg, &fan))
 		return -EINVAL;
 
-	tmp = (fan == bios_cfg->fancmd[ACERHDF_FAN_OFF]);
-	*state = tmp ? ACERHDF_FAN_OFF : ACERHDF_FAN_AUTO;
+	if (fan != bios_cfg->cmd.cmd_off)
+		*state = ACERHDF_FAN_AUTO;
+	else
+		*state = ACERHDF_FAN_OFF;
 
 	return 0;
 }
@@ -175,7 +180,8 @@ static void acerhdf_change_fanstate(int state)
 		state = ACERHDF_FAN_AUTO;
 	}
 
-	cmd = bios_cfg->fancmd[state];
+	cmd = (state == ACERHDF_FAN_OFF) ? bios_cfg->cmd.cmd_off
+					 : bios_cfg->cmd.cmd_auto;
 	fanstate = state;
 
 	ec_write(bios_cfg->fanreg, cmd);
-- 
1.6.3.1

-- 
Regards/Gruss,
    Boris.
