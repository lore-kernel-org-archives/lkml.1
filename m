Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0CEToh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:44:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58176 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0CETof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:44:35 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, geert@linux-m68k.org, elendil@planet.nl,
       cloos@jhcloos.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] kconfig: make setlocalversion -dirty check optional
Date: Fri,  5 Mar 2010 11:44:31 -0800
Message-Id: <1267818271-23154-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267818271-23154-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20100305194305.GA23009@linux.vnet.ibm.com>
 <1267818271-23154-1-git-send-email-paulmck@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The git commands that check for uncommitted changes can be quite
expensive, so this patch introduces an environment variable named
KBUILD_CONFIG_NO_CHECK_DIRTY to control these checks for git.
If KBUILD_CONFIG_NO_CHECK_DIRTY is unset or is set to an empty
string, the dirty checks are performed (the default).  Otherwise,
KBUILD_CONFIG_NO_CHECK_DIRTY is set to some non-empty string, and the
dirty checks are omitted.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 scripts/setlocalversion |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 46989b8..3d4ff84 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -39,13 +39,16 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
 
-	# Update index only on r/w media
-	[ -w . ] && git update-index --refresh --unmerged > /dev/null
-
-	# Check for uncommitted changes
-	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
-	    | read dummy; then
-		printf '%s' -dirty
+	if [ -z "$KBUILD_CONFIG_NO_CHECK_DIRTY" ]; then
+		# Update index only on r/w media
+		[ -w . ] && git update-index --refresh --unmerged > /dev/null
+
+		# Check for uncommitted changes
+		if git diff-index --name-only HEAD \
+		    | grep -v "^scripts/package" \
+		    | read dummy; then
+			printf '%s' -dirty
+		fi
 	fi
 
 	# All done with git
-- 
1.6.6

