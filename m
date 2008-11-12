Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYKLA2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYKLA2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYKLA0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:07 -0500
Received: from kroah.org ([198.145.64.141]:42092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752468AbYKLA0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:04 -0500
Date: Tue, 11 Nov 2008 16:23:01 -0800
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 05/49] x86: fix CONFIG_X86_RESERVE_LOW_64K=y
Message-ID: <20081112002301.GF10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-config_x86_reserve_low_64k-y.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yhlu.kernel@gmail.com>

commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439 upstream

The bad_bios_dmi_table() quirk never triggered because we do DMI setup
too late. Move it a bit earlier.

Also change the CONFIG_X86_RESERVE_LOW_64K quirk to operate on the e820
table directly instead of messing with early reservations - this handles
overlaps (which do occur in this low range of RAM) more gracefully.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -584,7 +584,8 @@ static int __init dmi_low_memory_corrupt
 		"%s detected: BIOS may corrupt low RAM, working it around.\n",
 		d->ident);
 
-	reserve_early_overlap_ok(0x0, 0x10000, "BIOS quirk");
+	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
 	return 0;
 }
@@ -633,8 +634,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
-	dmi_check_system(bad_bios_dmi_table);
-
 	early_cpu_init();
 	early_ioremap_init();
 
@@ -733,6 +732,10 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	dmi_scan_machine();
+
+	dmi_check_system(bad_bios_dmi_table);
+
 #ifdef CONFIG_X86_32
 	probe_roms();
 #endif
@@ -815,8 +818,6 @@ void __init setup_arch(char **cmdline_p)
 	vsmp_init();
 #endif
 
-	dmi_scan_machine();
-
 	io_delay_init();
 
 	/*

-- 
