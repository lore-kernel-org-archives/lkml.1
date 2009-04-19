Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbZDSNny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbZDSNny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760683AbZDSNlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:31 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:39007 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870AbZDSNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:22 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 09/10] kconfig: do not hardcode ".config" filename
Date: Sun, 19 Apr 2009 15:41:26 +0200
Message-Id: <1240148487-27584-10-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1+mdXDFwIfkLtAh6JsFW3vCH5Eqe7kbml7GQgn4
	azFotCBibUE2nCzdtIxG/cENjknXoOYR1JIVZACwKZcQfQD7Md
	1A1NUGsbGoNvOd3CgwfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than hardcoding ".config" use conf_get_configname(), which also
respects the environment variable KCONFIG_CONFIG.

This fixes "make silentoldconfig" when KCONFIG_CONFIG is used and also
suggests the given filename for "Load" and "Save as" in qconf.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
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
1.6.3.rc1.24.g467d50

