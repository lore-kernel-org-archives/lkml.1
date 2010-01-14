Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725Ab0ANWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab0ANWk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757664Ab0ANWky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:40:54 -0500
Received: from kroah.org ([198.145.64.141]:60500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0ANW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Ben Hutchings <ben@decadent.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/52] modules: Skip empty sections when exporting section notes
Date: Thu, 14 Jan 2010 14:26:43 -0800
Message-Id: <1263508051-7868-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-3-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit 10b465aaf9536ee5a16652fa0700740183d48ec9 upstream.

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
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5842a71..37caef0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1146,6 +1146,12 @@ static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
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
@@ -1187,8 +1193,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < nsect; i++)
-		if (sechdrs[i].sh_flags & SHF_ALLOC
-		    && sechdrs[i].sh_size)
+		if (!sect_empty(&sechdrs[i]))
 			nloaded++;
 	size[0] = ALIGN(sizeof(*sect_attrs)
 			+ nloaded * sizeof(sect_attrs->attrs[0]),
@@ -1206,9 +1211,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
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
@@ -1292,7 +1295,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	/* Count notes sections and allocate structures.  */
 	notes = 0;
 	for (i = 0; i < nsect; i++)
-		if ((sechdrs[i].sh_flags & SHF_ALLOC) &&
+		if (!sect_empty(&sechdrs[i]) &&
 		    (sechdrs[i].sh_type == SHT_NOTE))
 			++notes;
 
@@ -1308,7 +1311,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 	notes_attrs->notes = notes;
 	nattr = &notes_attrs->attrs[0];
 	for (loaded = i = 0; i < nsect; ++i) {
-		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
-- 
1.6.6

