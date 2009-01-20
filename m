Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbZATJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbZATJhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZATJhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:37:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:45033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbZATJhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:37:41 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: mtrr fix debug parameter
Date: Tue, 20 Jan 2009 10:37:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.11-HEAD_20090116074536_2c57617f-default; KDE/4.1.3; x86_64; ; )
Cc: mingo@elte.hu, Jan Beulich <jbeulich@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901201037.39981.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while looking at:
http://bugzilla.kernel.org/show_bug.cgi?id=11541
I realized that the mtrr.show param cannot work, because
the code is processed much too early.

This patch:
 - Declares mtrr.show as early_param
 - Stays consistent with the previous param (which I doubt
   that it ever worked), so mtrr.show=1 would still work
 - Declares mtrr_show as initdata


Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -33,11 +33,13 @@ u64 mtrr_tom2;
 struct mtrr_state_type mtrr_state = {};
 EXPORT_SYMBOL_GPL(mtrr_state);
 
-#undef MODULE_PARAM_PREFIX
-#define MODULE_PARAM_PREFIX "mtrr."
-
-static int mtrr_show;
-module_param_named(show, mtrr_show, bool, 0);
+static int __initdata mtrr_show;
+static int __init mtrr_debug(char *opt)
+{
+	mtrr_show = 1;
+	return 0;
+}
+early_param("mtrr.show", mtrr_debug);
 
 /*
  * Returns the effective MTRR type for the region

