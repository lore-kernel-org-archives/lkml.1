Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYLCCbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYLCCbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYLCCaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:30:52 -0500
Received: from ozlabs.org ([203.10.76.45]:34879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbYLCCav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:30:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Date: Wed, 3 Dec 2008 13:00:44 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
References: <200812012326.03151.rusty@rustcorp.com.au> <200812021243.38862.rusty@rustcorp.com.au> <20081202102330.7c3215a8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081202102330.7c3215a8@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031300.46276.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008 19:53:30 Haavard Skinnemoen wrote:
> I think avr32 might need something similar as it also gets the command
> line from a tag list. But we never really do anything tricky with those
> tags, so I think it should work to simply move the call to parse_tags()
> from setup_arch() into arch_get_boot_command_line().

Good point, here's my new avr32 part (untested):

diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -39,8 +39,6 @@ struct avr32_cpuinfo boot_cpu_data = {
 	.loops_per_jiffy = 5000000
 };
 EXPORT_SYMBOL(boot_cpu_data);
-
-static char __initdata command_line[COMMAND_LINE_SIZE];
 
 /*
  * Standard memory resources
@@ -536,7 +534,12 @@ static void __init setup_bootmem(void)
 	}
 }
 
-void __init setup_arch (char **cmdline_p)
+void __init arch_get_boot_command_line(void)
+{
+	parse_tags(bootloader_tags);
+}
+
+void __init setup_arch(void)
 {
 	struct clk *cpu_clk;
 
@@ -553,8 +556,6 @@ void __init setup_arch (char **cmdline_p
 	kernel_code.end = __pa(init_mm.end_code - 1);
 	kernel_data.start = __pa(init_mm.end_code);
 	kernel_data.end = __pa(init_mm.brk - 1);
-
-	parse_tags(bootloader_tags);
 
 	setup_processor();
 	setup_platform();
@@ -579,8 +580,6 @@ void __init setup_arch (char **cmdline_p
 		       ((cpu_hz + 500) / 1000) % 1000);
 	}
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
 	parse_early_param();
 
 	setup_bootmem();

