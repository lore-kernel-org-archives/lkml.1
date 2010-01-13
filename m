Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974Ab0AMQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0AMQCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032Ab0AMQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:02:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:32846 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0AMQCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:02:47 -0500
Date: Wed, 13 Jan 2010 17:02:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: zippel@linux-m68k.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Improve kconfig symbol hashing
Message-ID: <20100113160244.GA14012@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve kconfig symbol hashing

While looking for something else I noticed that the symbol
hash function used by kconfig is quite poor. It doesn't
use any of the standard hash techniques but simply
adds up the string and then uses power of two masking,
which is both known to perform poorly.

The current x86 kconfig has over 7000 symbols.

When I instrumented it showed that the minimum hash chain
length was 16 and a significant number of them was over
30. 

It didn't help that the hash table size was only 256 buckets.

This patch increases the hash table size to a larger prime
and switches to a FNV32 hash. I played around with a couple of hash
functions, but that one seemed to perform best with reasonable
hash table sizes. 

Increasing the hash table size even further didn't
seem like a good idea, because there are a couple of global
walks which walk the complete hash table.

I also moved the unnamed bucket to 0. It's still the longest
of all the buckets (44 entries), but hopefully it's not
often hit except for the global walk which doesn't care.

The result is a much nicer distribution:
(first column bucket length, second number of buckets with that length)

1: 3505
2: 1236
3: 294
4: 52
5: 3
47: 1		<--- this is the unnamed symbols bucket

There are still some 5+ buckets, but increasing the hash table
even more would be likely not worth it.

This also cleans up the code slightly by removing hard coded
magic numbers.

I didn't notice a big performance difference either way 
on my Nehalem system, but I presume it'll help somewhat
on slower systems.

---
 scripts/kconfig/expr.h              |    5 ++---
 scripts/kconfig/symbol.c            |   29 +++++++++++++++++------------
 scripts/kconfig/zconf.tab.c_shipped |    2 +-
 scripts/kconfig/zconf.y             |    2 +-
 4 files changed, 21 insertions(+), 17 deletions(-)

Index: linux-2.6.33-rc3-ak/scripts/kconfig/symbol.c
===================================================================
--- linux-2.6.33-rc3-ak.orig/scripts/kconfig/symbol.c
+++ linux-2.6.33-rc3-ak/scripts/kconfig/symbol.c
@@ -651,12 +651,20 @@ bool sym_is_changable(struct symbol *sym
 	return sym->visible > sym->rev_dep.tri;
 }
 
+static unsigned strhash(const char *s)
+{
+	/* fnv32 hash */
+	unsigned hash = 2166136261U;
+	for (; *s; s++)
+		hash = (hash ^ *s) * 0x01000193;
+	return hash;
+}
+
 struct symbol *sym_lookup(const char *name, int flags)
 {
 	struct symbol *symbol;
-	const char *ptr;
 	char *new_name;
-	int hash = 0;
+	int hash;
 
 	if (name) {
 		if (name[0] && !name[1]) {
@@ -666,12 +674,11 @@ struct symbol *sym_lookup(const char *na
 			case 'n': return &symbol_no;
 			}
 		}
-		for (ptr = name; *ptr; ptr++)
-			hash += *ptr;
-		hash &= 0xff;
+		hash = strhash(name) % SYMBOL_HASHSIZE;
 
 		for (symbol = symbol_hash[hash]; symbol; symbol = symbol->next) {
-			if (!strcmp(symbol->name, name) &&
+			if (symbol->name &&
+			    !strcmp(symbol->name, name) &&
 			    (flags ? symbol->flags & flags
 				   : !(symbol->flags & (SYMBOL_CONST|SYMBOL_CHOICE))))
 				return symbol;
@@ -679,7 +686,7 @@ struct symbol *sym_lookup(const char *na
 		new_name = strdup(name);
 	} else {
 		new_name = NULL;
-		hash = 256;
+		hash = 0;
 	}
 
 	symbol = malloc(sizeof(*symbol));
@@ -703,7 +710,6 @@ struct symbol *sym_lookup(const char *na
 struct symbol *sym_find(const char *name)
 {
 	struct symbol *symbol = NULL;
-	const char *ptr;
 	int hash = 0;
 
 	if (!name)
@@ -716,12 +722,11 @@ struct symbol *sym_find(const char *name
 		case 'n': return &symbol_no;
 		}
 	}
-	for (ptr = name; *ptr; ptr++)
-		hash += *ptr;
-	hash &= 0xff;
+	hash = strhash(name) % SYMBOL_HASHSIZE;
 
 	for (symbol = symbol_hash[hash]; symbol; symbol = symbol->next) {
-		if (!strcmp(symbol->name, name) &&
+		if (symbol->name &&
+		    !strcmp(symbol->name, name) &&
 		    !(symbol->flags & SYMBOL_CONST))
 				break;
 	}
Index: linux-2.6.33-rc3-ak/scripts/kconfig/zconf.tab.c_shipped
===================================================================
--- linux-2.6.33-rc3-ak.orig/scripts/kconfig/zconf.tab.c_shipped
+++ linux-2.6.33-rc3-ak/scripts/kconfig/zconf.tab.c_shipped
@@ -104,7 +104,7 @@ static void zconf_error(const char *err,
 static void zconferror(const char *err);
 static bool zconf_endtoken(struct kconf_id *id, int starttoken, int endtoken);
 
-struct symbol *symbol_hash[257];
+struct symbol *symbol_hash[SYMBOL_HASHSIZE];
 
 static struct menu *current_menu, *current_entry;
 
Index: linux-2.6.33-rc3-ak/scripts/kconfig/zconf.y
===================================================================
--- linux-2.6.33-rc3-ak.orig/scripts/kconfig/zconf.y
+++ linux-2.6.33-rc3-ak/scripts/kconfig/zconf.y
@@ -27,7 +27,7 @@ static void zconf_error(const char *err,
 static void zconferror(const char *err);
 static bool zconf_endtoken(struct kconf_id *id, int starttoken, int endtoken);
 
-struct symbol *symbol_hash[257];
+struct symbol *symbol_hash[SYMBOL_HASHSIZE];
 
 static struct menu *current_menu, *current_entry;
 
Index: linux-2.6.33-rc3-ak/scripts/kconfig/expr.h
===================================================================
--- linux-2.6.33-rc3-ak.orig/scripts/kconfig/expr.h
+++ linux-2.6.33-rc3-ak/scripts/kconfig/expr.h
@@ -86,7 +86,7 @@ struct symbol {
 	struct expr_value rev_dep;
 };
 
-#define for_all_symbols(i, sym) for (i = 0; i < 257; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
+#define for_all_symbols(i, sym) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
 
 #define SYMBOL_CONST      0x0001  /* symbol is const */
 #define SYMBOL_CHECK      0x0008  /* used during dependency checking */
@@ -108,8 +108,7 @@ struct symbol {
 #define SYMBOL_DEF4       0x80000  /* symbol.def[S_DEF_4] is valid */
 
 #define SYMBOL_MAXLENGTH	256
-#define SYMBOL_HASHSIZE		257
-#define SYMBOL_HASHMASK		0xff
+#define SYMBOL_HASHSIZE		9973
 
 /* A property represent the config options that can be associated
  * with a config "symbol".
