Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbXIAVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbXIAVps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbXIAVph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:45:37 -0400
Received: from sa12.bezeqint.net ([192.115.104.27]:50596 "EHLO
	sa12.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481AbXIAVpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:45:31 -0400
X-Greylist: delayed 3115 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 17:45:31 EDT
From: Shlomi Fish <shlomif-lkml@iglu.org.il>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Date: Sat, 1 Sep 2007 23:53:20 +0300
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BFd2GwlEylpr8TW"
Message-Id: <200709012353.21036.shlomif-lkml@iglu.org.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_BFd2GwlEylpr8TW
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all!

[ I'm not subscribed to this list so please CC me on your replies. ]

This patch is against kernel-2.6.23-rc4, and aims to enhance the "make 
xconfig" search dialog. At the moment what it does is allow searching on 
the "help" field of the menus as well as the "name" of the symbol. Try 
searching for "you will get a watchdog" before and after the patch to see 
what I mean.

I'm next planning to add a radio button for choosing between regex match and 
substring match, as well as implement keywords search.

This change involved adding the sym_generic_search function to the LKC, and 
implementing sym_re_search using it.

Regards,

	Shlomi Fish

---------------------------------------------------------------------
Shlomi Fish      shlomif@iglu.org.il
Homepage:        http://www.shlomifish.org/

If it's not in my E-mail it doesn't happen. And if my E-mail is saying
one thing, and everything else says something else - E-mail will conquer.
    -- An Israeli Linuxer
-- 

---------------------------------------------------------------------
Shlomi Fish      shlomif@iglu.org.il
Homepage:        http://www.shlomifish.org/

If it's not in my E-mail it doesn't happen. And if my E-mail is saying
one thing, and everything else says something else - E-mail will conquer.
    -- An Israeli Linuxer

--Boundary-00=_BFd2GwlEylpr8TW
Content-Type: text/x-diff;
  charset="us-ascii";
  name="xconfig-search-patch-take2-04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xconfig-search-patch-take2-04.diff"

--- linux-2.6.23-rc4/scripts/kconfig/qconf.cc.orig	2007-09-01 21:15:39.017466409 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/qconf.cc	2007-09-01 22:54:14.099825858 +0300
@@ -1245,6 +1245,12 @@
 	}
 }
 
+static int search_filter(struct symbol *sym, void *context)
+{
+	FindQuery *query = (FindQuery *)context;
+	return query->sym_matches(sym);
+}
+
 void ConfigSearchWindow::search(void)
 {
 	struct symbol **p;
@@ -1255,7 +1261,9 @@
 	list->list->clear();
 	info->clear();
 
-	result = sym_re_search(editField->text().latin1());
+	FindQuery query(editField->text(), REGEX);
+
+	result = sym_generic_search(search_filter, (void *)&query);
 	if (!result)
 		return;
 	for (p = result; *p; p++) {
@@ -1265,6 +1273,57 @@
 	}
 }
 
+FindQuery::FindQuery(QString q, SEARCH_TYPE t, bool a_case) :
+	query(q), search_type(t), case_sensitive(a_case)
+{
+	compiled_regex = NULL;
+	if (search_type == REGEX)
+	{
+		compiled_regex = new QRegExp(query, case_sensitive);
+	}
+}
+
+FindQuery::~FindQuery()
+{
+	if (compiled_regex)
+	{
+		delete compiled_regex;
+		compiled_regex = NULL;
+	}
+}
+
+bool FindQuery::string_matches(const char *string)
+{
+	QString qs(string);
+
+	if (search_type == SUBSTRING)
+	{
+		return qs.contains(query, case_sensitive);
+	}
+	else if (search_type == REGEX)
+	{
+		return (compiled_regex->search(qs) >= 0);
+	}
+	else
+	{
+		return false;
+	}
+}
+
+bool FindQuery::sym_matches(struct symbol *sym)
+{
+	if (!sym)
+	{
+		return false;
+	}
+
+	return (string_matches(sym->name) ||
+		(sym->prop &&
+		 sym->prop->menu &&
+		 string_matches(sym->prop->menu->help)
+		));
+}
+
 /*
  * Construct the complete config widget
  */
--- linux-2.6.23-rc4/scripts/kconfig/qconf.h.orig	2007-09-01 21:15:33.537030610 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/qconf.h	2007-09-01 21:51:07.786743297 +0300
@@ -332,3 +332,21 @@
 	QSplitter* split1;
 	QSplitter* split2;
 };
+
+enum SEARCH_TYPE { SUBSTRING, KEYWORDS, REGEX };
+class FindQuery
+{
+	public:
+	bool case_sensitive;
+	SEARCH_TYPE search_type;
+	QString query;
+	QRegExp * compiled_regex;
+
+	public:
+	FindQuery() : query("") { case_sensitive = false; search_type = SUBSTRING; }
+	FindQuery(QString q, SEARCH_TYPE t, bool a_case = false);
+	~FindQuery();
+	bool string_matches(const char *);
+	bool sym_matches(struct symbol *sym);
+};
+
--- linux-2.6.23-rc4/scripts/kconfig/lkc.h.orig	2007-09-01 19:56:36.528350007 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/lkc.h	2007-09-01 19:57:57.758809341 +0300
@@ -111,6 +111,9 @@
 struct property *prop_alloc(enum prop_type type, struct symbol *sym);
 struct symbol *prop_get_symbol(struct property *prop);
 
+typedef int (*sym_search_filter_t)(struct symbol *sym, void *context);
+struct symbol **sym_generic_search(sym_search_filter_t filter, void *context);
+
 static inline tristate sym_get_tristate_value(struct symbol *sym)
 {
 	return sym->curr.tri;
--- linux-2.6.23-rc4/scripts/kconfig/symbol.c.orig	2007-09-01 21:24:07.885930947 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/symbol.c	2007-09-01 20:41:58.420791258 +0300
@@ -717,23 +717,39 @@
 	return symbol;
 }
 
+static int re_search_filter(struct symbol *sym, void *re_void)
+{
+	return (regexec((regex_t*)re_void, sym->name, 0, NULL, 0) == 0);
+}
+
 struct symbol **sym_re_search(const char *pattern)
 {
-	struct symbol *sym, **sym_arr = NULL;
-	int i, cnt, size;
 	regex_t re;
+	struct symbol **results;
 
-	cnt = size = 0;
-	/* Skip if empty */
 	if (strlen(pattern) == 0)
 		return NULL;
 	if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB|REG_ICASE))
 		return NULL;
 
+	results = sym_generic_search(re_search_filter, (void *)&re);
+
+	regfree(&re);
+
+	return results;
+}
+
+struct symbol **sym_generic_search(sym_search_filter_t filter, void *context)
+{
+	struct symbol *sym, **sym_arr = NULL;
+	int i, cnt, size;
+
+	cnt = size = 0;
+
 	for_all_symbols(i, sym) {
 		if (sym->flags & SYMBOL_CONST || !sym->name)
 			continue;
-		if (regexec(&re, sym->name, 0, NULL, 0))
+		if (!filter(sym, context))
 			continue;
 		if (cnt + 1 >= size) {
 			void *tmp = sym_arr;
@@ -748,7 +764,6 @@
 	}
 	if (sym_arr)
 		sym_arr[cnt] = NULL;
-	regfree(&re);
 
 	return sym_arr;
 }

--Boundary-00=_BFd2GwlEylpr8TW--
