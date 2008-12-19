Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYLSVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYLSVCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYLSVCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:02:07 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55497 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYLSVCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:02:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ferqI6ZFwlYd0ZaI+4IVhGYLSHMaMBrZHxIeWisFGGawC2qhKVmjV9up4mhJtnBYzi
         kgKmv5yHFNcxFaqtcxHonkPXvFHNRc88fn14jCe+b07kEvAn9IuvWq+ERmZ4V/NqDp6W
         lgeazGcVAlmLtOJgtRIRmjI8yj/eYhbKr2ZSI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 19 (new CONFIG_NUMA_MIGRATE_IRQ_DESC option)
Date: Fri, 19 Dec 2008 22:01:28 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081219; KDE/4.1.3; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <20081219235757.6b94d9ef.sfr@canb.auug.org.au>
In-Reply-To: <20081219235757.6b94d9ef.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812192201.28665.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 December 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081218:
 
Just few very minor issues w.r.t. "x86, sparseirq: move irq_desc according
to smp_affinity, v7" (commit 48a1b10aff588833b73994704c47bbd0deb73e9c):

+config NUMA_MIGRATE_IRQ_DESC
+	bool "Move irq desc when changing irq smp_affinity"
+	depends on SPARSE_IRQ && SMP
+	default n
+	help
+	  This enables moving irq_desc to cpu/node that irq will use handled.
+
+	  If you don't know what to do here, say N.

This is a bit confusing (at least I was confused since I don't have NUMA
set in my config) -- either it should depend on NUMA or the config option
name should be changed.

@@ -2346,14 +2466,34 @@ static void irq_complete_move(struct irq_desc **descp)
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
-	if (likely(!cfg->move_in_progress))
+	if (likely(!cfg->move_in_progress)) {
+#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
+		if (likely(!cfg->move_desc_pending))
+			return;
+
+		/* domain is not change, but affinity is changed */

this comment sounds weird

perhaps: /* only affinity is changed */ would be better?

+++ b/kernel/irq/numa_migrate.c
@@ -0,0 +1,127 @@
+/*
+ * linux/kernel/irq/handle.c
+ *
+ * Copyright (C) 1992, 1998-2006 Linus Torvalds, Ingo Molnar
+ * Copyright (C) 2005-2006, Thomas Gleixner, Russell King
+ *
+ * This file contains the core interrupt handling code.
+ *
+ * Detailed information is available in Documentation/DocBook/genericirq
+ *
+ */

hmmm? ;-)
