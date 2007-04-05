Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXDEObH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXDEObH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbXDEObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:31:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:39687 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbXDEObF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:31:05 -0400
To: <linux-kernel@vger.kernel.org>
Subject: Re: RFC: initramfs unpack point and rules
References: <m3ejmzdmow.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 05 Apr 2007 16:31:02 +0200
In-Reply-To: <m3ejmzdmow.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Thu, 05 Apr 2007 14:34:39 +0200")
Message-ID: <m3648aevvd.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder why is initramfs unpacked that early, before most drivers?
> I'd expect it much later in the boot sequence, just before userspace
> and initial devices (/dev/console etc) are needed. Should it be moved
> there? populate_rootfs() unpacks both builtin and external initramfs.

I mean something like the attached patch would change the boot order
from:

TCP reno registered
Unpacking initramfs... done
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Freeing initrd memory: 7812K
NetWinder Floating Point Emulator V0.97 (double precision)
io scheduler noop registered (default)
IXP4xx Watchdog Timer: heartbeat 60 sec
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250.0: ttyS0 at MMIO 0xc8000000 (irq = 15) is a XScale
serial8250.0: ttyS1 at MMIO 0xc8001000 (irq = 13) is a XScale
PPP generic driver version 2.4.2
...

to:

802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Unpacking initramfs... done
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Freeing initrd memory: 7812K
XScale DSP coprocessor detected.
Freeing init memory: 628K
Time: OSTS clocksource has been installed.

login:

What do you think?

In case someone wants to apply it (but something tells me it's not
that simple):
Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9fcc8d9..33e3036 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -223,9 +223,9 @@
   	*(.initcall4s.init)						\
   	*(.initcall5.init)						\
   	*(.initcall5s.init)						\
-	*(.initcallrootfs.init)						\
   	*(.initcall6.init)						\
   	*(.initcall6s.init)						\
+	*(.initcallrootfs.init)						\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
diff --git a/include/linux/init.h b/include/linux/init.h
index 5a593a1..6da2106 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -111,9 +111,9 @@ extern void setup_arch(char **);
 #define subsys_initcall_sync(fn)	__define_initcall("4s",fn,4s)
 #define fs_initcall(fn)			__define_initcall("5",fn,5)
 #define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
-#define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
 #define device_initcall(fn)		__define_initcall("6",fn,6)
 #define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
+#define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
 #define late_initcall(fn)		__define_initcall("7",fn,7)
 #define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
 
-- 
Krzysztof Halasa
