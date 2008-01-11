Return-Path: <linux-kernel-owner+w=401wt.eu-S1763306AbYAKWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763306AbYAKWzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762142AbYAKWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:55:12 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:53019 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761854AbYAKWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:55:10 -0500
Subject: [PATCH 8/10] kconfig: gettext support for xconfig
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 23:52:07 +0100
Message-Id: <1200091927.10603.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Full gettext support for xconfig.

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

 kbuild-szilard/scripts/kconfig/qconf.cc |   93 ++++++++++++++++----------------
 1 file changed, 49 insertions(+), 44 deletions(-)

diff -puN scripts/kconfig/qconf.cc~kconfig-i18n-15-qconfig-i18n scripts/kconfig/qconf.cc
--- kbuild/scripts/kconfig/qconf.cc~kconfig-i18n-15-qconfig-i18n	2008-01-11 22:27:16.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/qconf.cc	2008-01-11 22:27:16.000000000 +0100
@@ -114,7 +114,7 @@ void ConfigItem::updateMenu(void)
 
 	sym = menu->sym;
 	prop = menu->prompt;
-	prompt = QString::fromLocal8Bit(menu_get_prompt(menu));
+	prompt = _(menu_get_prompt(menu));
 
 	if (prop) switch (prop->type) {
 	case P_MENU:
@@ -208,7 +208,7 @@ void ConfigItem::updateMenu(void)
 		break;
 	}
 	if (!sym_has_value(sym) && visible)
-		prompt += " (NEW)";
+		prompt += _(" (NEW)");
 set_prompt:
 	setText(promptColIdx, prompt);
 }
@@ -346,7 +346,7 @@ ConfigList::ConfigList(ConfigView* p, co
 
 	for (i = 0; i < colNr; i++)
 		colMap[i] = colRevMap[i] = -1;
-	addColumn(promptColIdx, "Option");
+	addColumn(promptColIdx, _("Option"));
 
 	reinit();
 }
@@ -360,14 +360,14 @@ void ConfigList::reinit(void)
 	removeColumn(nameColIdx);
 
 	if (showName)
-		addColumn(nameColIdx, "Name");
+		addColumn(nameColIdx, _("Name"));
 	if (showRange) {
 		addColumn(noColIdx, "N");
 		addColumn(modColIdx, "M");
 		addColumn(yesColIdx, "Y");
 	}
 	if (showData)
-		addColumn(dataColIdx, "Value");
+		addColumn(dataColIdx, _("Value"));
 
 	updateListAll();
 }
@@ -803,7 +803,7 @@ void ConfigList::contextMenuEvent(QConte
 			QAction *action;
 
 			headerPopup = new QPopupMenu(this);
-			action = new QAction(NULL, "Show Name", 0, this);
+			action = new QAction(NULL, _("Show Name"), 0, this);
 			  action->setToggleAction(TRUE);
 			  connect(action, SIGNAL(toggled(bool)),
 				  parent(), SLOT(setShowName(bool)));
@@ -811,7 +811,7 @@ void ConfigList::contextMenuEvent(QConte
 				  action, SLOT(setOn(bool)));
 			  action->setOn(showName);
 			  action->addTo(headerPopup);
-			action = new QAction(NULL, "Show Range", 0, this);
+			action = new QAction(NULL, _("Show Range"), 0, this);
 			  action->setToggleAction(TRUE);
 			  connect(action, SIGNAL(toggled(bool)),
 				  parent(), SLOT(setShowRange(bool)));
@@ -819,7 +819,7 @@ void ConfigList::contextMenuEvent(QConte
 				  action, SLOT(setOn(bool)));
 			  action->setOn(showRange);
 			  action->addTo(headerPopup);
-			action = new QAction(NULL, "Show Data", 0, this);
+			action = new QAction(NULL, _("Show Data"), 0, this);
 			  action->setToggleAction(TRUE);
 			  connect(action, SIGNAL(toggled(bool)),
 				  parent(), SLOT(setShowData(bool)));
@@ -1041,7 +1041,12 @@ void ConfigInfoView::menuInfo(void)
 		if (showDebug())
 			debug = debug_info(sym);
 
-		help = print_filter(_(menu_get_help(menu)));
+		help = menu_get_help(menu);
+		/* Gettextize if the help text not empty */
+		if (help.isEmpty())
+			help = print_filter(menu_get_help(menu));
+		else
+			help = print_filter(_(menu_get_help(menu)));
 	} else if (menu->prompt) {
 		head += "<big><b>";
 		head += print_filter(_(menu->prompt->text));
@@ -1167,7 +1172,7 @@ void ConfigInfoView::expr_print_help(voi
 QPopupMenu* ConfigInfoView::createPopupMenu(const QPoint& pos)
 {
 	QPopupMenu* popup = Parent::createPopupMenu(pos);
-	QAction* action = new QAction(NULL,"Show Debug Info", 0, popup);
+	QAction* action = new QAction(NULL, _("Show Debug Info"), 0, popup);
 	  action->setToggleAction(TRUE);
 	  connect(action, SIGNAL(toggled(bool)), SLOT(setShowDebug(bool)));
 	  connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setOn(bool)));
@@ -1189,11 +1194,11 @@ ConfigSearchWindow::ConfigSearchWindow(C
 
 	QVBoxLayout* layout1 = new QVBoxLayout(this, 11, 6);
 	QHBoxLayout* layout2 = new QHBoxLayout(0, 0, 6);
-	layout2->addWidget(new QLabel("Find:", this));
+	layout2->addWidget(new QLabel(_("Find:"), this));
 	editField = new QLineEdit(this);
 	connect(editField, SIGNAL(returnPressed()), SLOT(search()));
 	layout2->addWidget(editField);
-	searchButton = new QPushButton("Search", this);
+	searchButton = new QPushButton(_("Search"), this);
 	searchButton->setAutoDefault(FALSE);
 	connect(searchButton, SIGNAL(clicked()), SLOT(search()));
 	layout2->addWidget(searchButton);
@@ -1313,58 +1318,58 @@ ConfigMainWindow::ConfigMainWindow(void)
 	menu = menuBar();
 	toolBar = new QToolBar("Tools", this);
 
-	backAction = new QAction("Back", QPixmap(xpm_back), "Back", 0, this);
+	backAction = new QAction("Back", QPixmap(xpm_back), _("Back"), 0, this);
 	  connect(backAction, SIGNAL(activated()), SLOT(goBack()));
 	  backAction->setEnabled(FALSE);
-	QAction *quitAction = new QAction("Quit", "&Quit", CTRL+Key_Q, this);
+	QAction *quitAction = new QAction("Quit", _("&Quit"), CTRL+Key_Q, this);
 	  connect(quitAction, SIGNAL(activated()), SLOT(close()));
-	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), "&Load", CTRL+Key_L, this);
+	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), _("&Load"), CTRL+Key_L, this);
 	  connect(loadAction, SIGNAL(activated()), SLOT(loadConfig()));
-	saveAction = new QAction("Save", QPixmap(xpm_save), "&Save", CTRL+Key_S, this);
+	saveAction = new QAction("Save", QPixmap(xpm_save), _("&Save"), CTRL+Key_S, this);
 	  connect(saveAction, SIGNAL(activated()), SLOT(saveConfig()));
 	conf_set_changed_callback(conf_changed);
 	// Set saveAction's initial state
 	conf_changed();
-	QAction *saveAsAction = new QAction("Save As...", "Save &As...", 0, this);
+	QAction *saveAsAction = new QAction("Save As...", _("Save &As..."), 0, this);
 	  connect(saveAsAction, SIGNAL(activated()), SLOT(saveConfigAs()));
-	QAction *searchAction = new QAction("Find", "&Find", CTRL+Key_F, this);
+	QAction *searchAction = new QAction("Find", _("&Find"), CTRL+Key_F, this);
 	  connect(searchAction, SIGNAL(activated()), SLOT(searchConfig()));
-	QAction *singleViewAction = new QAction("Single View", QPixmap(xpm_single_view), "Split View", 0, this);
+	QAction *singleViewAction = new QAction("Single View", QPixmap(xpm_single_view), _("Single View"), 0, this);
 	  connect(singleViewAction, SIGNAL(activated()), SLOT(showSingleView()));
-	QAction *splitViewAction = new QAction("Split View", QPixmap(xpm_split_view), "Split View", 0, this);
+	QAction *splitViewAction = new QAction("Split View", QPixmap(xpm_split_view), _("Split View"), 0, this);
 	  connect(splitViewAction, SIGNAL(activated()), SLOT(showSplitView()));
-	QAction *fullViewAction = new QAction("Full View", QPixmap(xpm_tree_view), "Full View", 0, this);
+	QAction *fullViewAction = new QAction("Full View", QPixmap(xpm_tree_view), _("Full View"), 0, this);
 	  connect(fullViewAction, SIGNAL(activated()), SLOT(showFullView()));
 
-	QAction *showNameAction = new QAction(NULL, "Show Name", 0, this);
+	QAction *showNameAction = new QAction(NULL, _("Show Name"), 0, this);
 	  showNameAction->setToggleAction(TRUE);
 	  connect(showNameAction, SIGNAL(toggled(bool)), configView, SLOT(setShowName(bool)));
 	  connect(configView, SIGNAL(showNameChanged(bool)), showNameAction, SLOT(setOn(bool)));
 	  showNameAction->setOn(configView->showName());
-	QAction *showRangeAction = new QAction(NULL, "Show Range", 0, this);
+	QAction *showRangeAction = new QAction(NULL, _("Show Range"), 0, this);
 	  showRangeAction->setToggleAction(TRUE);
 	  connect(showRangeAction, SIGNAL(toggled(bool)), configView, SLOT(setShowRange(bool)));
 	  connect(configView, SIGNAL(showRangeChanged(bool)), showRangeAction, SLOT(setOn(bool)));
 	  showRangeAction->setOn(configList->showRange);
-	QAction *showDataAction = new QAction(NULL, "Show Data", 0, this);
+	QAction *showDataAction = new QAction(NULL, _("Show Data"), 0, this);
 	  showDataAction->setToggleAction(TRUE);
 	  connect(showDataAction, SIGNAL(toggled(bool)), configView, SLOT(setShowData(bool)));
 	  connect(configView, SIGNAL(showDataChanged(bool)), showDataAction, SLOT(setOn(bool)));
 	  showDataAction->setOn(configList->showData);
-	QAction *showAllAction = new QAction(NULL, "Show All Options", 0, this);
+	QAction *showAllAction = new QAction(NULL, _("Show All Options"), 0, this);
 	  showAllAction->setToggleAction(TRUE);
 	  connect(showAllAction, SIGNAL(toggled(bool)), configView, SLOT(setShowAll(bool)));
 	  connect(showAllAction, SIGNAL(toggled(bool)), menuView, SLOT(setShowAll(bool)));
 	  showAllAction->setOn(configList->showAll);
-	QAction *showDebugAction = new QAction(NULL, "Show Debug Info", 0, this);
+	QAction *showDebugAction = new QAction(NULL, _("Show Debug Info"), 0, this);
 	  showDebugAction->setToggleAction(TRUE);
 	  connect(showDebugAction, SIGNAL(toggled(bool)), helpText, SLOT(setShowDebug(bool)));
 	  connect(helpText, SIGNAL(showDebugChanged(bool)), showDebugAction, SLOT(setOn(bool)));
 	  showDebugAction->setOn(helpText->showDebug());
 
-	QAction *showIntroAction = new QAction(NULL, "Introduction", 0, this);
+	QAction *showIntroAction = new QAction(NULL, _("Introduction"), 0, this);
 	  connect(showIntroAction, SIGNAL(activated()), SLOT(showIntro()));
-	QAction *showAboutAction = new QAction(NULL, "About", 0, this);
+	QAction *showAboutAction = new QAction(NULL, _("About"), 0, this);
 	  connect(showAboutAction, SIGNAL(activated()), SLOT(showAbout()));
 
 	// init tool bar
@@ -1379,7 +1384,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 
 	// create config menu
 	QPopupMenu* config = new QPopupMenu(this);
-	menu->insertItem("&File", config);
+	menu->insertItem(_("&File"), config);
 	loadAction->addTo(config);
 	saveAction->addTo(config);
 	saveAsAction->addTo(config);
@@ -1388,12 +1393,12 @@ ConfigMainWindow::ConfigMainWindow(void)
 
 	// create edit menu
 	QPopupMenu* editMenu = new QPopupMenu(this);
-	menu->insertItem("&Edit", editMenu);
+	menu->insertItem(_("&Edit"), editMenu);
 	searchAction->addTo(editMenu);
 
 	// create options menu
 	QPopupMenu* optionMenu = new QPopupMenu(this);
-	menu->insertItem("&Option", optionMenu);
+	menu->insertItem(_("&Option"), optionMenu);
 	showNameAction->addTo(optionMenu);
 	showRangeAction->addTo(optionMenu);
 	showDataAction->addTo(optionMenu);
@@ -1404,7 +1409,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 	// create help menu
 	QPopupMenu* helpMenu = new QPopupMenu(this);
 	menu->insertSeparator();
-	menu->insertItem("&Help", helpMenu);
+	menu->insertItem(_("&Help"), helpMenu);
 	showIntroAction->addTo(helpMenu);
 	showAboutAction->addTo(helpMenu);
 
@@ -1452,14 +1457,14 @@ void ConfigMainWindow::loadConfig(void)
 	if (s.isNull())
 		return;
 	if (conf_read(QFile::encodeName(s)))
-		QMessageBox::information(this, "qconf", "Unable to load configuration!");
+		QMessageBox::information(this, "qconf", _("Unable to load configuration!"));
 	ConfigView::updateListAll();
 }
 
 void ConfigMainWindow::saveConfig(void)
 {
 	if (conf_write(NULL))
-		QMessageBox::information(this, "qconf", "Unable to save configuration!");
+		QMessageBox::information(this, "qconf", _("Unable to save configuration!"));
 }
 
 void ConfigMainWindow::saveConfigAs(void)
@@ -1468,7 +1473,7 @@ void ConfigMainWindow::saveConfigAs(void
 	if (s.isNull())
 		return;
 	if (conf_write(QFile::encodeName(s)))
-		QMessageBox::information(this, "qconf", "Unable to save configuration!");
+		QMessageBox::information(this, "qconf", _("Unable to save configuration!"));
 }
 
 void ConfigMainWindow::searchConfig(void)
@@ -1612,11 +1617,11 @@ void ConfigMainWindow::closeEvent(QClose
 		e->accept();
 		return;
 	}
-	QMessageBox mb("qconf", "Save configuration?", QMessageBox::Warning,
+	QMessageBox mb("qconf", _("Save configuration?"), QMessageBox::Warning,
 			QMessageBox::Yes | QMessageBox::Default, QMessageBox::No, QMessageBox::Cancel | QMessageBox::Escape);
-	mb.setButtonText(QMessageBox::Yes, "&Save Changes");
-	mb.setButtonText(QMessageBox::No, "&Discard Changes");
-	mb.setButtonText(QMessageBox::Cancel, "Cancel Exit");
+	mb.setButtonText(QMessageBox::Yes, _("&Save Changes"));
+	mb.setButtonText(QMessageBox::No, _("&Discard Changes"));
+	mb.setButtonText(QMessageBox::Cancel, _("Cancel Exit"));
 	switch (mb.exec()) {
 	case QMessageBox::Yes:
 		conf_write(NULL);
@@ -1631,7 +1636,7 @@ void ConfigMainWindow::closeEvent(QClose
 
 void ConfigMainWindow::showIntro(void)
 {
-	static char str[] = "Welcome to the qconf graphical kernel configuration tool for Linux.\n\n"
+	static const QString str = _("Welcome to the qconf graphical kernel configuration tool for Linux.\n\n"
 		"For each option, a blank box indicates the feature is disabled, a check\n"
 		"indicates it is enabled, and a dot indicates that it is to be compiled\n"
 		"as a module.  Clicking on the box will cycle through the three states.\n\n"
@@ -1641,15 +1646,15 @@ void ConfigMainWindow::showIntro(void)
 		"options must be enabled to support the option you are interested in, you can\n"
 		"still view the help of a grayed-out option.\n\n"
 		"Toggling Show Debug Info under the Options menu will show the dependencies,\n"
-		"which you can then match by examining other options.\n\n";
+		"which you can then match by examining other options.\n\n");
 
 	QMessageBox::information(this, "qconf", str);
 }
 
 void ConfigMainWindow::showAbout(void)
 {
-	static char str[] = "qconf is Copyright (C) 2002 Roman Zippel <zippel@linux-m68k.org>.\n\n"
-		"Bug reports and feature request can also be entered at http://bugzilla.kernel.org/\n";
+	static const QString str = _("qconf is Copyright (C) 2002 Roman Zippel <zippel@linux-m68k.org>.\n\n"
+		"Bug reports and feature request can also be entered at http://bugzilla.kernel.org/\n");
 
 	QMessageBox::information(this, "qconf", str);
 }
@@ -1707,7 +1712,7 @@ static const char *progname;
 
 static void usage(void)
 {
-	printf("%s <config>\n", progname);
+	printf(_("%s <config>\n"), progname);
 	exit(0);
 }
 
_

