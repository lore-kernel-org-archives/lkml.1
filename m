Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbXFQIjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbXFQIjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXFQIiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:38:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:51837 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbXFQIiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:38:55 -0400
Date: Sun, 17 Jun 2007 10:38:49 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Sam Ravnborg <sam@mars.ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Strip 'CONFIG_' automatically in kernel configuration search
Message-ID: <20070617083849.GB4496@suse.de>
Mail-Followup-To: Sam Ravnborg <sam@mars.ravnborg.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the ncurses configuration tool ('make menuconfig') in a way
that the user can enter the search string (/) both with or without the leading
'CONFIG_'.

This simplifies using copy & paste from .config files because you can select
the whole word.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 scripts/kconfig/mconf.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -419,11 +419,13 @@ static void search_conf(void)
 {
 	struct symbol **sym_arr;
 	struct gstr res;
+	char *dialog_input;
 	int dres;
 again:
 	dialog_clear();
 	dres = dialog_inputbox(_("Search Configuration Parameter"),
-			      _("Enter CONFIG_ (sub)string to search for (omit CONFIG_)"),
+			      _("Enter CONFIG_ (sub)string to search for "
+				"(with or without \"CONFIG\")"),
 			      10, 75, "");
 	switch (dres) {
 	case 0:
@@ -435,7 +437,12 @@ again:
 		return;
 	}
 
-	sym_arr = sym_re_search(dialog_input_result);
+	/* strip CONFIG_ if necessary */
+	dialog_input = dialog_input_result;
+	if (strncasecmp(dialog_input_result, "CONFIG_", 7) == 0)
+		dialog_input += 7;
+
+	sym_arr = sym_re_search(dialog_input);
 	res = get_relations_str(sym_arr);
 	free(sym_arr);
 	show_textbox(_("Search Results"), str_get(&res), 0, 0);
