Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbXGXXx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbXGXXx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbXGXXxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:53:17 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:34601 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbXGXXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:53:16 -0400
Date: Tue, 24 Jul 2007 16:57:32 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: Regression in serial console on ia64 after 2.6.22
In-reply-to: <46A0191E.3000100@sun.com>
To: Yinghai.Lu@Sun.COM, Horms <horms@verge.net.au>
Cc: linux-ia64 <linux-ia64@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
       Andi Kleen <ak@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Russell King <rmk@arm.linux.org.uk>, Gerd Hoffmann <kraxel@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <200707241657.33095.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
Fcc: imap://yinghai.lu@mail-sfbay.sun.com/Sent
X-Identity-Key: id2
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; uuencode=0
X-Length: 1496
References: <20070719074147.GA23879@verge.net.au> <46A0191E.3000100@sun.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


IA64

Subject         : Regression in serial console on ia64 after 2.6.22
References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
Last known good : ?
Submitter       : Horms <horms@verge.net.au>
Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
                  commit 18a8bd949d6adb311ea816125ff65050df1f3f6e
Handled-By      : ?
Status          : unknown


please test this patch.

YH


[PATCH] ia64: move machvec_init before parse_early_param

So ia64_mv is initialized before early console

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index 13df337..a94feaa 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -14,12 +14,6 @@ struct ia64_machine_vector ia64_mv;
 EXPORT_SYMBOL(ia64_mv);
 
 static __initdata const char *mvec_name;
-static __init int setup_mvec(char *s)
-{
-	mvec_name = s;
-	return 0;
-}
-early_param("machvec", setup_mvec);
 
 static struct ia64_machine_vector * __init
 lookup_machvec (const char *name)
@@ -42,6 +36,10 @@ machvec_init (const char *name)
 
 	if (!name)
 		name = mvec_name ? mvec_name : acpi_get_sysname();
+
+	if (!mvec_name)
+		mvec_name = name;
+
 	mv = lookup_machvec(name);
 	if (!mv)
 		panic("generic kernel failed to find machine vector for"
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index cf06fe7..b06d7b7 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -481,6 +481,9 @@ int __init reserve_elfcorehdr(unsigned long *start, unsigned long *end)
 void __init
 setup_arch (char **cmdline_p)
 {
+#ifdef CONFIG_IA64_GENERIC
+	char *mvstr;
+#endif
 	unw_init();
 
 	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
@@ -491,12 +494,15 @@ setup_arch (char **cmdline_p)
 	efi_init();
 	io_port_init();
 
-	parse_early_param();
-
 #ifdef CONFIG_IA64_GENERIC
-	machvec_init(NULL);
+	mvstr = strstr(*cmd_line_p, "machvec=")
+	if (mvstr)
+		mvstr = strchr(mvstr, '=') + 1;
+	machvec_init(mvstr);
 #endif
 
+	parse_early_param();
+
 	if (early_console_setup(*cmdline_p) == 0)
 		mark_bsp_online();
 


