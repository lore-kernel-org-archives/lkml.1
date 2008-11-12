Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYKLA1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYKLA1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYKLA0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:03 -0500
Received: from kroah.org ([198.145.64.141]:42047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752312AbYKLA0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:00 -0500
Date: Tue, 11 Nov 2008 16:22:55 -0800
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
Subject: [patch 02/49] x86: add DMI quirk for AMI BIOS which corrupts
	address 0xc000 during resume
Message-ID: <20081112002255.GC10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-add-dmi-quirk-for-ami-bios-which-corrupts-address-0xc000-during-resume.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

commit 5649b7c30316a51792808422ac03ee825d26aa5e upstream

Alan Jenkins and Andy Wettstein reported a suspend/resume memory
corruption bug and extensively documented it here:

   http://bugzilla.kernel.org/show_bug.cgi?id=11237

The bug is that the BIOS overwrites 1K of memory at 0xc000 physical,
without registering it in e820 as reserved or giving the kernel any
idea about this.

Detect AMI BIOSen and reserve that 1K.

We paint this bug around with a very broad brush (reserving that 1K on all
AMI BIOS systems), as the bug was extremely hard to find and needed several
weeks and lots of debugging and patching.

The bug was found via the CONFIG_X86_CHECK_BIOS_CORRUPTION=y debug feature,
if similar bugs are suspected then this feature can be enabled on other
systems as well to scan low memory for corrupted memory.

Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Reported-by: Andy Wettstein <ajw1980@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -578,6 +578,29 @@ static struct x86_quirks default_x86_qui
 
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
+static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE
+		"%s detected: BIOS corrupts 0xc000, working it around.\n",
+		d->ident);
+
+	reserve_early(0xc000, 0xc400, "BIOS quirk");
+
+	return 0;
+}
+
+/* List of systems that have known low memory corruption BIOS problems */
+static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
+		},
+	},
+	{}
+};
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -601,6 +624,8 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	dmi_check_system(bad_bios_dmi_table);
+
 	early_cpu_init();
 	early_ioremap_init();
 
@@ -885,3 +910,5 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 }
+
+

-- 
