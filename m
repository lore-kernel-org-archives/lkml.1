Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYDARvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYDARvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 13:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYDARux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 13:50:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10145 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbYDARux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 13:50:53 -0400
Date: Tue, 1 Apr 2008 10:49:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, ebiederm@xmission.com
Cc: mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH linux-next] x86_32: fix VisualWS and Voyager kexec build
 failures
Message-Id: <20080401104950.83b02073.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

cc: Eric Biederman <ebiederm@xmission.com>

Both Visual WS and Voyager builds fail in almost the same way (in
linux-next) without this patch:

VOYAGER:
kernel/built-in.o: In function `crash_kexec':
(.text+0x28588): undefined reference to `machine_crash_shutdown'

VISWS:
kernel/built-in.o: In function `crash_kexec':
/next-20080401/kernel/kexec.c:1074: undefined reference to `machine_crash_shutdown'
make[1]: *** [.tmp_vmlinux1] Error 1

because arch/x86/kernel/reboot.c isn't built since CONFIG_X86_BIOS_REBOOT=n,
so machine_crash_shutdown() isn't available.

This patch does seem a small bit odd since the KEXEC help text says that
kexec is independent of the system firmware.

Eric, is there some other way that this should be handled?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- next-20080401.orig/arch/x86/Kconfig
+++ next-20080401/arch/x86/Kconfig
@@ -1094,6 +1094,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
+	depends on X86_64 || X86_BIOS_REBOOT
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
