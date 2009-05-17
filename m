Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZEQXj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZEQXj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZEQXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:58 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43809 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbZEQXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:49 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 09/10] kconfig: do not hardcode ".config" filename
Date: Mon, 18 May 2009 01:36:53 +0200
Message-Id: <1242603414-9267-10-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1/rS2vkP6eu4aBvP69lAhP1dm74BoRscFPM7b4d
	4L7lFpsYP7+RJlJjZ3AgjFdrP29H5l3j8yH9TJg80HW6NZL8ua
	fw4f10DYOLcfd2X3p1cQ==
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
1.6.3.1.20.ga30f

