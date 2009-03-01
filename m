Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZCADZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZCADZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 22:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZCADZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 22:25:10 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:54810 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZCADZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 22:25:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rCRw70C2o7M77wxaOPYjXzHS0MwLmCoxOXIivULfLoScT7yAmVOtV2yAjF2OKeGkuj
         RC8jsBT0tfZRAD9837mZ6jBjSB5M0Bf27d1eOcRZKcDa+wvprKpedNsvuuy6X+spS/0e
         zf5/dVVNTeM148mUe1wYAEM9d7g+g29zJb5I8=
MIME-Version: 1.0
In-Reply-To: <49A9FCEB.9090504@redhat.com>
References: <49A9F597.4010601@redhat.com>
	 <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
	 <49A9FCEB.9090504@redhat.com>
Date: Sat, 28 Feb 2009 19:25:06 -0800
X-Google-Sender-Auth: fd7588e3a703a9ce
Message-ID: <86802c440902281925m6eb68456vc3886252619b6743@mail.gmail.com>
Subject: Re: [PATCH] fix DMI for EFI
From: Yinghai Lu <yinghai@kernel.org>
To: Brian Maly <bmaly@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please use git log -p arch/x86/kernel/setup.c to check the history...

YH


commit 2216d199b1430d1c0affb1498a9ebdbd9c0de439
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Mon Sep 22 02:52:26 2008 -0700

    x86: fix CONFIG_X86_RESERVE_LOW_64K=y

    The bad_bios_dmi_table() quirk never triggered because we do DMI setup
    too late. Move it a bit earlier.

    Also change the CONFIG_X86_RESERVE_LOW_64K quirk to operate on the e820
    table directly instead of messing with early reservations - this handles
    overlaps (which do occur in this low range of RAM) more gracefully.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 161f1b3..d29951c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -735,7 +735,8 @@ static int __init dmi_low_memory_corruption(const
struct dmi_system_id *d)
                "%s detected: BIOS may corrupt low RAM, working it around.\n",
                d->ident);

-       reserve_early_overlap_ok(0x0, 0x10000, "BIOS quirk");
+       e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
+       sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);

        return 0;
 }
@@ -784,8 +785,6 @@ void __init setup_arch(char **cmdline_p)
        printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif

-       dmi_check_system(bad_bios_dmi_table);
-
        early_cpu_init();
        early_ioremap_init();

@@ -880,6 +879,10 @@ void __init setup_arch(char **cmdline_p)

        finish_e820_parsing();

+       dmi_scan_machine();
+
+       dmi_check_system(bad_bios_dmi_table);
+
 #ifdef CONFIG_X86_32
        probe_roms();
 #endif
@@ -967,8 +970,6 @@ void __init setup_arch(char **cmdline_p)
        vsmp_init();
 #endif

-       dmi_scan_machine();
-
        io_delay_init();
