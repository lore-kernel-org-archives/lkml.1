Return-Path: <linux-kernel-owner+w=401wt.eu-S1751303AbZKGGqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbZKGGqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZKGGp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:45:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:45228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751084AbZKGGpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:45:46 -0500
X-Authenticated: #154622
X-Provags-ID: V01U2FsdGVkX19J2Hw4Sp9JrMOOZW1d3rFTDT4oFZPHhCWny7dUOT
	MbROlsznmkQSgV
From: Bernhard Kaindl <bernhard.kaindl@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Kaindl <bernhard.kaindl@gmx.net>, linux-kbuild@vger.kernel.org
Subject: [PATCH 2/4] menuconfig: allow editing of remarks for config symbols
Date: Sat,  7 Nov 2009 07:45:38 +0100
Message-Id: <617c40ae9e206b4f246998fe075644c752bc0bc3.1256767265.git.aragorn@Anduril.ringwar.org>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
 <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
In-Reply-To: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend menuconfig to allow editing of remarks for config symbols:

Add a new key to lxdialog (currently '<') which, when pressed,
is forwarded to menuconfig, which handles it similar to the
search key ('/') which can be used at any time, but passes the
currently selected menu entry to conf_remark()

conf_remark() is based on conf_string(), which allows to edit
a string, but before, it checks if the passed menu entry is a
config symbol, and if not it displays a short notice saying that
it currently does not support editing comments for a pure menu
entries without attached config symbol.

It then allows to edit a string, which is initialized from the
sym->remark entry and if the user changed the string, it updates
sym->remark and sets things up so that menuconfig asks to save
the config before exiting, so the changed remark is saved in
that go.

Signed-off-by: Bernhard Kaindl <bernhard.kaindl@gmx.net>
---
 scripts/kconfig/lxdialog/menubox.c |    3 ++
 scripts/kconfig/mconf.c            |   51 ++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index fa9d633..6b6bc48 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -383,6 +383,7 @@ do_resize:
 		case 'n':
 		case 'm':
 		case '/':
+		case '<':
 			/* save scroll info */
 			*s_scroll = scroll;
 			delwin(menu);
@@ -402,6 +403,8 @@ do_resize:
 				return 6;
 			case '/':
 				return 7;
+			case '<':
+				return 8;
 			}
 			return 0;
 		case 'h':
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index d829535..50a9b10 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -276,6 +276,7 @@ static int single_menu_mode;
 static void conf(struct menu *menu);
 static void conf_choice(struct menu *menu);
 static void conf_string(struct menu *menu);
+static void conf_remark(struct menu *menu);
 static void conf_load(void);
 static void conf_save(void);
 static void show_textbox(const char *title, const char *text, int r, int c);
@@ -619,6 +620,9 @@ static void conf(struct menu *menu)
 		case 7:
 			search_conf();
 			break;
+		case 8:
+			conf_remark(submenu);
+			break;
 		}
 	}
 }
@@ -743,6 +747,53 @@ static void conf_string(struct menu *menu)
 	}
 }
 
+/**
+ * Based on conf_string(), this edits the remark for a config symbol
+ */
+static void conf_remark(struct menu *menu)
+{
+	const char *prompt = menu_get_prompt(menu);
+
+	if (!prompt || !menu->sym) {
+		show_textbox(NULL,
+			N_("Editing comments for menus without a config symbol\n"
+				"is currently not supported."), 6, 63);
+		return;
+	}
+
+	while (1) {
+		int res;
+		dialog_clear();
+		res = dialog_inputbox(prompt ? _(prompt) : _("Main Menu"),
+				      _("Edit the remark below"), 10, 75,
+				      menu->sym->remark);
+		switch (res) {
+		case 0:
+			if (!dialog_input_result[0] && !menu->sym->remark)
+				return;
+			if (menu->sym->remark) {
+				if (!strcmp(menu->sym->remark, dialog_input_result))
+					return;
+				free(menu->sym->remark);
+			}
+			if (dialog_input_result[0]) {
+				menu->sym->remark = strdup(dialog_input_result);
+			} else {
+				menu->sym->remark = NULL;
+			}
+			/* Write new .config{,-remarks} on exit: */
+			sym_add_change_count(1);
+			sym_clear_all_valid();
+			return;
+		case 1:
+			show_help(menu);
+			break;
+		case KEY_ESC:
+			return;
+		}
+	}
+}
+
 static void conf_load(void)
 {
 
-- 
1.6.0.4

