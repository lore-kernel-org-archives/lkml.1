Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYEaUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYEaUhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYEaUhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:37:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45528 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbYEaUhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:37:11 -0400
Date: Sat, 31 May 2008 22:37:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Tvrtko <tvrtko.ursulin@sophos.com>, Andrea Arcangeli <andrea@qumranet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [GIT PULL] fix kbuild regression
Message-ID: <20080531203751.GA12621@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git


	Sam


To get the following fix:

Sam Ravnborg (1):
    kbuild: fix $(src) assignmnet with external modules

    When we introduced support for KBUILD_EXTRA_SYMBOLS
    we started to include the externam module's kbuild
    file when doing the final modpost step.

    As external modules often do:
    ccflags-y := -I$(src)

    We had problems because $(src) was unassinged and
    gcc then used the next parameter for -I resulting in
    strange build failures.

    Fix is to assign $(src) and $(obj) when building
    external modules.

    This fixes: http://bugzilla.kernel.org/show_bug.cgi?id=10798

    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: Tvrtko <tvrtko.ursulin@sophos.com>
    Cc: Andrea Arcangeli <andrea@qumranet.com>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

 scripts/Makefile.modpost |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index a098a04..17092d6 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -43,7 +43,13 @@ _modpost: __modpost
 include include/config/auto.conf
 include scripts/Kbuild.include
 
+# When building external modules load the Kbuild file to retreive EXTRA_SYMBOLS info
 ifneq ($(KBUILD_EXTMOD),)
+
+# set src + obj - they may be used when building the .mod.c file
+obj := $(KBUILD_EXTMOD)
+src := $(obj)
+
 # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
 include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
              $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
