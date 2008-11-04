Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYKDXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYKDXxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbYKDXkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553AbYKDXka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:30 -0500
Date: Tue, 4 Nov 2008 15:33:09 -0800
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
Subject: [patch 44/57] x86: register a platform RTC device if PNP doesnt
	describe it
Message-ID: <20081104233309.GS659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-register-a-platform-rtc-device-if-pnp-doesn-t-describe-it.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

commit 758a7f7bb86b520aadc484f23da85e547b3bf3d8 upstream

x86: register a platform RTC device if PNP doesn't describe it

Most if not all x86 platforms have an RTC device, but sometimes the RTC
is not exposed as a PNP0b00/PNP0b01/PNP0b02 device in PNPBIOS or ACPI:

    http://bugzilla.kernel.org/show_bug.cgi?id=11580
    https://bugzilla.redhat.com/show_bug.cgi?id=451188

It's best if we can discover the RTC via PNP because then we know
which flavor of device it is, where it lives, and which IRQ it uses.

But if we can't, we should register a platform device using the
compiled-in RTC_PORT/RTC_IRQ resource assumptions.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Reported-by: Rik Theys <rik.theys@esat.kuleuven.be>
Reported-by: shr_msn@yahoo.com.tw
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/rtc.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -223,11 +223,25 @@ static struct platform_device rtc_device
 static __init int add_rtc_cmos(void)
 {
 #ifdef CONFIG_PNP
-	if (!pnp_platform_devices)
-		platform_device_register(&rtc_device);
-#else
+	static const char *ids[] __initconst =
+	    { "PNP0b00", "PNP0b01", "PNP0b02", };
+	struct pnp_dev *dev;
+	struct pnp_id *id;
+	int i;
+
+	pnp_for_each_dev(dev) {
+		for (id = dev->id; id; id = id->next) {
+			for (i = 0; i < ARRAY_SIZE(ids); i++) {
+				if (compare_pnp_id(id, ids[i]) != 0)
+					return 0;
+			}
+		}
+	}
+#endif
+
 	platform_device_register(&rtc_device);
-#endif /* CONFIG_PNP */
+	dev_info(&rtc_device.dev,
+		 "registered platform RTC device (no PNP device found)\n");
 	return 0;
 }
 device_initcall(add_rtc_cmos);

-- 
