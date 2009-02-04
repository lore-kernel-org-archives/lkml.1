Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZBDVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZBDVbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZBDVbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:31:35 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37096 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbZBDVbe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:31:34 -0500
Date: Wed, 4 Feb 2009 16:31:16 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 5/7] Ksplice: Add functions for walking kallsyms
 symbols
In-Reply-To: <200902042200.50726.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0902041605140.32142@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-5-git-send-email-jbarnold@mit.edu> <1228521840-3886-6-git-send-email-jbarnold@mit.edu> <200902042200.50726.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rusty Russell wrote:
> Seems reasonable.  Did you really not want a name-filtering version?  That
> might be generally useful.

We don’t actually want a name-filtering version for Ksplice.  We process 
all the symbols we need in one pass, in order to avoid traversing the 
kallsyms list separately for each symbol.

> But does no locking at all.  It either needs a comment that it can only be
> called from inside stop_machine, or that it needs preempt disabled, or
> whatever.

It might as well use preempt_disable() and RCU itself (patch below).

> Is the !CONFIG_KALLSYMS version useful to you?  If not, please don't
> implement the noop version.  I want someone who *does* expect it to work to
> have to think about it if they use it...

No, we don’t have a particular use for it; we added it for consistency 
with kallsyms_lookup_name(), etc.

Anders

diff --git a/kernel/module.c b/kernel/module.c
index 556112c..6bb5814 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2577,17 +2577,20 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 {
 	struct module *mod;
 	unsigned int i;
-	int ret;
+	int ret = 0;

-	list_for_each_entry(mod, &modules, list) {
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list) {
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
 				 mod, mod->symtab[i].st_value);
 			if (ret != 0)
-				return ret;
+				goto out;
 		}
 	}
-	return 0;
+out:
+	preempt_enable();
+	return ret;
 }
 #endif /* CONFIG_KALLSYMS */

