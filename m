Return-Path: <linux-kernel-owner+w=401wt.eu-S1751687AbZIVCa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbZIVCa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZIVCa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:30:27 -0400
Received: from ozlabs.org ([203.10.76.45]:48421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZIVCa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:30:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [2.6.31] Memory leak in load_module()?
Date: Tue, 22 Sep 2009 12:00:22 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
References: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
In-Reply-To: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221200.22743.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 05:08:46 pm Tetsuo Handa wrote:
> Is this real memory leak?

Yep.

God, this code is a turd.  This should fix it though:

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1907,6 +1924,17 @@ static void setup_modinfo(struct module 
 	}
 }
 
+static void free_modinfo(struct module *mod)
+{
+	struct module_attribute *attr;
+	int i;
+
+	for (i = 0; (attr = modinfo_attrs[i]); i++) {
+		if (attr->free)
+			attr->free(mod);
+	}
+}
+
 #ifdef CONFIG_KALLSYMS
 
 /* lookup symbol in given range of kernel_symbols */
@@ -2632,6 +2662,7 @@ static noinline struct module *load_modu
 	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
+	free_modinfo(mod);
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
  free_unload:
