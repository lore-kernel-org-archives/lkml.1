Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYL0VrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYL0VrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 16:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYL0Vqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 16:46:53 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56351 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYL0Vqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 16:46:53 -0500
Date: Sat, 27 Dec 2008 22:48:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig: conf segfault (with invalid kconfig contents)
Message-ID: <20081227214826.GB16901@uranus.ravnborg.org>
References: <20071024031401.GA13376@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024031401.GA13376@lixom.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:14:01PM -0500, Olof Johansson wrote:
> Hi,
> 
> Sorry, no patch, just a bugreport. :)
> 
> I did a mistake in some Kconfig changes (locally) and got a segfault
> from conf:
> 
> #0  0x10005fe0 in sym_check_deps ()
> #1  0x10005f40 in sym_check_expr_deps ()
> #2  0x1000605c in sym_check_deps ()
> #3  0x1000f3f4 in conf_parse ()
> #4  0x10003824 in main ()
> 
> 
> The way to reproduce is simple. I just added the equivalent of this
> to arch/powerpc/Kconfig:
> 
> ---
> config TEST1
>         bool
>         depends on TEST2 && PCI
>         select TEST2
> 
> config TEST2
>         bool
> ---
> 
> Neither TEST1 nor TEST2 exists in the existing .config when I run make
> oldconfig to reproduce.
> 
> It's clearly invalid in that it depends on what it selects, but it should
> just abort instead.

Hi Olof.

BAsed on your nice small testcase I have finally looked at it
and fixed the bug. I forgot to credit you in the patch I sent
to lkml (and linux-kbuild) but I have done so in my local repository.

See updated commit below.

	Sam

[PATCH 1/3] kconfig: improve readout when we hit recursive dependencies

Following sample:
    config TEST1
            bool
            depends on TEST2 && PCI
            select TEST2

    config TEST2
            bool

Will result in the following output:

    Kconfig:1:error: found recursive dependency:
                TEST1
             -> TEST2 (arch/x86/Kconfig:6)
             -> TEST1 (arch/x86/Kconfig:1)

The sample above gave a segmentation fault
which is also fixed by this patch.

To save the filename/lineno info add a new property P_SYMBOL
which is added each time we see a symbol definition.

Thanks to Olof for reporting and providing the sample Kconfig.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Olof Johansson <olof@lixom.net>
Cc: Olof Johansson <olof@lixom.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/expr.h   |    1 +
 scripts/kconfig/menu.c   |    2 ++
 scripts/kconfig/symbol.c |   11 ++++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 6408fef..d587895 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -132,6 +132,7 @@ enum prop_type {
 	P_SELECT,   /* select BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
+	P_SYMBOL,   /* where a symbol is defined */
 };
 
 struct property {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 07ff8d1..aa0e2f2 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -55,6 +55,8 @@ void menu_add_entry(struct symbol *sym)
 	*last_entry_ptr = menu;
 	last_entry_ptr = &menu->next;
 	current_entry = menu;
+	if (sym)
+		 menu_add_prop(P_SYMBOL, NULL, NULL, NULL);
 }
 
 void menu_end_entry(void)
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..474dae2 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -856,8 +856,9 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	struct property *prop;
 
 	if (sym->flags & SYMBOL_CHECK) {
-		fprintf(stderr, "%s:%d:error: found recursive dependency: %s",
-		        sym->prop->file->name, sym->prop->lineno,
+		fprintf(stderr, "%s:%d:error: found recursive dependency:\n",
+		        sym->prop->file->name, sym->prop->lineno);
+		fprintf(stderr, "\t    %s\n",
 			sym->name ? sym->name : "<choice>");
 		return sym;
 	}
@@ -877,7 +878,9 @@ struct symbol *sym_check_deps(struct symbol *sym)
 	}
 
 	if (sym2) {
-		fprintf(stderr, " -> %s", sym->name ? sym->name : "<choice>");
+		fprintf(stderr, "\t -> %s (%s:%d)\n",
+		        sym->name ? sym->name : "<choice>",
+			sym->prop->file->name, sym->prop->lineno);
 		if (sym2 == sym) {
 			fprintf(stderr, "\n");
 			zconfnerrs++;
@@ -937,6 +940,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "select";
 	case P_RANGE:
 		return "range";
+	case P_SYMBOL:
+		return "symbol";
 	case P_UNKNOWN:
 		break;
 	}
-- 
1.6.0.2.GIT

