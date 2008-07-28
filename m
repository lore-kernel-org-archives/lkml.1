Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYG1TaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYG1TaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYG1TaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:30:05 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:57648 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYG1TaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:30:01 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 15:30:01 EDT
Date: Mon, 28 Jul 2008 20:56:51 +0200
From: Bastian Blank <waldi@debian.org>
To: linuxppc-dev@ozlabs.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/lpar - defer prefered console setup
Message-ID: <20080728185651.GA29530@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>, linuxppc-dev@ozlabs.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The powerpc lpar code adds a prefered console at a very early state,
during arch_setup. This runs even before the console setup from the
command line and takes preference.

This patch moves the prefered console setup into an arch_initcall which
runs later and allows the specification of the correct console on the
command line. The udbg console remains as boot console.

There is a different problem that the code does not pick up the correct
console because it uses a part (4) of the lpar device number (30000004)
instead of the correct index 1.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 9235c46..626290d 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -57,6 +57,7 @@ extern void pSeries_find_serial_port(void);
 
 
 int vtermno;	/* virtual terminal# for udbg  */
+static char *console_name;
 
 #define __ALIGNED__ __attribute__((__aligned__(sizeof(long))))
 static void udbg_hvsi_putc(char c)
@@ -232,18 +233,24 @@ void __init find_udbg_vterm(void)
 		udbg_putc = udbg_putcLP;
 		udbg_getc = udbg_getcLP;
 		udbg_getc_poll = udbg_getc_pollLP;
-		add_preferred_console("hvc", termno[0] & 0xff, NULL);
+		console_name = "hvc";
 	} else if (of_device_is_compatible(stdout_node, "hvterm-protocol")) {
-		vtermno = termno[0];
 		udbg_putc = udbg_hvsi_putc;
 		udbg_getc = udbg_hvsi_getc;
 		udbg_getc_poll = udbg_hvsi_getc_poll;
-		add_preferred_console("hvsi", termno[0] & 0xff, NULL);
+		console_name = "hvsi";
 	}
 out:
 	of_node_put(stdout_node);
 }
 
+static void __init enable_vterm(void)
+{
+	if (console_name)
+		add_preferred_console(console_name, vtermno, NULL);
+}
+arch_initcall(enable_vterm);
+
 void vpa_init(int cpu)
 {
 	int hwcpu = get_hard_smp_processor_id(cpu);

-- 
Genius doesn't work on an assembly line basis.  You can't simply say,
"Today I will be brilliant."
		-- Kirk, "The Ultimate Computer", stardate 4731.3
