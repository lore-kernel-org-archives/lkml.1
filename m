Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYGVXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYGVXVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYGVXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:18:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:52846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbYGVXSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:18:06 -0400
Date: Tue, 22 Jul 2008 16:14:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Dooks <ben-linux@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 10/47] OHCI: Fix problem if SM501 and another platform
	driver is selected
Message-ID: <20080722231452.GK8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ohci-fix-problem-if-sm501-and-another-platform-driver-is-selected.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ben Dooks <ben-linux@fluff.org>

commit 3ee38d8bf46b364b1ca364ddb7c379a4afcd8bbb upstream

If the SM501 and another platform driver, such as the SM501
then we end up defining PLATFORM_DRIVER twice. This patch
seperated the SM501 onto a seperate define of SM501_OHCI_DRIVER
so that it can be selected without overwriting the original
definition.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-hcd.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1054,7 +1054,7 @@ MODULE_LICENSE ("GPL");
 
 #ifdef CONFIG_MFD_SM501
 #include "ohci-sm501.c"
-#define PLATFORM_DRIVER		ohci_hcd_sm501_driver
+#define SM501_OHCI_DRIVER	ohci_hcd_sm501_driver
 #endif
 
 #if	!defined(PCI_DRIVER) &&		\
@@ -1062,6 +1062,7 @@ MODULE_LICENSE ("GPL");
 	!defined(OF_PLATFORM_DRIVER) &&	\
 	!defined(SA1111_DRIVER) &&	\
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
+	!defined(SM501_OHCI_DRIVER) && \
 	!defined(SSB_OHCI_DRIVER)
 #error "missing bus glue for ohci-hcd"
 #endif
@@ -1121,9 +1122,18 @@ static int __init ohci_hcd_mod_init(void
 		goto error_ssb;
 #endif
 
+#ifdef SM501_OHCI_DRIVER
+	retval = platform_driver_register(&SM501_OHCI_DRIVER);
+	if (retval < 0)
+		goto error_sm501;
+#endif
+
 	return retval;
 
 	/* Error path */
+#ifdef SM501_OHCI_DRIVER
+ error_sm501:
+#endif
 #ifdef SSB_OHCI_DRIVER
  error_ssb:
 #endif
@@ -1159,6 +1169,9 @@ module_init(ohci_hcd_mod_init);
 
 static void __exit ohci_hcd_mod_exit(void)
 {
+#ifdef SM501_OHCI_DRIVER
+	platform_driver_unregister(&SM501_OHCI_DRIVER);
+#endif
 #ifdef SSB_OHCI_DRIVER
 	ssb_driver_unregister(&SSB_OHCI_DRIVER);
 #endif

-- 
