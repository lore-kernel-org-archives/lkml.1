Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYEXIUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYEXIUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 04:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYEXIUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 04:20:31 -0400
Received: from gw.goop.org ([64.81.55.164]:60024 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYEXIU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 04:20:29 -0400
Message-ID: <4837CFAF.1010605@goop.org>
Date: Sat, 24 May 2008 09:19:59 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Markus Armbruster <armbru@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH] xen: make earlyprintk=xen work again
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some perverse reason, if you call add_preferred_console() it prevents
setup_early_printk() from successfully enabling the boot console -
unless you make it a preferred console too...

Also, make xenboot console output distinct from normal console output,
since it gets repeated when the console handover happens, and the
duplicated output is confusing without disambiguation.

[ Applies to end of xen pvfb series ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/xen/enlighten.c |    1 +
 drivers/char/hvc_xen.c   |    1 +
 2 files changed, 2 insertions(+)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1270,6 +1270,7 @@ asmlinkage void __init xen_start_kernel(
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
 	if (!is_initial_xendomain()) {
+		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
 	}
===================================================================
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -172,6 +172,7 @@ static void xenboot_write_console(struct
 
 	raw_console_write(string, len);
 
+	write_console(0, "(early) ", 8);
 	while (off < len && NULL != (pos = strchr(string+off, '\n'))) {
 		linelen = pos-string+off;
 		if (off + linelen > len)


