Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYHSW4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYHSW4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYHSWxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:48 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:13681 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYHSWxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 6/8] PNP: add CONFIG_PNP_DEBUG_MESSAGES and pnp_dbg()
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:41 -0600
Message-ID: <20080819225341.28206.83384.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds the core function pnp_dbg() and a new config option to
enable it.

The PNP core debugging messages can be enabled at boot-time with the
"pnp.debug" kernel parameter.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 Documentation/kernel-parameters.txt |    4 ++++
 drivers/pnp/Kconfig                 |   14 ++++++++++++++
 drivers/pnp/base.h                  |   10 ++++++++++
 drivers/pnp/core.c                  |   11 +++++++++++
 4 files changed, 39 insertions(+), 0 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e7bea3e..2c45c97 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1655,6 +1655,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			Override pmtimer IOPort with a hex value.
 			e.g. pmtmr=0x508
 
+	pnp.debug	[PNP]
+			Enable PNP debug messages.  This depends on the
+			CONFIG_PNP_DEBUG_MESSAGES option.
+
 	pnpacpi=	[ACPI]
 			{ off }
 
diff --git a/drivers/pnp/Kconfig b/drivers/pnp/Kconfig
index 821933f..8a3237f 100644
--- a/drivers/pnp/Kconfig
+++ b/drivers/pnp/Kconfig
@@ -20,6 +20,20 @@ menuconfig PNP
 
 	  If unsure, say Y.
 
+config PNP_DEBUG_MESSAGES
+	default y
+	bool "PNP debugging messages"
+	depends on PNP
+	help
+	  Say Y here if you want the PNP layer to be able to produce debugging
+	  messages if needed.  The messages can be enabled at boot-time with
+	  the pnp.debug kernel parameter.
+
+	  This option allows you to save a bit of space if you do not want
+	  the messages to even be built into the kernel.
+
+	  If you have any doubts about this, say Y here.
+
 if PNP
 
 config PNP_DEBUG
diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 9fd7bb9..5e4e82c 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -166,3 +166,13 @@ struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 					  resource_size_t start,
 					  resource_size_t end, int flags);
+
+extern int pnp_debug;
+
+#if defined(CONFIG_PNP_DEBUG_MESSAGES)
+#define pnp_dbg(dev, format, arg...)					\
+	({ if (pnp_debug) dev_printk(KERN_DEBUG, dev, format, ## arg); 0; })
+#else
+#define pnp_dbg(dev, format, arg...)					\
+	({ if (0) dev_printk(KERN_DEBUG, dev, format, ## arg); 0; })
+#endif
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 7cb1ffc..61291b5 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -221,3 +221,14 @@ static int __init pnp_init(void)
 }
 
 subsys_initcall(pnp_init);
+
+int pnp_debug;
+
+#if defined(CONFIG_PNP_DEBUG_MESSAGES)
+static int __init pnp_debug_setup(char *__unused)
+{
+	pnp_debug = 1;
+	return 1;
+}
+__setup("pnp.debug", pnp_debug_setup);
+#endif

