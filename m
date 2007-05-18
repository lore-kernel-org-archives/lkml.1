Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXERHBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXERHBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbXERHA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:00:57 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54692 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567AbXERHA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:00:56 -0400
Date: Fri, 18 May 2007 09:01:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 14/14] kconfig: search harder for curses library in check-lxdialog.sh
Message-ID: <20070518070153.GN12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 329e3a972ce593015b1e9c0b91f18dcd80cfd4fa Mon Sep 17 00:00:00 2001
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 17 May 2007 15:06:31 -0400
Subject: [PATCH 14/14] kconfig: search harder for curses library in check-lxdialog.sh

The check-lxdialog.sh script searches for "libFOO.so" which fails on OS X, due
to their special naming of libraries like "libfoo.dylib".  This patch turns
the curses lib search into extensible loops and adds dylib as a valid
extension.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 120d624..cdca738 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,21 +4,15 @@
 # What library to link
 ldflags()
 {
-	$cc -print-file-name=libncursesw.so | grep -q /
-	if [ $? -eq 0 ]; then
-		echo '-lncursesw'
-		exit
-	fi
-	$cc -print-file-name=libncurses.so | grep -q /
-	if [ $? -eq 0 ]; then
-		echo '-lncurses'
-		exit
-	fi
-	$cc -print-file-name=libcurses.so | grep -q /
-	if [ $? -eq 0 ]; then
-		echo '-lcurses'
-		exit
-	fi
+	for ext in so a dylib ; do
+		for lib in ncursesw ncurses curses ; do
+			$cc -print-file-name=lib${lib}.${ext} | grep -q /
+			if [ $? -eq 0 ]; then
+				echo "-l${lib}"
+				exit
+			fi
+		done
+	done
 	exit 1
 }
 
-- 
1.5.1.rc3.20.gaa453

