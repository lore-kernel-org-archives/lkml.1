Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXLDN7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXLDN7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXLDNz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:55:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:14963 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbXLDNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BzLeNQlPcnkmkeI/RVcLbHSFEtZNa7nU6GHG2VAxKGaEkMIzqMcB+GL8WzOkndYfvEaxVmcYahcpU6e5jq6K5tA2vrXE8z2Wgb0cj1CMZJDl8OEtmvrNWWpBz3RP8FblqdVb1K8mgEcYlkYjWwBQxzqvuPMfIEgTHlYYDBNKLEM=
Message-ID: <47555C64.8070607@gmail.com>
Date: Tue, 04 Dec 2007 22:55:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: [PATCH] depmod: sort output according to modules.order
References: <47555AF1.8090304@gmail.com>
In-Reply-To: <47555AF1.8090304@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild now generates and installs modules.order along with modules.
This patch updates depmod such that it sorts module list according to
the file before generating output files.  Modules which aren't on
modules.order are put after modules which are ordered by
modules.order.

This makes modprobe to prioritize modules according to kernel
Makefile's just as built-in modules are link-ordered by them.

This patch is against module-init-tools 3.3-pre1.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Bill Nottingham <notting@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 depmod.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/depmod.c b/depmod.c
index ea7ad05..e5b9bc3 100644
--- a/depmod.c
+++ b/depmod.c
@@ -585,6 +585,52 @@ static struct module *grab_basedir(const char *dirname)
 	return list;
 }
 
+static void sort_modules(const char *dirname, struct module **listp)
+{
+	struct module *list = *listp, *tlist = NULL, **tpos = &tlist;
+	FILE *modorder;
+	int dir_len = strlen(dirname) + 1;
+	char file_name[dir_len + strlen("modules.order") + 1];
+	char line[dir_len + 10240];
+
+	sprintf(file_name, "%s/%s", dirname, "modules.order");
+
+	modorder = fopen(file_name, "r");
+	if (!modorder) {
+		if (errno == ENOENT)
+			return;
+		fatal("Could not open '%s': %s\n", file_name, strerror(errno));
+	}
+
+	sprintf(line, "%s/", dirname);
+
+	/* move modules listed in modorder file to tlist in order */
+	while (fgets(line + dir_len, sizeof(line) - dir_len, modorder)) {
+		struct module **pos, *mod;
+		int len = strlen(line);
+
+		if (line[len - 1] == '\n')
+			line[len - 1] = '\0';
+
+		for (pos = &list; (mod = *pos); pos = &(*pos)->next) {
+			if (strcmp(line, mod->pathname) == 0) {
+				*pos = mod->next;
+				mod->next = NULL;
+				*tpos = mod;
+				tpos = &mod->next;
+				break;
+			}
+		}
+	}
+
+	/* append the rest */
+	*tpos = list;
+
+	fclose(modorder);
+
+	*listp = tlist;
+}
+
 static void parse_modules(struct module *list)
 {
 	struct module *i;
@@ -857,6 +903,7 @@ int main(int argc, char *argv[])
 	} else {
 		list = grab_basedir(dirname);
 	}
+	sort_modules(dirname, &list);
 	parse_modules(list);
 
 	for (i = 0; i < sizeof(depfiles)/sizeof(depfiles[0]); i++) {
