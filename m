Return-Path: <linux-kernel-owner+w=401wt.eu-S1765649AbXINOdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765649AbXINOdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXINOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:33:17 -0400
Received: from sa7.bezeqint.net ([192.115.104.21]:36909 "EHLO sa7.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbXINOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:33:16 -0400
X-Greylist: delayed 2665 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 10:33:15 EDT
From: Shlomi Fish <shlomif-lkml@freehackers.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement (rev8)
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 14 Sep 2007 16:48:35 +0300
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709141648.35745.shlomif-lkml@freehackers.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

[ I'm not subscribed to this list so please CC me on your replies. ]

This patch adds an option to use either substring match, regular expression 
match, or keywords search in the "make xconfig" Edit->Find dialog.

It also allows searching on the "help" field of the menus as well as 
the "name" of the symbol.

This change involved adding the sym_generic_search function to the LKC, and 
implementing sym_re_search using it.

Regards,

	Shlomi Fish

--- linux-2.6.23-rc4/scripts/kconfig/qconf.cc.orig	2007-09-01 
21:15:39.017466409 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/qconf.cc	2007-09-08 11:29:31.357869409 
+0300
@@ -1199,6 +1199,23 @@
 	layout2->addWidget(searchButton);
 	layout1->addLayout(layout2);
 
+	// Initialize the "Search Type" button group.
+	searchType = new QVButtonGroup("Search Type", this, "searchType");
+
+	substringSearch = new QRadioButton(
+		"Substring Match", searchType, "Substring Match"
+		);
+
+	keywordsSearch = new QRadioButton("Keywords", searchType, "Keywords");
+
+	regexSearch = new QRadioButton(
+		"Regular Expression", searchType, "Regular Expression"
+		);
+
+	substringSearch->setChecked(TRUE);
+	layout1->addWidget(searchType);
+
+	// Initialize the ConfigView and ConfigInfoView
 	split = new QSplitter(this);
 	split->setOrientation(QSplitter::Vertical);
 	list = new ConfigView(split, name);
@@ -1245,6 +1262,20 @@
 	}
 }
 
+SEARCH_TYPE ConfigSearchWindow::getSearchType()
+{
+	return	substringSearch->isChecked() ? SUBSTRING :
+		regexSearch->isChecked() ? REGEX :
+		KEYWORDS;
+}
+
+
+static int search_filter(struct symbol *sym, void *context)
+{
+	FindQuery *query = (FindQuery *)context;
+	return query->sym_matches(sym);
+}
+
 void ConfigSearchWindow::search(void)
 {
 	struct symbol **p;
@@ -1255,7 +1286,9 @@
 	list->list->clear();
 	info->clear();
 
-	result = sym_re_search(editField->text().latin1());
+	FindQuery query(editField->text(), getSearchType());
+
+	result = sym_generic_search(search_filter, (void *)&query);
 	if (!result)
 		return;
 	for (p = result; *p; p++) {
@@ -1265,6 +1298,114 @@
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
+	else if (search_type == KEYWORDS)
+	{
+		compile_keywords();
+	}
+}
+
+void FindQuery::compile_keywords()
+{
+	QRegExp split_words("\\s+");
+	QStringList bare_words = QStringList::split(split_words, query);
+
+	QStringList::iterator it;
+	for ( it = bare_words.begin(); it != bare_words.end(); ++it )
+	{
+		QString escaped = QRegExp::escape(*it);
+		
+		keywords.append(QRegExp(QString("\\b") + escaped + "\\b"));
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
+bool FindQuery::string_matches_regex(QRegExp & re, const char *string)
+{
+	QString qs(string);
+
+	return (re.search(qs) >= 0);
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
+		return string_matches_regex(*compiled_regex, string);
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
+	if (search_type == KEYWORDS)
+	{
+		return sym_matches_keywords(sym);
+	}
+	else
+	{
+		return sym_matches_atom(sym);
+	}
+
+}
+
+bool FindQuery::sym_matches_atom(struct symbol *sym)
+{
+	return (string_matches(sym->name) ||
+		(sym->prop &&
+		 sym->prop->menu &&
+		 string_matches(sym->prop->menu->help)
+		));
+}
+
+bool FindQuery::sym_matches_keywords(struct symbol *sym)
+{
+	QValueList<QRegExp>::iterator it;
+
+	for ( it = keywords.begin(); it != keywords.end(); ++it )
+	{
+		if (!(string_matches_regex(*it, sym->name)
+				||
+			(sym->prop &&
+			 sym->prop->menu &&
+			 string_matches_regex(*it, sym->prop->menu->help))))
+		{
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /*
  * Construct the complete config widget
  */
--- linux-2.6.23-rc4/scripts/kconfig/qconf.h.orig	2007-09-01 
21:15:33.537030610 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/qconf.h	2007-09-08 11:12:18.015699416 
+0300
@@ -4,6 +4,8 @@
  */
 
 #include <qlistview.h>
+#include <qradiobutton.h>
+#include <qvbuttongroup.h>
 #if QT_VERSION >= 300
 #include <qsettings.h>
 #else
@@ -275,6 +277,7 @@
 	bool _showDebug;
 };
 
+enum SEARCH_TYPE { SUBSTRING, KEYWORDS, REGEX };
 class ConfigSearchWindow : public QDialog {
 	Q_OBJECT
 	typedef class QDialog Parent;
@@ -288,11 +291,15 @@
 protected:
 	QLineEdit* editField;
 	QPushButton* searchButton;
+	QVButtonGroup *searchType;
+	QRadioButton *substringSearch, *keywordsSearch, *regexSearch;
 	QSplitter* split;
 	ConfigView* list;
 	ConfigInfoView* info;
 
 	struct symbol **result;
+
+	SEARCH_TYPE getSearchType();
 };
 
 class ConfigMainWindow : public QMainWindow {
@@ -332,3 +339,25 @@
 	QSplitter* split1;
 	QSplitter* split2;
 };
+
+class FindQuery
+{
+	public:
+	bool case_sensitive;
+	SEARCH_TYPE search_type;
+	QString query;
+	QRegExp * compiled_regex;
+	QValueList<QRegExp> keywords;
+
+	public:
+	FindQuery() : query("") { case_sensitive = false; search_type = SUBSTRING; }
+	FindQuery(QString q, SEARCH_TYPE t, bool a_case = false);
+	~FindQuery();
+	void compile_keywords();
+	bool string_matches(const char *);
+	bool string_matches_regex(QRegExp & re, const char *string);
+	bool sym_matches(struct symbol *sym);
+	bool sym_matches_keywords(struct symbol *sym);
+	bool sym_matches_atom(struct symbol *sym);
+};
+
--- linux-2.6.23-rc4/scripts/kconfig/lkc.h.orig	2007-09-01 19:56:36.528350007 
+0300
+++ linux-2.6.23-rc4/scripts/kconfig/lkc.h	2007-09-01 19:57:57.758809341 +0300
@@ -111,6 +111,9 @@
 struct property *prop_alloc(enum prop_type type, struct symbol *sym);
 struct symbol *prop_get_symbol(struct property *prop);
 
+typedef int (*sym_search_filter_t)(struct symbol *sym, void *context);
+struct symbol **sym_generic_search(sym_search_filter_t filter, void 
*context);
+
 static inline tristate sym_get_tristate_value(struct symbol *sym)
 {
 	return sym->curr.tri;
--- linux-2.6.23-rc4/scripts/kconfig/symbol.c.orig	2007-09-01 
21:24:07.885930947 +0300
+++ linux-2.6.23-rc4/scripts/kconfig/symbol.c	2007-09-01 20:41:58.420791258 
+0300
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
