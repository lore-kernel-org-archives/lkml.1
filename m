Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0BGXZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:25:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:40753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756457Ab0BGXZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:25:42 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+gbvIjYwugznrJTQ0jYqV0ANiuq4Y/94zDMBKhWB
	U5WuNXwdfLhgUH
Date: Mon, 8 Feb 2010 00:25:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michal Marek <mmarek@suse.cz>
cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH v2] tags: include headers before source files
In-Reply-To: <4B6C94AC.7000301@suse.cz>
Message-ID: <Pine.LNX.4.64.1002080022290.15951@axis700.grange>
References: <Pine.LNX.4.64.1002031704550.6324@axis700.grange> <4B6C94AC.7000301@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently looking up a structure definition in TAGS / tags takes one to
one of multiple "static struct X" definitions in arch sources, which makes
it for many structs practically impossible to get to the required header.
This patch changes the order of sources being tagged to first scan
architecture includes, then the top-level include/ directory, and only
then the rest. It also takes into account, that many architectures have
more than one include directory, i.e., not only arch/$ARCH/include, but
also arch/$ARCH/mach-X/include etc.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
---

v1 -> v2:

1. check if $include variable is not empty - thanks, Michal, for testing

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 1a0c44d..6f0985d 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -32,13 +32,20 @@ fi
 # find sources in arch/$ARCH
 find_arch_sources()
 {
-	find ${tree}arch/$1 $ignore -name "$2" -print;
+	for i in $archincludedir; do
+		prune+="-wholename $i -prune -o "
+	done
+	find ${tree}arch/$1 $ignore $prune -name "$2" -print;
 }
 
 # find sources in arch/$1/include
 find_arch_include_sources()
 {
-	find ${tree}arch/$1/include $ignore -name "$2" -print;
+	include=$(find ${tree}arch/$1/ -name include -type d);
+	if [ -n "$include" ]; then
+		archincludedir+="$include "
+		find $include $ignore -name "$2" -print;
+	fi
 }
 
 # find sources in include/
@@ -63,14 +70,15 @@ find_sources()
 
 all_sources()
 {
-	for arch in $ALLSOURCE_ARCHS
-	do
-		find_sources $arch '*.[chS]'
-	done
+	find_arch_include_sources ${ARCH} '*.[chS]'
 	if [ ! -z "$archinclude" ]; then
 		find_arch_include_sources $archinclude '*.[chS]'
 	fi
 	find_include_sources '*.[chS]'
+	for arch in $ALLSOURCE_ARCHS
+	do
+		find_sources $arch '*.[chS]'
+	done
 	find_other_sources '*.[chS]'
 }
 
