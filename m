Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbXGJAKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbXGJAKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbXGJAKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:10:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56178 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757526AbXGJAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:10:01 -0400
Date: Tue, 10 Jul 2007 02:10:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org
Subject: [2.6 patch] arch/i386/kernel/cpu/intel_cacheinfo.c: fix section
	mismatch
Message-ID: <20070710001034.GN3492@stusta.de>
References: <20070709184200.GA2496@janus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070709184200.GA2496@janus>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 08:42:01PM +0200, Frank van Maarseveen wrote:
>...
> WARNING: arch/i386/kernel/built-in.o(.exit.text+0x1c): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
>...

Below is the fix in -mm for this bug.

> Frank

cu
Adrian


<--  snip  -->


From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3818): Section mismatch: reference to .exit.text:cache_remove_dev (between 'cacheinfo_cpu_callback' and 'cache_sysfs_init')

It points out that a function marked __cpuexit is calling a function marked
__cpuinit => oops.

The call happens only in an error-condition which may explain why we have
not seen it before.

The offending function was not used anywhere else - so marked it __cpuexit.

Note: This warning triggers only with a local copy of modpost
      but that version will soon be pushed out.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

@stable:
Real bug present with gcc < 4.0 that should be fixed.

 arch/i386/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~i386-fix-section-mismatch-warning-in-intel_cacheinfo arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~i386-fix-section-mismatch-warning-in-intel_cacheinfo
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -746,7 +746,7 @@ static int __cpuinit cache_add_dev(struc
 	return retval;
 }
 
-static void __cpuexit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
_
