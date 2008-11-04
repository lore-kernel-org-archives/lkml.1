Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYKDXxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYKDXxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbYKDXkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:23 -0500
Received: from ns1.suse.de ([195.135.220.2]:47749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537AbYKDXkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:21 -0500
Date: Tue, 4 Nov 2008 15:33:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 42/57] rtc-cmos: look for PNP RTC first, then for platform
	RTC
Message-ID: <20081104233305.GQ659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc-cmos-look-for-pnp-rtc-first-then-for-platform-rtc.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

commit 72f22b1eb6ca5e4676a632a04d40d46cb61d4562 upstream

rtc-cmos: look for PNP RTC first, then for platform RTC

We shouldn't rely on "pnp_platform_devices" to tell us whether there
is a PNP RTC device.

I introduced "pnp_platform_devices", but I think it was a mistake.
All it tells us is whether we found any PNPBIOS or PNPACPI devices.
Many machines have some PNP devices, but do not describe the RTC
via PNP.  On those machines, we need to do the platform driver probe
to find the RTC.

We should just register the PNP driver and see whether it claims anything.
If we don't find a PNP RTC, fall back to the platform driver probe.

This (in conjunction with the arch/x86/kernel/rtc.c patch to add
a platform RTC device when PNP doesn't have one) should resolve
these issues:

    http://bugzilla.kernel.org/show_bug.cgi?id=11580
    https://bugzilla.redhat.com/show_bug.cgi?id=451188

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Reported-by: Rik Theys <rik.theys@esat.kuleuven.be>
Reported-by: shr_msn@yahoo.com.tw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-cmos.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1030,29 +1030,32 @@ static struct platform_driver cmos_platf
 
 static int __init cmos_init(void)
 {
+	int retval = 0;
+
+#ifdef	CONFIG_PNP
+	pnp_register_driver(&cmos_pnp_driver);
+#endif
+
+	if (!cmos_rtc.dev)
+		retval = platform_driver_probe(&cmos_platform_driver,
+					       cmos_platform_probe);
+
+	if (retval == 0)
+		return 0;
+
 #ifdef	CONFIG_PNP
-	if (pnp_platform_devices)
-		return pnp_register_driver(&cmos_pnp_driver);
-	else
-		return platform_driver_probe(&cmos_platform_driver,
-			cmos_platform_probe);
-#else
-	return platform_driver_probe(&cmos_platform_driver,
-			cmos_platform_probe);
-#endif /* CONFIG_PNP */
+	pnp_unregister_driver(&cmos_pnp_driver);
+#endif
+	return retval;
 }
 module_init(cmos_init);
 
 static void __exit cmos_exit(void)
 {
 #ifdef	CONFIG_PNP
-	if (pnp_platform_devices)
-		pnp_unregister_driver(&cmos_pnp_driver);
-	else
-		platform_driver_unregister(&cmos_platform_driver);
-#else
+	pnp_unregister_driver(&cmos_pnp_driver);
+#endif
 	platform_driver_unregister(&cmos_platform_driver);
-#endif /* CONFIG_PNP */
 }
 module_exit(cmos_exit);
 

-- 
