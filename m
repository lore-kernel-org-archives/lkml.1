Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbXLGMI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbXLGMI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXLGMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:08:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:32655 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXLGMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:08:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dE5LU9mXG5NlSc9OZ1Yb/qPnYtnlDLl8CM1IbLNEPdYrspbka2nFenr21dCmvFwD/FN1q1qX5s6kuUmSS62BoZyLOzQro2zt9g/naeeZAfCXmKqb/lpa9W7Pb+x7IQzoT5ZcgYkidMmVtIO7dvbMKbMXwf2DaYx2dAofVbx4L9Y=
Message-ID: <4759379D.8090201@gmail.com>
Date: Fri, 07 Dec 2007 21:07:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: [PATCH] depmod: sort output according to modules.order, take #2
References: <475936CE.70703@gmail.com>
In-Reply-To: <475936CE.70703@gmail.com>
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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bill Nottingham <notting@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
Comment added and path comparion logic slightly modified such that
dirname part of mode->pathname is ignored instead of prepending
dirname to lines read from modules.order.  Behavior-wise it's
identical to the previous version.

Thanks.

 depmod.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/depmod.c b/depmod.c
index ea7ad05..c3ae5a2 100644
--- a/depmod.c
+++ b/depmod.c
@@ -585,6 +585,54 @@ static struct module *grab_basedir(const char *dirname)
 	return list;
 }
 
+static void sort_modules(const char *dirname, struct module **listp)
+{
+	struct module *list = *listp, *tlist = NULL, **tpos = &tlist;
+	FILE *modorder;
+	int dir_len = strlen(dirname) + 1;
+	char file_name[dir_len + strlen("modules.order") + 1];
+	char line[10240];
+
+	sprintf(file_name, "%s/%s", dirname, "modules.order");
+
+	modorder = fopen(file_name, "r");
+	if (!modorder) {
+		/* Older kernels don't generate modules.order.  Just
+		   return if the file doesn't exist. */
+		if (errno == ENOENT)
+			return;
+		fatal("Could not open '%s': %s\n", file_name, strerror(errno));
+	}
+
+	sprintf(line, "%s/", dirname);
+
+	/* move modules listed in modorder file to tlist in order */
+	while (fgets(line, sizeof(line), modorder)) {
+		struct module **pos, *mod;
+		int len = strlen(line);
+
+		if (line[len - 1] == '\n')
+			line[len - 1] = '\0';
+
+		for (pos = &list; (mod = *pos); pos = &(*pos)->next) {
+			if (strcmp(line, mod->pathname + dir_len) == 0) {
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
@@ -857,6 +905,7 @@ int main(int argc, char *argv[])
 	} else {
 		list = grab_basedir(dirname);
 	}
+	sort_modules(dirname, &list);
 	parse_modules(list);
 
 	for (i = 0; i < sizeof(depfiles)/sizeof(depfiles[0]); i++) {
