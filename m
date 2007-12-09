Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbXLITxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbXLITxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLITxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:53:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58695 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXLITxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:53:33 -0500
Date: Sun, 9 Dec 2007 20:55:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: menuconfig: fail with clearer error if curses.h N/A
Message-ID: <20071209195516.GA8835@uranus.ravnborg.org>
References: <200710142323.21139.elendil@planet.nl> <20071209191317.GA8496@uranus.ravnborg.org> <200712092035.33056.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712092035.33056.elendil@planet.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 08:35:32PM +0100, Frans Pop wrote:
> On Sunday 09 December 2007, Sam Ravnborg wrote:
> > This is much better.
> 
> Thanks!
> 
> A few minor corrections maybe (nitpicks really).
Thanks - updated patch below.

	Sam

>From c00c91abddc0903e7b4bc818cfbaf401119ca676 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@saturn.ravnborg.org>
Date: Sun, 9 Dec 2007 20:11:15 +0100
Subject: [PATCH] kconfig: if ncurses-devel is missing then say so

With this patch when ncurses-devel (or whatever it is named)
is missing trying to run menuconfig will result in this:

$ make menuconfig
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
 *** Unable to find the ncurses libraries or the
 *** required header files.
 *** 'make menuconfig' requires the ncurses libraries.
 ***
 *** Install ncurses (ncurses-devel) and try again.
 ***
make[1]: *** [scripts/kconfig/dochecklxdialog] Error 1
make: *** [menuconfig] Error 2

Much better than before where we just listed some build errors.
The other *config targets will work indepenednt on ncurses
being present or not.

Includes improvements suggested by: Frans Pop <elendil@planet.nl>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Frans Pop <elendil@planet.nl>
---
 scripts/kconfig/Makefile                   |   14 ++++++++------
 scripts/kconfig/lxdialog/check-lxdialog.sh |   16 +++++++++-------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 1ad6f7f..8091435 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -93,12 +93,6 @@ HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
 HOST_EXTRACFLAGS += -DLOCALE
 
-PHONY += $(obj)/dochecklxdialog
-$(obj)/dochecklxdialog:
-	$(Q)$(CONFIG_SHELL) $(check-lxdialog) -check $(HOSTCC) $(HOST_LOADLIBES)
-
-always := dochecklxdialog
-
 
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
@@ -145,6 +139,14 @@ clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
 		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c
 clean-files     += mconf qconf gconf
 
+# Check that we have the required ncurses stuff installed for lxdialog (menuconfig)
+PHONY += $(obj)/dochecklxdialog
+$(addprefix $(obj)/,$(lxdialog)): $(obj)/dochecklxdialog
+$(obj)/dochecklxdialog:
+	$(Q)$(CONFIG_SHELL) $(check-lxdialog) -check $(HOSTCC) $(HOST_EXTRACFLAGS) $(HOST_LOADLIBES)
+
+always := dochecklxdialog
+
 # Add environment specific flags
 HOST_EXTRACFLAGS += $(shell $(CONFIG_SHELL) $(srctree)/$(src)/check.sh $(HOSTCC) $(HOSTCFLAGS))
 
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 9681476..62e1e02 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -36,14 +36,16 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-	echo "main() {}" | $cc -xc - -o $tmp 2> /dev/null
+	echo -e " #include CURSES_LOC \n main() {}" |
+	    $cc -xc - -o $tmp 2> /dev/null
 	if [ $? != 0 ]; then
-		echo " *** Unable to find the ncurses libraries."          1>&2
-		echo " *** make menuconfig require the ncurses libraries"  1>&2
-		echo " *** "                                               1>&2
-		echo " *** Install ncurses (ncurses-devel) and try again"  1>&2
-		echo " *** "                                               1>&2
-		exit 1
+	    echo " *** Unable to find the ncurses libraries or the"       1>&2
+	    echo " *** required header files."                            1>&2
+	    echo " *** 'make menuconfig' requires the ncurses libraries." 1>&2
+	    echo " *** "                                                  1>&2
+	    echo " *** Install ncurses (ncurses-devel) and try again."    1>&2
+	    echo " *** "                                                  1>&2
+	    exit 1
 	fi
 }
 
-- 
1.5.3.4

