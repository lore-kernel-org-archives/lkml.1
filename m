Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXJTDVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXJTDVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 23:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXJTDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 23:21:43 -0400
Received: from xenotime.net ([66.160.160.81]:57123 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751497AbXJTDVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 23:21:42 -0400
Date: Fri, 19 Oct 2007 20:21:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.23-git Kconfig regression
Message-Id: <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
In-Reply-To: <20071019195535.0dbafd39.rdunlap@xenotime.net>
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071019184607.06e1eef9.randy.dunlap@oracle.com>
	<20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<47196165.8070406@oracle.com>
	<20071019195535.0dbafd39.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__19_Oct_2007_20_21_40_-0700_gpHnn=U0bWF_a+k1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Fri__19_Oct_2007_20_21_40_-0700_gpHnn=U0bWF_a+k1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Oct 2007 19:55:35 -0700 Randy Dunlap wrote:

> On Fri, 19 Oct 2007 19:01:09 -0700 Randy Dunlap wrote:
> 
> > >>> I noticed a regression, visible in the drivers/usb/gadget Kconfig;
> > >>> it seems to be quite recent.
> > >>>
> > >>> ...
> > >> Hm, it does look very odd.  It looks like it has something to
> > >> do with <choice> working differently for some reason.
> > >>
> > >> In xconfig, I set all of the View Options and when I click on one
> > >> of the periph. controllers, it says
> > >>
> > >> 	depends on =y && PCI
> > > 
> > > That's what I saw too.  Looked dubious ... 
> > > 
> > > 
> > >> but if I back up to -git7, it says
> > >>
> > >> 	depends on <choice> && PCI
> > > 
> > > And that git7 thing doesn't look _quite_ so odd.  Did git7 actually
> > > let you configure a modular GOKU (for example), i.e. work correctly?
> > 
> > Yes, -git9 does.
> > 
> > Looks to me like it broke on -git10.  -git9 is OK.
> > 
> > >> I'll keep looking.
> > > 
> > > Thanks.  Kconfig is one of the areas I prefer to let others
> > > be the experts.  :)
> 
> [hm, odd email problems, changing SMTP]
> 
> David,
> 
> Just a small update.
> 
> If I set USB gadget support to Y instead of M and peripheral
> controller menu item to Y instead of M, then I can select any of the
> 4 periph. controllers that are available to me.  (on -git14)
> I don't know why it's like this though.

David,

My (quick, meaning that I may have missed something) testing
indicates that the problem is in the patches attached.

Can you revert them and test that?

>From git:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5bf3d891a6a0fb5aa122792d965e3774108b923

Change kconfig behavior so that mixing bool and tristate config settings in
a choice is possible and has the desired effect of offering just the
tristate options individually if the choice gets set to M, and a normal
boolean selection if the choice gets set to Y.

Odd, I don't recall seeing this patch...

---
~Randy

--Multipart=_Fri__19_Oct_2007_20_21_40_-0700_gpHnn=U0bWF_a+k1
Content-Type: text/x-patch;
 name="git9-10.diff"
Content-Disposition: attachment;
 filename="git9-10.diff"
Content-Transfer-Encoding: 7bit

diff -u b/Makefile b/Makefile
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -235,16 +235,23 @@ void menu_finalize(struct menu *parent)
 	sym = parent->sym;
 	if (parent->list) {
 		if (sym && sym_is_choice(sym)) {
-			/* find the first choice value and find out choice type */
+			/* find out choice type */
+			enum symbol_type type = S_UNKNOWN;
+
 			for (menu = parent->list; menu; menu = menu->next) {
-				if (menu->sym) {
-					current_entry = parent;
-					menu_set_type(menu->sym->type);
-					current_entry = menu;
-					menu_set_type(sym->type);
-					break;
+				if (menu->sym && menu->sym->type != S_UNKNOWN) {
+					if (type == S_UNKNOWN)
+						type = menu->sym->type;
+					if (type != S_BOOLEAN)
+						break;
+					if (menu->sym->type == S_TRISTATE) {
+						type = S_TRISTATE;
+						break;
+					}
 				}
 			}
+			current_entry = parent;
+			menu_set_type(type);
 			parentdep = expr_alloc_symbol(sym);
 		} else if (parent->prompt)
 			parentdep = parent->prompt->visible.expr;
@@ -253,7 +260,16 @@ void menu_finalize(struct menu *parent)
 
 		for (menu = parent->list; menu; menu = menu->next) {
 			basedep = expr_transform(menu->dep);
-			basedep = expr_alloc_and(expr_copy(parentdep), basedep);
+			dep = parentdep;
+			if (sym && sym_is_choice(sym) && menu->sym) {
+				enum symbol_type type = menu->sym->type;
+
+				if (type == S_UNKNOWN)
+					type = sym->type;
+			     if (type != S_TRISTATE)
+					dep = expr_alloc_comp(E_EQUAL, sym, &symbol_yes);
+			}
+			basedep = expr_alloc_and(expr_copy(dep), basedep);
 			basedep = expr_eliminate_dups(basedep);
 			menu->dep = basedep;
 			if (menu->sym)
@@ -326,7 +342,8 @@ void menu_finalize(struct menu *parent)
 					    "values not supported");
 			}
 			current_entry = menu;
-			menu_set_type(sym->type);
+			if (menu->sym->type == S_UNKNOWN)
+				menu_set_type(sym->type);
 			menu_add_symbol(P_CHOICE, sym, NULL);
 			prop = sym_get_choice_prop(sym);
 			for (ep = &prop->expr; *ep; ep = &(*ep)->left.expr)
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -84,12 +84,15 @@ void str_free(struct gstr *gs)
 /* Append to growable string */
 void str_append(struct gstr *gs, const char *s)
 {
-	size_t l = strlen(gs->s) + strlen(s) + 1;
-	if (l > gs->len) {
-		gs->s   = realloc(gs->s, l);
-		gs->len = l;
+	size_t l;
+	if (s) {
+		l = strlen(gs->s) + strlen(s) + 1;
+		if (l > gs->len) {
+			gs->s   = realloc(gs->s, l);
+			gs->len = l;
+		}
+		strcat(gs->s, s);
 	}
-	strcat(gs->s, s);
 }
 
 /* Append printf formatted string to growable string */

--Multipart=_Fri__19_Oct_2007_20_21_40_-0700_gpHnn=U0bWF_a+k1--
