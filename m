Return-Path: <linux-kernel-owner+w=401wt.eu-S934196AbXGQOUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbXGQOUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764119AbXGQOI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35930 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760921AbXGQOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 12/33] kbuild: make better section mismatch reports on arm
Date: Tue, 17 Jul 2007 16:08:41 +0200
Message-Id: <1184681343423-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813432231-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With this change we can find more symbols hereby improving
the readability of the warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b83cddb..256b3d2 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -929,6 +929,26 @@ static int addend_386_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
 	return 0;
 }
 
+static int addend_arm_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
+{
+	unsigned int r_typ = ELF_R_TYPE(r->r_info);
+
+	switch (r_typ) {
+	case R_ARM_ABS32:
+		/* From ARM ABI: (S + A) | T */
+		r->r_addend = (int)(long)(elf->symtab_start + ELF_R_SYM(r->r_info));
+		break;
+	case R_ARM_PC24:
+		/* From ARM ABI: ((S + A) | T) - P */
+		r->r_addend = (int)(long)(elf->hdr + elf->sechdrs[rsection].sh_offset +
+		                          (r->r_offset - elf->sechdrs[rsection].sh_addr));
+		break;
+	default:
+		return 1;
+	}
+	return 0;
+}
+
 static int addend_mips_rel(struct elf_info *elf, int rsection, Elf_Rela *r)
 {
 	unsigned int r_typ = ELF_R_TYPE(r->r_info);
@@ -1051,6 +1071,10 @@ static void check_sec_ref(struct module *mod, const char *modname,
 					if (addend_386_rel(elf, i, &r))
 						continue;
 					break;
+				case EM_ARM:
+					if(addend_arm_rel(elf, i, &r))
+						continue;
+					break;
 				case EM_MIPS:
 					if (addend_mips_rel(elf, i, &r))
 						continue;
-- 
1.5.0.6

