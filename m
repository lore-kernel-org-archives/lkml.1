Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbZAKMGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbZAKMGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZAKMGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:06:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50810
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbZAKMGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:06:40 -0500
Date: Sun, 11 Jan 2009 04:06:40 -0800 (PST)
Message-Id: <20090111.040640.188129980.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, travis@sgi.com,
       mingo@elte.hu
Subject: Re: cpumask change causes sparc build bustage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090111205008.db0a410e.sfr@canb.auug.org.au>
References: <20090111.003103.39502700.davem@davemloft.net>
	<20090111205008.db0a410e.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sun, 11 Jan 2009 20:50:08 +1100

> On Sun, 11 Jan 2009 00:31:03 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> >
> > I'm surprised linux-next builds didn't catch this.
> 
> So am I.  http://kisskb.ellerman.id.au/kisskb/compiler/5/ shows my latest
> builds of both linux-next and Linus' tree are OK for defconfig and
> allnoconfig (allmodconfig fails for a different reason).
> 
> What is different about the failing config (compiler)?  Are there other
> configs it would be sensible to build test?

Maybe you don't have NUMA enabled in the test build configs.
I hit it during an allmodconfig.

Anyways this fixes it, someone please apply:

sparc64: Fix cpumask related build failure.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index b8a65b6..5bc0b8f 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -47,6 +47,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	(pcibus_to_node(bus) == -1 ? \
 	 CPU_MASK_ALL : \
 	 node_to_cpumask(pcibus_to_node(bus)))
+#define cpumask_of_pcibus(bus)	\
+	(pcibus_to_node(bus) == -1 ? \
+	 CPU_MASK_ALL_PTR : \
+	 cpumask_of_node(pcibus_to_node(bus)))
 
 #define SD_NODE_INIT (struct sched_domain) {		\
 	.min_interval		= 8,			\
