Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZFDFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZFDFrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZFDFrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:47:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:47409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZFDFrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:47:08 -0400
Date: Thu, 4 Jun 2009 07:47:08 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kbuild: some scripts/config improvements (try 2)
Message-ID: <20090604054708.GA2241@sepie.suse.cz>
References: <20090525144320.GA22686@sepie.suse.cz> <20090603192520.GC3100@uranus.ravnborg.org> <20090603201645.GG1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603201645.GG1065@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 10:16:46PM +0200, Andi Kleen wrote:
> On Wed, Jun 03, 2009 at 09:25:20PM +0200, Sam Ravnborg wrote:
> > On Mon, May 25, 2009 at 04:43:20PM +0200, Michal Marek wrote:
> > > Hi,
> > > 
> > > I simplified the awk script a bit, made it awk ... && mv and removed the
> > > --set option.
> > > 
> > > Michal Marek (3):
> > >   kbuild: handle non-existing options in scripts/config
> > >   kbuild: simplify argument loop in scripts/config
> > >   kbuild: add generic --set-str option to scripts/config
> > 
> > Andi - do I have your ack on this serie?
> 
> Reluctantly -- most bits are ok, but the awk change seems quite overcomplicated
> and I don't like it particularly.

What about this one? The other two patches apply apply at slightly
different offsets.

Subject: [PATCH 1/3] kbuild: handle non-existing options in scripts/config

If an option does not exist in .config, set it at the end of the file.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/config |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/scripts/config b/scripts/config
index db6084b..30825a5 100755
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
@@ -45,8 +43,18 @@ checkarg() {
 	ARG="`echo $ARG | tr a-z A-Z`"
 }
 
-replace() {
-	sed -i -e "$@" $FN
+set_var() {
+	local name=$1 new=$2 before=$3
+
+	name_re="^($name=|# $name is not set)"
+	before_re="^($before=|# $before is not set)"
+	if test -n "$before" && grep -Eq "$before_re" "$FN"; then
+		sed -ri "/$before_re/a $new" "$FN"
+	elif grep -Eq "$name_re" "$FN"; then
+		sed -ri "s:$name_re.*:$new:" "$FN"
+	else
+		echo "$new" >>"$FN"
+	fi
 }
 
 if [ "$1" = "--file" ]; then
@@ -70,20 +78,19 @@ while [ "$1" != "" ] ; do
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
 
@@ -109,9 +116,7 @@ while [ "$1" != "" ] ; do
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
@@ -121,9 +126,7 @@ while [ "$1" != "" ] ; do
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
@@ -133,10 +136,7 @@ while [ "$1" != "" ] ; do
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

