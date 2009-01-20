Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbZATKKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbZATKKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbZATKK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:10:28 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34937 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508AbZATKK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:10:26 -0500
Message-Id: <4975B139.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 20 Jan 2009 10:10:49 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <mingo@elte.hu>, "Thomas Renninger" <trenn@suse.de>
Subject: Re: [PATCH] x86: mtrr fix debug parameter
References: <200901201037.39981.trenn@suse.de>
In-Reply-To: <200901201037.39981.trenn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been carrying a change like this for quite some time in a bigger patch,
but never got to actually split it out and submit it. Thanks for doing this,
Thomas! (And yes, it did work at the time it was added.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

>>> Thomas Renninger <trenn@suse.de> 20.01.09 10:37 >>>
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


