Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZBLDn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZBLDn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZBLDnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:43:17 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:35664 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZBLDnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:43:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=FWzNvxs6GVf+t10VlHpmK418qIhWA8kJVHJvJp7nKW1m7+g+l/9ytrp8IMDv1oCd3r
         GTxUYxDkfpsPooyHiNZl9ZbrTiALviLmXO/VNNdTxeb4+sXJfgwiTa5aFNOwMt7IPctG
         L4bgzOeCqAIPwWKxOeNQ1y/QHGZbgsyiH6fdg=
Date: Thu, 12 Feb 2009 04:43:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -rt] nmi: fix a build error
Message-ID: <20090212034310.GA4809@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note this patch applies against rt:origin/master
I guess it relies on a specific topic but I can't find which one.
--
Latest -rt tree fails to build:

arch/x86/kernel/nmi.c: In function ‘nmi_watchdog_tick’:
arch/x86/kernel/nmi.c:463: erreur: implicit declaration of function ‘__profile_tick’
make[1]: *** [arch/x86/kernel/nmi.o] Erreur 1
make: *** [arch/x86/kernel] Erreur 2

nmi.c uses __profile_tick() but lacks its prototype, it needs to include
linux/profile.c
Also, __profile_tick() is missing an off case (!CONFIG_PROFILING) on linux/profile.h

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index c9afd16..4f26868 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -26,6 +26,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
+#include <linux/profile.h>
 
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
diff --git a/include/linux/profile.h b/include/linux/profile.h
index 2e1de8a..e440411 100644
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -97,6 +97,11 @@ static inline int profile_init(void)
 	return 0;
 }
 
+static inline void __profile_tick(int type, struct pt_regs *regs)
+{
+	return;
+}
+
 static inline void profile_tick(int type)
 {
 	return;

