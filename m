Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYATUJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYATUJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYATUI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:08:58 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33169 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbYATUI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:08:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: try harder to find symbol names in modpost
Date: Sun, 20 Jan 2008 21:08:57 +0100
Message-Id: <1200859743-24037-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1200859743-24037-1-git-send-email-sam@ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
 <1200859743-24037-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The relocation record sometimes contained an address
which was not an exactly match for a symbol.

Implment some simple logic such that if there
is a symbol within 20 bytes of the address contained
in the relocation record then print the name of this
symbol.

With this change modpost could find symbol names
for the remaining .init.text symbols in my
allyesconfig build for x86_64.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   19 +++++++++++++++++--
 scripts/mod/modpost.h |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 46660a4..902ee55 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -776,10 +776,13 @@ static int secref_whitelist(const char *modname, const char *tosec,
  * In other cases the symbol needs to be looked up in the symbol table
  * based on section and address.
  *  **/
-static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf_Addr addr,
+static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf64_Sword addr,
 				Elf_Sym *relsym)
 {
 	Elf_Sym *sym;
+	Elf_Sym *near = NULL;
+	Elf64_Sword distance = 20;
+	Elf64_Sword d;
 
 	if (relsym->st_name != 0)
 		return relsym;
@@ -790,8 +793,20 @@ static Elf_Sym *find_elf_symbol(struct elf_info *elf, Elf_Addr addr,
 			continue;
 		if (sym->st_value == addr)
 			return sym;
+		/* Find a symbol nearby - addr are maybe negative */
+		d = sym->st_value - addr;
+		if (d < 0)
+			d = addr - sym->st_value;
+		if (d < distance) {
+			distance = d;
+			near = sym;
+		}
 	}
-	return NULL;
+	/* We need a close match */
+	if (distance < 20)
+		return near;
+	else
+		return NULL;
 }
 
 static inline int is_arm_mapping_symbol(const char *str)
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0ffed17..999f15e 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -17,6 +17,7 @@
 #define Elf_Shdr    Elf32_Shdr
 #define Elf_Sym     Elf32_Sym
 #define Elf_Addr    Elf32_Addr
+#define Elf_Sword   Elf64_Sword
 #define Elf_Section Elf32_Half
 #define ELF_ST_BIND ELF32_ST_BIND
 #define ELF_ST_TYPE ELF32_ST_TYPE
@@ -31,6 +32,7 @@
 #define Elf_Shdr    Elf64_Shdr
 #define Elf_Sym     Elf64_Sym
 #define Elf_Addr    Elf64_Addr
+#define Elf_Sword   Elf64_Sxword
 #define Elf_Section Elf64_Half
 #define ELF_ST_BIND ELF64_ST_BIND
 #define ELF_ST_TYPE ELF64_ST_TYPE
-- 
1.5.4.rc3.14.g44397

