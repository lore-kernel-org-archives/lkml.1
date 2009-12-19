Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZLSOnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZLSOnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZLSOnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:43:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52294 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbZLSOnN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:43:13 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Helge Deller <deller@gmx.de>, Martin Michlmayr <tbm@cyrius.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 19 Dec 2009 14:43:01 +0000
Message-ID: <1261233781.2418.87.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] modules: Skip empty sections when exporting section notes
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 35dead4 "modules: don't export section names of empty sections
via sysfs" changed the set of sections that have attributes, but did
not change the iteration over these attributes in add_notes_attrs().
This can lead to add_notes_attrs() creating attributes with the wrong
names or with null name pointers.

Introduce a sect_empty() function and use it in both add_sect_attrs()
and add_notes_attrs().

Reported-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Martin Michlmayr <tbm@cyrius.com>
Cc: stable@kernel.org
---
 kernel/module.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index e96b8ed..f82386b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1010,6 +1010,12 @@ static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
  * J. Corbet <corbet@lwn.net>
  */
 #if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
+
+static inline bool sect_empty(const Elf_Shdr *sect)
+{
+	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
+}
+
 struct module_sect_attr
 {
 	struct module_attribute mattr;
@@ -1051,8 +1057,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < nsect; i++)
-		if (sechdrs[i].sh_flags & SHF_ALLOC
-		    && sechdrs[i].sh_size)
+		if (!sect_empty(&sechdrs[i]))
 			nloaded++;
 	size[0] = ALIGN(sizeof(*sect_attrs)
 			+ nloaded * sizeof(sect_attrs->attrs[0]),
@@ -1070,9 +1075,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 	sattr = &sect_attrs->attrs[0];
 	gattr = &sect_attrs->grp.attrs[0];
 	for (i = 0; i < nsect; i++) {
-		if (! (sechdrs[i].sh_flags & SHF_ALLOC))
-			continue;
-		if (!sechdrs[i].sh_size)
+		if (sect_empty(&sechdrs[i]))
 			continue;
 		sattr->address = sechdrs[i].sh_addr;
 		sattr->name = kstrdup(secstrings + sechdrs[i].sh_name,
@@ -1156,7 +1159,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	/* Count notes sections and allocate structures.  */
 	notes = 0;
 	for (i = 0; i < nsect; i++)
-		if ((sechdrs[i].sh_flags & SHF_ALLOC) &&
+		if (!sect_empty(&sechdrs[i]) &&
 		    (sechdrs[i].sh_type == SHT_NOTE))
 			++notes;
 
@@ -1172,7 +1175,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	notes_attrs->notes = notes;
 	nattr = &notes_attrs->attrs[0];
 	for (loaded = i = 0; i < nsect; ++i) {
-		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
-- 
1.6.5.4



