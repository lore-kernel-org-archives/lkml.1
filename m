Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZH1IpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZH1IpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 04:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZH1IpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 04:45:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZH1IpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 04:45:14 -0400
Date: Fri, 28 Aug 2009 10:44:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>
Subject: modules: Fix build error in the !CONFIG_KALLSYMS case
Message-ID: <20090828084456.GB3454@elte.hu>
References: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> James Bottomley (1):
>       module: workaround duplicate section names

-tip testing found that this patch breaks the build on x86 if 
CONFIG_KALLSYMS is disabled:

 kernel/module.c: In function ‘load_module’:
 kernel/module.c:2367: error: ‘struct module’ has no member named ‘sect_attrs’
 distcc[8269] ERROR: compile kernel/module.c on ph/32 failed
 make[1]: *** [kernel/module.o] Error 1
 make: *** [kernel] Error 2
 make: *** Waiting for unfinished jobs....

Commit 1b364bf misses the fact that section attributes are only 
built and dealt with if kallsyms is enabled. The patch below fixes 
this.

( note, technically speaking this should depend on CONFIG_SYSFS as
  well but this patch is correct too and keeps the #ifdef less
  intrusive - in the KALLSYMS && !SYSFS case the code is a NOP. )

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index eccb561..b4016d1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2355,8 +2355,10 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+#ifdef CONFIG_KALLSYMS
 	if (mod->sect_attrs)
 		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+#endif
 
 	/* Get rid of temporary copy */
 	vfree(hdr);
