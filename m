Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbZKGGqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbZKGGqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZKGGp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:45:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:45400 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751112AbZKGGpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:45:47 -0500
X-Authenticated: #154622
X-Provags-ID: V01U2FsdGVkX19J2Hw4Sp9JrMOOZW1d3rFTDT4oFZPHhCWny7dUOT
	MbROlsznmkQSgV
From: Bernhard Kaindl <bernhard.kaindl@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Kaindl <bernhard.kaindl@gmx.net>, linux-kbuild@vger.kernel.org
Subject: [PATCH 3/4] xconfig: allow editing of remarks for config symbols
Date: Sat,  7 Nov 2009 07:45:39 +0100
Message-Id: <57715d006f612817fa5bc38146560ecd84605a05.1256767265.git.aragorn@Anduril.ringwar.org>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <617c40ae9e206b4f246998fe075644c752bc0bc3.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
 <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
 <617c40ae9e206b4f246998fe075644c752bc0bc3.1256767265.git.aragorn@Anduril.ringwar.org>
In-Reply-To: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend xconfig to allow editing of remarks for config symbols:

Add a new key to xconfig (currently '<') which, when pressed
while a menu entry with a config symbol is selected, shows a
QLineEdit (identical to the one used for string symbol editing)
which is filled with sym->remark.

After the current config item looses focus or the user presses
Escape/Return/Enter to close the QLineEdit, the QLineEdit saves
the edited string to sym->remark and hides.

The new descendent of QLineEdit is called ConfigRemarkEdit and
is mostly a copy of its silbling ConfigLineEdit, which is used
for changing the values of int, hex and string values.

Signed-off-by: Bernhard Kaindl <bernhard.kaindl@gmx.net>
---
 scripts/kconfig/qconf.cc |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/qconf.h  |   19 ++++++++++++++++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 00c5150..58c74a0 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -278,6 +278,54 @@ ConfigItem::~ConfigItem(void)
 	}
 }
 
+ConfigRemarkEdit::ConfigRemarkEdit(ConfigView* parent) : Parent(parent)
+{
+	connect(this, SIGNAL(lostFocus()), SLOT(hide()));
+	Parent::hide();
+}
+
+void ConfigRemarkEdit::show(ConfigItem* i)
+{
+	item = i;
+	if (item->menu->sym->remark)
+		setText(QString::fromLocal8Bit(item->menu->sym->remark));
+	else
+		setText(QString::null);
+	Parent::show();
+	setFocus();
+}
+
+void ConfigRemarkEdit::saveremark()
+{
+	if (item && item->menu && item->menu->sym) {
+		if (item->menu->sym->remark)
+			free(item->menu->sym->remark);
+		item->menu->sym->remark = strdup(text().latin1());
+		sym_set_changed(item->menu->sym);
+		sym_add_change_count(1);
+		sym_clear_all_valid();
+	}
+}
+
+void ConfigRemarkEdit::hide() {
+	saveremark();
+	Parent::hide();
+}
+
+void ConfigRemarkEdit::keyPressEvent(QKeyEvent* e)
+{
+	switch (e->key()) {
+	case Qt::Key_Escape:
+	case Qt::Key_Return:
+	case Qt::Key_Enter:
+		e->accept();
+		parent()->list->setFocus();
+		hide();
+		return;
+	}
+	Parent::keyPressEvent(e);
+}
+
 ConfigLineEdit::ConfigLineEdit(ConfigView* parent)
 	: Parent(parent)
 {
@@ -668,6 +716,10 @@ void ConfigList::keyPressEvent(QKeyEvent* ev)
 			emit menuSelected(menu);
 			break;
 		}
+	case Qt::Key_Less:
+		if (item && item->menu && item->menu->sym && !sym_is_choice(item->menu->sym))
+			parent()->remarkEdit->show(item);
+		break;
 	case Qt::Key_Space:
 		changeValue(item);
 		break;
@@ -843,6 +895,7 @@ ConfigView::ConfigView(QWidget* parent, const char *name)
 	list = new ConfigList(this, name);
 	lineEdit = new ConfigLineEdit(this);
 	lineEdit->hide();
+	remarkEdit = new ConfigRemarkEdit(this);
 
 	this->nextView = viewList;
 	viewList = this;
diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
index b3b5657..f8ee581 100644
--- a/scripts/kconfig/qconf.h
+++ b/scripts/kconfig/qconf.h
@@ -29,6 +29,7 @@ class ConfigView;
 class ConfigList;
 class ConfigItem;
 class ConfigLineEdit;
+class ConfigRemarkEdit;
 class ConfigMainWindow;
 
 
@@ -197,6 +198,23 @@ public:
 	bool goParent;
 };
 
+class ConfigRemarkEdit : public QLineEdit {
+	Q_OBJECT
+	typedef class QLineEdit Parent;
+public:
+	ConfigRemarkEdit(ConfigView* parent);
+	ConfigView* parent(void) const
+	{
+		return (ConfigView*)Parent::parent();
+	}
+	void keyPressEvent(QKeyEvent *e);
+	void show(ConfigItem *i);
+	void hide();
+private:
+	ConfigItem *item;
+	void saveremark();
+};
+
 class ConfigLineEdit : public QLineEdit {
 	Q_OBJECT
 	typedef class QLineEdit Parent;
@@ -239,6 +257,7 @@ signals:
 public:
 	ConfigList* list;
 	ConfigLineEdit* lineEdit;
+	ConfigRemarkEdit* remarkEdit;
 
 	static ConfigView* viewList;
 	ConfigView* nextView;
-- 
1.6.0.4

