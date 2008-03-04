Return-Path: <linux-kernel-owner+w=401wt.eu-S934263AbYCDXpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263AbYCDXpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbYCDXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:45:36 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:14381 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbYCDXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:45:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,444,1199682000"; 
   d="scan'208";a="63635832"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: rusty@rustcorp.com.au, "Andrew Morton" <akpm@linux-foundation.org>
Subject: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Tue, 4 Mar 2008 18:47:15 -0500
User-Agent: KMail/1.9.5
Cc: "LKML" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803041847.15884.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Mar 2008 23:45:33.0011 (UTC) FILETIME=[D622BA30:01C87E51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Today, when module names are looked up, we do not qualify them (check to see 
if the init section is still active or not). This can lead to problems when 
kernel modules get loaded into the same address that the kernel init section 
(or other module's init section was at). We sometimes return the old / no 
lomnger there 

This leads to bogus OOPS messages, and developers wasting their time looking 
for problems (in the kernel init section) where there are none (since it was 
a module).

This patch qualifies the addresses, to make sure the addresses are still valid 
before label/offset.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---

 linux-2.6.x/kernel/kallsyms.c |    3 ++-
 linux-2.6.x/kernel/module.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.x/kernel/kallsyms.c
===================================================================
--- linux-2.6.x/kernel/kallsyms.c	(revision 4212)
+++ linux-2.6.x/kernel/kallsyms.c	(working copy)
@@ -42,7 +42,8 @@
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
-	if (addr >= (unsigned long)_sinittext
+	if (system_state == SYSTEM_BOOTING
+	    && addr >= (unsigned long)_sinittext
 	    && addr <= (unsigned long)_einittext)
 		return 1;
 	return 0;
Index: linux-2.6.x/kernel/module.c
===================================================================
--- linux-2.6.x/kernel/module.c	(revision 4212)
+++ linux-2.6.x/kernel/module.c	(working copy)
@@ -2121,7 +2121,8 @@
 	struct module *mod;
 
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size)
+		if ((within(addr, mod->module_init, mod->init_size)
+		     && mod->state == MODULE_STATE_COMING)
 		    || within(addr, mod->module_core, mod->core_size)) {
 			if (modname)
 				*modname = mod->name;
