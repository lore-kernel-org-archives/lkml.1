Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZBUUqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZBUUqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 15:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZBUUqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 15:46:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62805 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZBUUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 15:46:31 -0500
Date: Sat, 21 Feb 2009 15:46:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       zippel@linux-m68k.org
Subject: [PATCH v2] kconfig: check for select dependency errors on config
 load
In-Reply-To: <alpine.DEB.2.00.0902211504200.30069@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0902211535440.18221@gandalf.stny.rr.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <alpine.DEB.2.00.0902210008580.30069@gandalf.stny.rr.com> <20090220220810.6f4360f0.akpm@linux-foundation.org> <499F9D25.8010300@oracle.com>
 <alpine.DEB.2.00.0902211504200.30069@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Feb 2009, Steven Rostedt wrote:
> On Fri, 20 Feb 2009, Randy Dunlap wrote:
> > EMBEDDED is misnamed.  It means "those who think that they know enough
> > to use all of the power of kconfig."
> > Some people spell that EXPERT etc.
> > Or it means "let me shoot myself in the foot."

> 
> Anyway, to avoid having these spit out all the time, I'll see if I can 
> make it not warn if the dependency was on EMBEDDED/EXPERT. I'll try to 
> work on it when I have time.

That was easier than I expected. Here's an updated version of the patch.

It now finds the symbol EMBEDDED, saves its state. Updates its state to 
'yes', runs the tests, resets its state back to what it was.

Now all I get from that previous config:

$ make menuconfig
scripts/kconfig/mconf arch/x86/Kconfig
.config:2561:warning: SCSI_SAS_LIBSAS selects SCSI_SAS_ATTRS which fails its dependencies!
.config:2561:warning: DRM selects I2C_ALGOBIT which fails its dependencies!

Hmm, that I2C_ALGOBIT depends on I2C_HELPER_AUTO, which looks similar to 
the EMBEDDED option. That is, Don't show this option unless this is not 
selected. I may just add a 'WHITELIST' of things that will be enabled 
during thet test.

But the SCSI_SAS_ATTRS depends on BLK_DEV_BSG which is not selected.


I also added to run the test on write as well.

But having it find the culprits will require a bit more that 5 minutes of
work. That will stay on my TODO list for now.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 830d9ea..7717926 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -310,6 +310,127 @@ load:
 	return 0;
 }
 
+static int test_deps(struct symbol *sym)
+{
+	struct property *prop;
+	struct expr *expr;
+
+	if (sym->rev_dep.tri == no)
+		return 1;
+
+	for (prop = sym->prop; prop; prop = prop->next) {
+		if (prop->type != P_PROMPT)
+			continue;
+
+		expr = prop->visible.expr;
+		if (!expr)
+			continue;
+
+		if (expr_calc_value(expr) == no)
+			return 0;
+	}
+
+	return 1;
+}
+
+void test_select(struct symbol *sym)
+{
+	struct property *prop;
+	struct expr *expr;
+
+	for (prop = sym->prop; prop; prop = prop->next) {
+		if (prop->type != P_SELECT)
+			continue;
+
+		expr = prop->expr;
+
+		if (!expr || expr->type != E_SYMBOL ||
+		    !expr->left.sym)
+			continue;
+			
+		if (test_deps(expr->left.sym))
+			continue;
+
+		conf_warning("%s selects %s which fails its dependencies!",
+			     sym->name, expr->left.sym->name);
+	}
+}
+
+void test_conf(void)
+{
+	struct symbol *sym, *embedded;
+	tristate embed_tri;
+	struct menu *menu;
+	int type;
+
+	/*
+	 * EMBEDDED is more like an "EXPERT" option. It is OK
+	 * to select it even when it does not have the proper
+	 * dependencies.
+	 *
+	 * Find  the EMBEDDED symbol.
+	 * Save its state.
+	 * Set it to 'yes'.
+	 * Run tests.
+	 * Reset the EMBEDDED symbol.
+	 */
+	embedded = sym_lookup("EMBEDDED", 0);
+	embed_tri = embedded->curr.tri;
+	embedded->curr.tri = yes;
+	
+	menu = rootmenu.list;
+	while (menu) {
+		sym = menu->sym;
+		if (!sym)
+			goto next;
+
+		if (!(sym->flags & SYMBOL_CHOICE)) {
+			sym_calc_value(sym);
+			if (!(sym->flags & SYMBOL_WRITE))
+				goto next;
+			type = sym->type;
+			if (type == S_TRISTATE) {
+				sym_calc_value(modules_sym);
+				if (modules_sym->curr.tri == no)
+					type = S_BOOLEAN;
+			}
+			switch (type) {
+			case S_BOOLEAN:
+			case S_TRISTATE:
+				switch (sym_get_tristate_value(sym)) {
+				case no:
+					break;
+				case mod:
+				case yes:
+					test_select(sym);
+					break;
+				}
+				break;
+			case S_STRING:
+			case S_HEX:
+			case S_INT:
+				break;
+			}
+		}
+
+	next:
+		if (menu->list) {
+			menu = menu->list;
+			continue;
+		}
+		if (menu->next)
+			menu = menu->next;
+		else while ((menu = menu->parent)) {
+			if (menu->next) {
+				menu = menu->next;
+				break;
+			}
+		}
+	}
+
+	embedded->curr.tri = embed_tri;
+}
+
 int conf_read(const char *name)
 {
 	struct symbol *sym, *choice_sym;
@@ -386,6 +507,7 @@ int conf_read(const char *name)
 
 	sym_add_change_count(conf_warnings || conf_unsaved);
 
+	test_conf();
 	return 0;
 }
 
@@ -550,6 +672,8 @@ int conf_write(const char *name)
 
 	sym_set_change_count(0);
 
+	test_conf();
+
 	return 0;
 }
 

