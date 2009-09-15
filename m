Return-Path: <linux-kernel-owner+w=401wt.eu-S934363AbZIOD0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363AbZIOD0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZIOD02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:26:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48994 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZIOD01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:26:27 -0400
Date: Tue, 15 Sep 2009 13:26:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Siarhei Liakh <sliakh.lkml@gmail.com>, Xuxian Jiang <jiang@cs.ncsu.edu>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20090915132626.1997607e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in kernel/module.c
between commit 7ead8b8313d92b3a69a1a61b0dcbc4cd66c960dc ("tracing/events:
Add module tracepoints") from Linus' tree and commit
25306e21864c2a220d6fa2e0632425028aa9626c ("module:ro-nx-protection") from
the rr tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/module.c
index 46580ed,6f84bb5..0000000
--- a/kernel/module.c
+++ b/kernel/module.c
@@@ -54,12 -54,8 +54,13 @@@
  #include <linux/async.h>
  #include <linux/percpu.h>
  #include <linux/kmemleak.h>
+ #include <linux/pfn.h>
  
 +#define CREATE_TRACE_POINTS
 +#include <trace/events/module.h>
 +
 +EXPORT_TRACEPOINT_SYMBOL(module_get);
 +
  #if 0
  #define DEBUGP printk
  #else
@@@ -2373,8 -2600,18 +2609,20 @@@ static noinline struct module *load_mod
  	/* Get rid of temporary copy */
  	vfree(hdr);
  
+ 	/* Set RO and NX regions for core */
+ 	set_section_ro_nx(mod->module_core,
+ 			  mod->core_text_size,
+ 			  mod->core_ro_size,
+ 			  mod->core_size);
+ 
+ 	/* Set RO and NX regions for init */
+ 	set_section_ro_nx(mod->module_init,
+ 			  mod->init_text_size,
+ 			  mod->init_ro_size,
+ 			  mod->init_size);
+ 
 +	trace_module_load(mod);
 +
  	/* Done! */
  	return mod;
  
