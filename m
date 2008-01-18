Return-Path: <linux-kernel-owner+w=401wt.eu-S1765173AbYARVas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765173AbYARVas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbYARVak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:30:40 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:9712 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757262AbYARVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:30:39 -0500
X-Belgacom-Dynamic: yes
Date: Fri, 18 Jan 2008 22:30:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.24-rc8 patches
Message-ID: <20080118213034.GA7256@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/watchdog/watchdog-api.txt |   38 +++++++++++++++++---------------
 drivers/watchdog/w83697hf_wdt.c         |    4 ---
 2 files changed, 22 insertions(+), 20 deletions(-)

with these Changes:

Author: Andrew Dyer <amdyer@gmail.com>
Date:   Tue Jan 8 14:40:37 2008 -0600

    [WATCHDOG] clarify watchdog operation in documentation
    
    It was not clear what the difference is/was between the
    nowayout feature and the Magic Close feature.
    
    Signed-off-by: "Andrew Dyer" <amdyer@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jan 18 21:01:34 2008 +0000

    [WATCHDOG] Revert "Stop looking for device as soon as one is found"
    
    This reverts commit 3ff6eb4a2fe5757cbe7c5d57c8eb60ab0775f2f0.
    
    the !found check in the for loop allready made sure that only one
    device was found.
    
    Signed-Off-By: Pádraig Brady <P@draigBrady.com>
    Signed-Off-By: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index bb7cb1d..4cc4ba9 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -42,23 +42,27 @@ like this source file:  see Documentation/watchdog/src/watchdog-simple.c
 A more advanced driver could for example check that a HTTP server is
 still responding before doing the write call to ping the watchdog.
 
-When the device is closed, the watchdog is disabled.  This is not
-always such a good idea, since if there is a bug in the watchdog
-daemon and it crashes the system will not reboot.  Because of this,
-some of the drivers support the configuration option "Disable watchdog
-shutdown on close", CONFIG_WATCHDOG_NOWAYOUT.  If it is set to Y when
-compiling the kernel, there is no way of disabling the watchdog once
-it has been started.  So, if the watchdog daemon crashes, the system
-will reboot after the timeout has passed. Watchdog devices also usually
-support the nowayout module parameter so that this option can be controlled
-at runtime.
-
-Drivers will not disable the watchdog, unless a specific magic character 'V'
-has been sent /dev/watchdog just before closing the file.  If the userspace
-daemon closes the file without sending this special character, the driver
-will assume that the daemon (and userspace in general) died, and will stop
-pinging the watchdog without disabling it first.  This will then cause a
-reboot if the watchdog is not re-opened in sufficient time.
+When the device is closed, the watchdog is disabled, unless the "Magic
+Close" feature is supported (see below).  This is not always such a
+good idea, since if there is a bug in the watchdog daemon and it
+crashes the system will not reboot.  Because of this, some of the
+drivers support the configuration option "Disable watchdog shutdown on
+close", CONFIG_WATCHDOG_NOWAYOUT.  If it is set to Y when compiling
+the kernel, there is no way of disabling the watchdog once it has been
+started.  So, if the watchdog daemon crashes, the system will reboot
+after the timeout has passed. Watchdog devices also usually support
+the nowayout module parameter so that this option can be controlled at
+runtime.
+
+Magic Close feature:
+
+If a driver supports "Magic Close", the driver will not disable the
+watchdog unless a specific magic character 'V' has been sent to
+/dev/watchdog just before closing the file.  If the userspace daemon
+closes the file without sending this special character, the driver
+will assume that the daemon (and userspace in general) died, and will
+stop pinging the watchdog without disabling it first.  This will then
+cause a reboot if the watchdog is not re-opened in sufficient time.
 
 The ioctl API:
 
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 6ea125e..c622a0e 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -382,10 +382,8 @@ wdt_init(void)
 		/* we will autodetect the W83697HF/HG watchdog */
 		for (i = 0; ((!found) && (w83697hf_ioports[i] != 0)); i++) {
 			wdt_io = w83697hf_ioports[i];
-			if (!w83697hf_check_wdt()) {
+			if (!w83697hf_check_wdt())
 				found++;
-				break;
-			}
 		}
 	} else {
 		if (!w83697hf_check_wdt())
