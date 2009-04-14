Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZDNRfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZDNRfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZDNRfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:35:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:36997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZDNRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:35:03 -0400
Subject: Re: [PATCH -tip] x86: k8.h reference to node in node_to_k8_nb_misc
 for !CONFIG_K8_NB
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>
In-Reply-To: <20090414171756.GA18510@elte.hu>
References: <1239727500.2966.16.camel@ht.satnam>
	 <20090414165241.GB2089@elte.hu> <1239728876.2966.23.camel@ht.satnam>
	 <20090414171756.GA18510@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Apr 2009 23:04:37 +0530
Message-Id: <1239730477.2966.26.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 19:17 +0200, Ingo Molnar wrote:

> I.e. convert node_to_k8_nb_misc() from a macro to an inline 
> function. Same end result in terms of emitted instructions, 
> but the compiler now knows that 'node' is really used.
> 
> With a macro the preprocessor hid this fact from the 
> compiler, so the compiler only saw this in essence:
> 
>         int node = 0;
>         struct pci_dev *dev;
> 
> and thought that 'node' was unused. Hence it emitted a 
> warning. This is one reason why macros are bad - they hide 
> program logic from the compiler.
> 

Subject: [PATCH] x86: k8 convert node_to_k8_nb_misc() from a macro to an inline function

Converting node_to_k8_nb_misc() from a macro to an inline function
makes complier happy for !CONFIG_K8_NB so fixes compiler warnings:
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’

Thanks to Ingo for the guidance.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/k8.h |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index c23b3d1..c2d1f3b 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -13,10 +13,15 @@ extern void k8_flush_garts(void);
 extern int k8_scan_nodes(unsigned long start, unsigned long end);
 
 #ifdef CONFIG_K8_NB
-#define node_to_k8_nb_misc(node) \
-	(node < num_k8_northbridges) ? k8_northbridges[node] : NULL
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
+}
 #else
-#define node_to_k8_nb_misc(node) NULL
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return NULL;
+}
 #endif
 
 
-- 
1.6.0.6



