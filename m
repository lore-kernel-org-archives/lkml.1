Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbYLTObY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbYLTObY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYLTOaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:10 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56387 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYLTOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 01/26] kbuild: fix -I option expansion with O=... builds
Date: Sat, 20 Dec 2008 15:31:12 +0100
Message-Id: <1229783497-19550-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding extra -I options with O=... we could
end up in a situation where there were no parameters to -I.
So we had a commandline that looked like this:

    ... -I -Wall ...

This had the undesired side effect that gcc assumed "-Wall"
was a path to look for include files so this options was
effectively ignored.

This happens only when we build the generated module.mod.c files
as part of the final modules builds and is as such harmless
with current kbuild.
This bug was exposed when we rearranged the options to gcc.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Kbuild.include |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 982dcae..936940b 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -144,7 +144,9 @@ ld-option = $(call try-run,\
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
 # Prefix -I with $(srctree) if it is not an absolute path.
-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+# skip if -I has no parameter
+addtree = $(if $(patsubst -I%,%,$(1)), \
+$(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1))
 
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
-- 
1.6.0.2.GIT

