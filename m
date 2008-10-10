Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYJJWq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYJJWq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJJWp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:45:57 -0400
Received: from kroah.org ([198.145.64.141]:39628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753127AbYJJWp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:45:56 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Jeff Mahoney <jeffm@suse.de>
Subject: [PATCH 02/23] Staging: add TAINT_CRAP flag to drivers/staging modules
Date: Fri, 10 Oct 2008 15:42:26 -0700
Message-Id: <1223678567-30143-2-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

We need to add a flag for all code that is in the drivers/staging/
directory to prevent all other kernel developers from worrying about
issues here, and to notify users that the drivers might not be as good
as they are normally used to.

Based on code from Andreas Gruenbacher and Jeff Mahoney to provide a
TAINT flag for the support level of a kernel module in the Novell
enterprise kernel release.

This is the code that actually modifies the modules, adding the flag to
any files in the drivers/staging directory.

Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Jeff Mahoney <jeffm@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 scripts/mod/modpost.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8e0de6a..8892161 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1726,6 +1726,14 @@ static void add_header(struct buffer *b, struct module *mod)
 	buf_printf(b, "};\n");
 }
 
+void add_staging_flag(struct buffer *b, const char *name)
+{
+	static const char *staging_dir = "drivers/staging";
+
+	if (strncmp(staging_dir, name, strlen(staging_dir)) == 0)
+		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
+}
+
 /**
  * Record CRCs for unresolved symbols
  **/
@@ -2135,6 +2143,7 @@ int main(int argc, char **argv)
 		buf.pos = 0;
 
 		add_header(&buf, mod);
+		add_staging_flag(&buf, mod->name);
 		err |= add_versions(&buf, mod);
 		add_depends(&buf, mod, modules);
 		add_moddevtable(&buf, mod);
-- 
1.6.0.2

