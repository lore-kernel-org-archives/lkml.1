Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYFVTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYFVTF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYFVTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:04:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbYFVTEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:04:41 -0400
Date: Sun, 22 Jun 2008 12:01:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
Message-ID: <20080622190131.GB20141@suse.de>
References: <20080622185327.348377223@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-use-bootmem_exclusive-on-32-bit.patch"
In-Reply-To: <20080622190111.GA20141@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Bernhard Walle <bwalle@suse.de>

commit d3942cff620bea073fc4e3c8ed878eb1e84615ce upstream

This patch uses the BOOTMEM_EXCLUSIVE for crashkernel reservation also for
i386 and prints a error message on failure.

The patch is still for 2.6.26 since it is only bug fixing. The unification
of reserve_crashkernel() between i386 and x86_64 should be done for 2.6.27.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup_32.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -483,10 +483,16 @@ static void __init reserve_crashkernel(v
 					(unsigned long)(crash_size >> 20),
 					(unsigned long)(crash_base >> 20),
 					(unsigned long)(total_mem >> 20));
+
+			if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+				printk(KERN_INFO "crashkernel reservation "
+					"failed - memory is in use\n");
+				return;
+			}
+
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");

-- 
