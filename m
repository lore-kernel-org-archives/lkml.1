Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYDZCdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYDZCdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbYDZCch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 22:32:37 -0400
Received: from mail.queued.net ([207.210.101.209]:2257 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533AbYDZCcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 22:32:31 -0400
Date: Fri, 25 Apr 2008 22:35:30 -0400
From: Andres Salomon <dilinger@queued.net>
To: sam@ravnborg.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: [PATCH 4/4] kconfig: add *_silentdefconfig feature for config
 targets
Message-ID: <20080425223530.10b9d50d@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Being able to run 'silentoldconfig' with an existing .config has been
immensely useful, especially for automated builds.  If the kernel code
changes in an incompatible manner without the associated .config being
updated, the build will fail and call attention to the need for an update.

AFAICT, there is nothing similar when using *_defconfig; one must copy
a .config manually, and then run silentoldconfig.  Simply running the
associated _defconfig will quietly update the config (which may silently
drop config options).  This patch adds a *_silentdefconfig target, with
semantics similar to silentoldconfig.  It will take the defconfig from
arch/$(SRCARCH)/configs/$x_defconfig, check for changes, and if there are
none, write out a .config.  If there have been changes and stdin is
valid, it will prompt for updates.  If there have been changes and
stdin is not valid, it will bail out with an error.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Makefile                 |    4 ++++
 scripts/kconfig/Makefile |    3 +++
 scripts/kconfig/conf.c   |   13 +++++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e77149e..c264f7f 100644
--- a/Makefile
+++ b/Makefile
@@ -1225,6 +1225,10 @@ help:
 		$(foreach b, $(boards), \
 		printf "  %-24s - Build for %s\\n" $(b) $(subst _defconfig,,$(b));) \
 		echo '')
+	@$(if $(boards), \
+		$(foreach b, $(boards), \
+		printf "  %-24s - Quiet Build for %s\\n" $(subst _defconfig,_silentdefconfig,$(b)) $(subst _defconfig,,$(b));) \
+		echo '')
 
 	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
 	@echo  '  make V=2   [targets] 2 => give reason for rebuild of target'
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index ce7d754..19ba562 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -72,6 +72,9 @@ endif
 %_defconfig: $(obj)/conf
 	$(Q)$< -d -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
+%_silentdefconfig: $(obj)/conf
+	$(Q)$< -s -o -D arch/$(SRCARCH)/configs/$(subst _silentdefconfig,_defconfig,$@) $(Kconfig)
+
 # Help text used by make help
 help:
 	@echo  '  config	  - Update current config utilising a line-oriented program'
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 9a27638..264eee9 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -558,7 +558,8 @@ int main(int ac, char **av)
 		}
 		break;
 	case ask_new:
-		if (silent_mode && stat(".config", &tmpstat)) {
+		if (!defconfig_file && silent_mode &&
+				stat(".config", &tmpstat)) {
 			printf(_("***\n"
 				"*** You have not yet configured your kernel!\n"
 				"*** (missing kernel .config file)\n"
@@ -570,7 +571,15 @@ int main(int ac, char **av)
 		}
 		/* fall through */
 	case ask_all:
-		conf_read(NULL);
+		if (defconfig_file) {
+			if (conf_read(defconfig_file)) {
+				printf(_("***\n*** Can't find default "
+					 "configuration \"%s\"!\n***\n"),
+					 defconfig_file);
+				exit(1);
+			}
+		} else
+			conf_read(NULL);
 		break;
 	case set_no:
 	case set_mod:
-- 
1.5.5

