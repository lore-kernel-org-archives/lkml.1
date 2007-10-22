Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXJVTMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXJVTMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbXJVTMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:12:21 -0400
Received: from mail.queued.net ([207.210.101.209]:4101 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbXJVTMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:12:20 -0400
Date: Mon, 22 Oct 2007 15:12:02 -0400
From: Andres Salomon <dilinger@queued.net>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, kbuild-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] kconfig: use getopt() in conf.c for handling command line
 arguments
Message-ID: <20071022151202.76cbf16b@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, rename ac/av to argc/argv; those are pretty conventional names.

Second, switch from doing our own parsing of command line arguments to
using getopt(3) to do it.  Aside from simplifying things, this allows
us to specify multiple arguments; the old code could only accept two
arguments (input_mode and kconfig name).

Note some subtle changes:
 - The argument '-?' is no longer supported.
 - '-h' is not treated as an error, so output goes to stdout, and we
   exit with '0'.
 - There is no compatibility checking amongst arguments; the last option
   will simply override earlier options.  For example, 'conf -n -y foo'
   is perfectly valid now (input_mode will be set_yes).  Previously, that
   would have been an error ("can't find file -y").

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 scripts/kconfig/conf.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 8be6a42..ae541b5 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -489,14 +489,14 @@ static void check_conf(struct menu *menu)
 		check_conf(child);
 }
 
-int main(int ac, char **av)
+int main(int argc, char **argv)
 {
-	int i = 1;
+	int opt;
 	const char *name;
 	struct stat tmpstat;
 
-	if (ac > i && av[i][0] == '-') {
-		switch (av[i++][1]) {
+	while ((opt = getopt(argc, argv, "osdD:nmyrh")) != -1) {
+		switch (opt) {
 		case 'o':
 			input_mode = ask_new;
 			break;
@@ -509,12 +509,7 @@ int main(int ac, char **av)
 			break;
 		case 'D':
 			input_mode = set_default;
-			defconfig_file = av[i++];
-			if (!defconfig_file) {
-				printf(_("%s: No default config file specified\n"),
-					av[0]);
-				exit(1);
-			}
+			defconfig_file = optarg;
 			break;
 		case 'n':
 			input_mode = set_no;
@@ -530,16 +525,19 @@ int main(int ac, char **av)
 			srandom(time(NULL));
 			break;
 		case 'h':
-		case '?':
-			fprintf(stderr, "See README for usage info\n");
+			printf("See README for usage info\n");
 			exit(0);
+			break;
+		default:
+			fprintf(stderr, "See README for usage info\n");
+			exit(1);
 		}
 	}
-  	name = av[i];
-	if (!name) {
-		printf(_("%s: Kconfig file missing\n"), av[0]);
+	if (argc == optind) {
+		printf(_("%s: Kconfig file missing\n"), argv[0]);
 		exit(1);
 	}
+	name = argv[optind];
 	conf_parse(name);
 	//zconfdump(stdout);
 	switch (input_mode) {
