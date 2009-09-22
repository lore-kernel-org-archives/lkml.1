Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZIVFF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZIVFF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZIVFF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:05:27 -0400
Received: from ozlabs.org ([203.10.76.45]:36927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZIVFF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:05:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] fix error handling in load_module()
Date: Tue, 22 Sep 2009 14:35:21 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
References: <20090907141558.GA5456@linux.vnet.ibm.com> <20090910141430.a00dcc94.akpm@linux-foundation.org> <4AB79091.1050004@kernel.org>
In-Reply-To: <4AB79091.1050004@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909221435.22512.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 12:11:21 am Tejun Heo wrote:
> Hello, Andrew.
> 
> Andrew Morton wrote:
> > My reverse engineering of the secret, undocumented percpu_modfree()
> > indicates that its mad inventor intended that percpu_modfree(NULL) be a
> > valid thing to do.
> > 
> > It calls free_percpu(), all implementations of which appear to secretly
> > support free_percpu(NULL).
> 
> Eh... unfortunately, the original percpu_modfree() implementation
> didn't seem to support it.

OK, I'll Andrew's fix for Tejun, and after his (spot-on!) comment about
percpu_modfree never taking NULL, I've fixed the one caller to match
the other two:

Subject: module: don't call percpu_modfree on NULL pointer.

The general one handles NULL, the static obsolescent
(CONFIG_HAVE_LEGACY_PER_CPU_AREA) one in module.c doesn't; Eric's
commit 720eba31 assumed it did, and various frobbings since then kept
that assumption.

All other callers in module.c all protect it with an if; this effectively
does the same as free_init is only goto if we fail percpu_modalloc().

Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Américo Wang <xiyou.wangcong@gmail.com>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2522,8 +2522,8 @@ static noinline struct module *load_modu
  free_unload:
 	module_unload_free(mod);
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	percpu_modfree(mod->refptr);
  free_init:
-	percpu_modfree(mod->refptr);
 #endif
 	module_free(mod, mod->module_init);
  free_core:
