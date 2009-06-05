Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZFEXqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZFEXqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbZFEXlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:47 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36428 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbZFEXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:13 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 31/39] kconfig: do not hardcode ".config" filename
Date: Sat,  6 Jun 2009 01:42:49 +0200
Message-Id: <1244245377-17441-31-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Heidelberg <markus.heidelberg@web.de>

Rather than hardcoding ".config" use conf_get_configname(), which also
respects the environment variable KCONFIG_CONFIG.

This fixes "make silentoldconfig" when KCONFIG_CONFIG is used and also
suggests the given filename for "Load" and "Save as" in qconf.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/conf.c   |    7 ++++---
 scripts/kconfig/qconf.cc |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index d190092..3baaaec 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -498,14 +498,15 @@ int main(int ac, char **av)
 	conf_parse(name);
 	//zconfdump(stdout);
 	if (sync_kconfig) {
-		if (stat(".config", &tmpstat)) {
+		name = conf_get_configname();
+		if (stat(name, &tmpstat)) {
 			fprintf(stderr, _("***\n"
 				"*** You have not yet configured your kernel!\n"
-				"*** (missing kernel .config file)\n"
+				"*** (missing kernel config file \"%s\")\n"
 				"***\n"
 				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
 				"*** \"make menuconfig\" or \"make xconfig\").\n"
-				"***\n"));
+				"***\n"), name);
 			exit(1);
 		}
 	}
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 19811fc..ce7d508 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1448,7 +1448,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 
 void ConfigMainWindow::loadConfig(void)
 {
-	QString s = QFileDialog::getOpenFileName(".config", NULL, this);
+	QString s = QFileDialog::getOpenFileName(conf_get_configname(), NULL, this);
 	if (s.isNull())
 		return;
 	if (conf_read(QFile::encodeName(s)))
@@ -1464,7 +1464,7 @@ void ConfigMainWindow::saveConfig(void)
 
 void ConfigMainWindow::saveConfigAs(void)
 {
-	QString s = QFileDialog::getSaveFileName(".config", NULL, this);
+	QString s = QFileDialog::getSaveFileName(conf_get_configname(), NULL, this);
 	if (s.isNull())
 		return;
 	if (conf_write(QFile::encodeName(s)))
-- 
1.6.3.rc3.40.g75b44

