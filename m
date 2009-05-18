Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZERHmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZERHmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZERHlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:41:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:48988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbZERHlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:41:12 -0400
Date: Mon, 18 May 2009 07:40:37 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lenb@kernel.org, yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A0DC832.5090200@kernel.org>
References: <4A0DC832.5090200@kernel.org>
Subject: [tip:irq/numa] x86, irq: don't call mp_config_acpi_gsi() if update_mptable is not enabled
Message-ID: <tip-f1bdb523880c7f6990e9e8e50b0fc972ca475e84@git.kernel.org>
Git-Commit-ID: f1bdb523880c7f6990e9e8e50b0fc972ca475e84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:40:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1bdb523880c7f6990e9e8e50b0fc972ca475e84
Gitweb:     http://git.kernel.org/tip/f1bdb523880c7f6990e9e8e50b0fc972ca475e84
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:05:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 09:33:29 +0200

x86, irq: don't call mp_config_acpi_gsi() if update_mptable is not enabled

Len expressed concern that the update_mptable feature has
side-effects on the ACPI code.

Make it sure explicitly that the code only ever gets called if
the (default disabled) update_mptable boot quirk option is
disabled.

[ Impact: isolate the update_mptable feature from ACPI code more ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A0DC832.5090200@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/mpspec.h |    9 +++++++++
 arch/x86/kernel/acpi/boot.c   |    4 +++-
 arch/x86/kernel/mpparse.c     |    2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index c34961a..3dcbaaa 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -87,6 +87,15 @@ static inline int acpi_probe_gsi(void)
 }
 #endif /* CONFIG_ACPI */
 
+#ifdef CONFIG_X86_MPPARSE
+extern int enable_update_mptable;
+#else
+static inline int enable_update_mptable(void)
+{
+	return 0;
+}
+#endif
+
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
 
 struct physid_mask {
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4af63df..844e5e2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1226,7 +1226,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 		       ioapic_pin);
 		return gsi;
 	}
-	mp_config_acpi_gsi(dev, gsi, trigger, polarity);
+
+	if (enable_update_mptable)
+		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index e6bf9d0..651c93b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -957,7 +957,7 @@ out:
 	return 0;
 }
 
-static int __initdata enable_update_mptable;
+int enable_update_mptable;
 
 static int __init update_mptable_setup(char *str)
 {
