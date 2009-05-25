Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZEYMz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZEYMz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZEYMzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:55:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:36961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZEYMzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:55:39 -0400
Date: Mon, 25 May 2009 14:55:40 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kbuild: handle non-existing options in scripts/config
Message-ID: <20090525125540.GB12943@sepie.suse.cz>
References: <cover.1243255664.git.mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1243255664.git.mmarek@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an option does not exist in .config, set it at the end of the file.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/config |   51 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/scripts/config b/scripts/config
index db6084b..144e4b0 100755
--- a/scripts/config
+++ b/scripts/config
@@ -26,8 +26,6 @@ options:
 
 config doesn't check the validity of the .config file. This is done at next
  make time.
-The options need to be already in the file before they can be changed,
-but sometimes you can cheat with the --*-after options.
 EOL
 	exit 1
 }
@@ -45,8 +43,33 @@ checkarg() {
 	ARG="`echo $ARG | tr a-z A-Z`"
 }
 
-replace() {
-	sed -i -e "$@" $FN
+# set_var name value [before-var]
+set_var() {
+	awk -vvar="$1" -vnew="$2" -vbefore="$3" '
+	function is_var(l, v)
+	{
+		return (l == "# " v " is not set" || l ~ "^" v "=");
+	}
+	{
+		if (is_var($0, var)) {
+			if (new)
+				print new;
+			new = "";
+		} else if (before && is_var($0, before)) {
+			print;
+			if (new)
+				print new;
+			new = "";
+		} else {
+			print;
+		}
+	}
+	END {
+		if (new)
+			print new;
+	}
+	' "$FN" >"$FN.tmp"
+	mv -f "$FN.tmp" "$FN"
 }
 
 if [ "$1" = "--file" ]; then
@@ -70,20 +93,19 @@ while [ "$1" != "" ] ; do
 	case "$CMD" in
 	--enable|-e)
 		checkarg "$1"
-		replace "s/# CONFIG_$ARG is not set/CONFIG_$ARG=y/"
+		set_var "CONFIG_$ARG" "CONFIG_$ARG=y"
 		shift
 		;;
 
 	--disable|-d)
 		checkarg "$1"
-		replace "s/CONFIG_$ARG=[my]/# CONFIG_$ARG is not set/"
+		set_var "CONFIG_$ARG" "# CONFIG_$ARG is not set"
 		shift
 		;;
 
 	--module|-m)
 		checkarg "$1"
-		replace "s/CONFIG_$ARG=y/CONFIG_$ARG=m/" \
-			-e "s/# CONFIG_$ARG is not set/CONFIG_$ARG=m/"
+		set_var "CONFIG_$ARG" "CONFIG_$ARG=m"
 		shift
 		;;
 
@@ -109,9 +131,7 @@ while [ "$1" != "" ] ; do
 		A=$ARG
 		checkarg "$2"
 		B=$ARG
-		replace "/CONFIG_$A=[my]/aCONFIG_$B=y" \
-			-e "/# CONFIG_$ARG is not set/a/CONFIG_$ARG=y" \
-			-e "s/# CONFIG_$ARG is not set/CONFIG_$ARG=y/"
+		set_var "CONFIG_$B" "CONFIG_$B=y" "CONFIG_$A"
 		shift
 		shift
 		;;
@@ -121,9 +141,7 @@ while [ "$1" != "" ] ; do
 		A=$ARG
 		checkarg "$2"
 		B=$ARG
-		replace "/CONFIG_$A=[my]/a# CONFIG_$B is not set" \
-		-e "/# CONFIG_$ARG is not set/a/# CONFIG_$ARG is not set" \
-		-e "s/CONFIG_$ARG=[my]/# CONFIG_$ARG is not set/"
+		set_var "CONFIG_$B" "# CONFIG_$B is not set" "CONFIG_$A"
 		shift
 		shift
 		;;
@@ -133,10 +151,7 @@ while [ "$1" != "" ] ; do
 		A=$ARG
 		checkarg "$2"
 		B=$ARG
-		replace "/CONFIG_$A=[my]/aCONFIG_$B=m" \
-			-e "/# CONFIG_$ARG is not set/a/CONFIG_$ARG=m" \
-			-e "s/CONFIG_$ARG=y/CONFIG_$ARG=m/" \
-			-e "s/# CONFIG_$ARG is not set/CONFIG_$ARG=m/"
+		set_var "CONFIG_$B" "CONFIG_$B=m" "CONFIG_$A"
 		shift
 		shift
 		;;
-- 
1.6.3

