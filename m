Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbXLITLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbXLITLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXLITLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:11:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45093 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbXLITLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:11:32 -0500
Date: Sun, 9 Dec 2007 20:13:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: menuconfig: fail with clearer error if curses.h N/A
Message-ID: <20071209191317.GA8496@uranus.ravnborg.org>
References: <200710142323.21139.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710142323.21139.elendil@planet.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 11:23:20PM +0200, Frans Pop wrote:
> It would be nice if 'make menuconfig' could fail earlier or with a clearer
> error if curses.h is not available. The actual error is currently rather
> buried in a huge amount of indirect errors.

It worked some time ago but I did not bother to check it out
when it broke.
With following patch it fails like this:

$ make menuconfig
 *** Unable to find the ncurses libraries
 *** or the required header files.
 *** make menuconfig require the ncurses libraries
 ***
 *** Install ncurses (ncurses-devel) and try again
 ***
make[1]: *** [scripts/kconfig/dochecklxdialog] Error 1
make: *** [menuconfig] Error 2

This is much better.

	Sam

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
index 9681476..451297f 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -36,9 +36,10 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-	echo "main() {}" | $cc -xc - -o $tmp 2> /dev/null
+	echo " \#include CURSES_LOC main() {}" | $cc -xc - -o $tmp 2> /dev/null
 	if [ $? != 0 ]; then
-		echo " *** Unable to find the ncurses libraries."          1>&2
+		echo " *** Unable to find the ncurses libraries"           1>&2
+		echo " *** or the required header files."                  1>&2
 		echo " *** make menuconfig require the ncurses libraries"  1>&2
 		echo " *** "                                               1>&2
 		echo " *** Install ncurses (ncurses-devel) and try again"  1>&2
