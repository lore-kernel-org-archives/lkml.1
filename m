Return-Path: <linux-kernel-owner+w=401wt.eu-S934510AbZDBHD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbZDBHD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbZDBHDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:03:24 -0400
Received: from sous-sol.org ([216.99.217.87]:49082 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755898AbZDBHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:03:22 -0400
Date: Wed, 1 Apr 2009 23:58:05 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Jake Edge <jake@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>, davem@davemloft.net
Subject: [PATCH 48/45] sparc64: Fix reset hangs on Niagara systems.
Message-ID: <20090402065805.GD18394@sequoia.sous-sol.org>
References: <20090331231045.719396245@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331231045.719396245@sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit ffaba674090f287afe0c44fd8d978c64c03581a8 ]

Hypervisor versions older than version 1.6.1 cannot handle
leaving the profile counter overflow interrupt chirping
when the system does a soft reset.

So use a reboot notifier to shut off the NMI watchdog.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/sparc/kernel/nmi.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/kernel_stat.h>
+#include <linux/reboot.h>
 #include <linux/slab.h>
 #include <linux/kdebug.h>
 #include <linux/delay.h>
@@ -206,13 +207,33 @@ void nmi_adjust_hz(unsigned int new_hz)
 }
 EXPORT_SYMBOL_GPL(nmi_adjust_hz);
 
+static int nmi_shutdown(struct notifier_block *nb, unsigned long cmd, void *p)
+{
+	on_each_cpu(stop_watchdog, NULL, 1);
+	return 0;
+}
+
+static struct notifier_block nmi_reboot_notifier = {
+	.notifier_call = nmi_shutdown,
+};
+
 int __init nmi_init(void)
 {
+	int err;
+
 	nmi_usable = 1;
 
 	on_each_cpu(start_watchdog, NULL, 1);
 
-	return check_nmi_watchdog();
+	err = check_nmi_watchdog();
+	if (!err) {
+		err = register_reboot_notifier(&nmi_reboot_notifier);
+		if (err) {
+			nmi_usable = 0;
+			on_each_cpu(stop_watchdog, NULL, 1);
+		}
+	}
+	return err;
 }
 
 static int __init setup_nmi_watchdog(char *str)
