Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbXEKPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbXEKPc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbXEKPcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 11:32:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:43474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXEKPcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 11:32:50 -0400
Date: Fri, 11 May 2007 17:32:48 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [i386/x86-64] Fix section mismatch
Message-ID: <20070511153248.GA22577@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following compile warning:

--------- >8 --------
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to
.init.text:mtrr_bp_init from .text between 'id entify_cpu' (at offset 0x6571)
and 'IRQ0x20_interrupt'
--------- 8< --------

It's because identify_cpu() which is __cpuinit calls mtrr_bp_init() which is
__init(). __cpuinit() expands to nothing if CONFIG_HOTPLUG_CPU=y and so the
call is illegal.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/i386/kernel/cpu/mtrr/generic.c
+++ b/arch/i386/kernel/cpu/mtrr/generic.c
@@ -78,7 +78,7 @@ static void __cpuinit print_fixed(unsign
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void __init get_mtrr_state(void)
+void get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void __init mtrr_bp_init(void)
+void mtrr_bp_init(void)
 {
 	init_ifs();
 
