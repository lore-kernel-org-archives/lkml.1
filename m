Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZACCVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZACCVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 21:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbZACCUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 21:20:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33539 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566AbZACCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 21:20:15 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090103321.351399938@firstfloor.org>
To: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] KBUILD: Add script to manipulate .config files on the command line
Date: Sat,  3 Jan 2009 03:21:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I often change single options in .config files. Instead of using
an editor or one of the frontends it's convenient to do this from
the command line. It's also useful to do from automated build scripts
when building different variants from a base config file.

I extracted most of the CONFIG manipulation code from one of my
build scripts into a new shell script scripts/config

The script is not integrated with the normal Kconfig machinery
and doesn't do any checking against Kconfig files, but just manipulates
that text format. This is always done at make time anyways.

I believe this script would be a useful standard addition for scripts/*

Sample usage:

./scripts/config --disable smp 
Disable SMP in .config file

./scripts/config --file otherdir/.config --module e1000e
Enable E1000E as module in otherdir/.config

./scripts/config --state smp
y 
Check state of config option CONFIG_SMP

After merging into git please make scripts/config executable

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 scripts/config |  150 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

Index: linux-2.6.28-kbuild/scripts/config
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.28-kbuild/scripts/config	2009-01-02 02:56:11.000000000 +0100
@@ -0,0 +1,150 @@
+#!/bin/bash
+# Manipulate options in a .config file from the command line
+
+usage() {
+	cat >&2 <<EOL
+Manipulate options in a .config file from the command line.
+Usage:
+config options command ...
+commands:
+	--enable|-e option   Enable option
+	--disable|-d option  Disable option
+	--module|-m option      Turn option into a module
+	--state|-s option       Print state of option (n,y,m,undef)
+
+	--enable-after|-E beforeopt option
+                             Enable option directly after other option
+	--disable-after|-D beforeopt option
+                             Disable option directly after other option
+	--module-after|-M beforeopt option
+                             Turn option into module directly after other option
+
+	commands can be repeated multiple times
+
+options:
+	--file .config file to change (default .config)
+
+config doesn't check the validity of the .config file. This is done at next
+ make time.
+The options need to be already in the file before they can be changed,
+but sometimes you can cheat with the --*-after options.
+EOL
+	exit 1
+}
+
+checkarg() {
+	ARG="$1"
+	if [ "$ARG" = "" ] ; then
+		usage
+	fi
+	case "$ARG" in
+	CONFIG_*)
+		ARG="${ARG/CONFIG_/}"
+		;;
+	esac
+	ARG="`echo $ARG | tr a-z A-Z`"
+}
+
+replace() {
+	sed -i -e "$@" $FN
+}
+
+if [ "$1" = "--file" ]; then
+	FN="$2"
+	if [ "$FN" = "" ] ; then
+		usage
+	fi
+	shift
+	shift
+else
+	FN=.config
+fi
+
+while [ "$1" != "" ] ; do
+	CMD="$1"
+	shift
+	case "$CMD" in
+	--enable|-e)
+		checkarg "$1"
+		replace "s/# CONFIG_$ARG is not set/CONFIG_$ARG=y/"
+		shift
+		;;
+
+	--disable|-d)
+		checkarg "$1"
+		replace "s/CONFIG_$ARG=[my]/# CONFIG_$ARG is not set/"
+		shift
+		;;
+
+	--module|-m)
+		checkarg "$1"
+		replace "s/CONFIG_$ARG=y/CONFIG_$ARG=m/" \
+			-e "s/# CONFIG_$ARG is not set/CONFIG_$ARG=m/"
+		shift
+		;;
+
+	--state|-s)
+		checkarg "$1"
+		if grep -q "# CONFIG_$ARG is not set" $FN ; then
+			echo n
+		else
+			V="$(grep "^CONFIG_$ARG=" $FN)"
+			if [ $? != 0 ] ; then
+				echo undef
+			else
+				V="${V/CONFIG_$ARG=/}"
+				V="${V/\"/}"
+				echo "$V"
+			fi
+		fi
+		shift
+		;;
+
+	--enable-after|-E)
+		checkarg "$1"
+		A=$ARG
+		checkarg "$2"
+		B=$ARG
+		replace "/CONFIG_$A=[my]/aCONFIG_$B=y" \
+			-e "/# CONFIG_$ARG is not set/a/CONFIG_$ARG=y" \
+			-e "s/# CONFIG_$ARG is not set/CONFIG_$ARG=y/"
+		shift
+		shift
+		;;
+
+	--disable-after|-D)
+		checkarg "$1"
+		A=$ARG
+		checkarg "$2"
+		B=$ARG
+		replace "/CONFIG_$A=[my]/a# CONFIG_$B is not set" \
+		-e "/# CONFIG_$ARG is not set/a/# CONFIG_$ARG is not set" \
+		-e "s/CONFIG_$ARG=[my]/# CONFIG_$ARG is not set/"
+		shift
+		shift
+		;;
+
+	--module-after|-M)
+		checkarg "$1"
+		A=$ARG
+		checkarg "$2"
+		B=$ARG
+		replace "/CONFIG_$A=[my]/aCONFIG_$B=m" \
+			-e "/# CONFIG_$ARG is not set/a/CONFIG_$ARG=m" \
+			-e "s/CONFIG_$ARG=y/CONFIG_$ARG=m/" \
+			-e "s/# CONFIG_$ARG is not set/CONFIG_$ARG=m/"
+		shift
+		shift
+		;;
+
+	# undocumented because it ignores --file (fixme)
+	--refresh)
+		yes "" | make oldconfig
+		;;
+
+	*)
+		usage
+		;;
+	esac
+done
+
