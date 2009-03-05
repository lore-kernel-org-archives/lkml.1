Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZCEKBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZCEKBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZCEKBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:01:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:58669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZCEKBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:01:42 -0500
Date: Thu, 5 Mar 2009 10:00:31 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, yinghai@kernel.org, randy.dunlap@oracle.com,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stern@rowland.harvard.edu, randy.dunlap@oracle.com,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu
In-Reply-To: <49AF18B7.4050305@kernel.org>
References: <49AF18B7.4050305@kernel.org>
Subject: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
Message-ID: <tip-a1aade478862fca8710904532cbc6efed97fd05a@git.kernel.org>
Git-Commit-ID: a1aade478862fca8710904532cbc6efed97fd05a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 10:00:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1aade478862fca8710904532cbc6efed97fd05a
Gitweb:     http://git.kernel.org/tip/a1aade478862fca8710904532cbc6efed97fd05a
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Wed, 4 Mar 2009 16:11:35 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 10:57:52 +0100

x86/doc: mini-howto for using earlyprintk=dbgp

[ mingo: small edits and extensions. ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49AF18B7.4050305@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/x86/earlyprintk.txt |  101 +++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
new file mode 100644
index 0000000..607b1a0
--- /dev/null
+++ b/Documentation/x86/earlyprintk.txt
@@ -0,0 +1,101 @@
+
+Mini-HOWTO for using the earlyprintk=dbgp boot option with a
+USB2 Debug port key and a debug cable, on x86 systems.
+
+You need two computers, the 'USB debug key' special gadget and
+and two USB cables, connected like this:
+
+  [host/target] <-------> [USB debug key] <-------> [client/console]
+
+1. There are three specific hardware requirements:
+
+ a.) Host/target system needs to have USB debug port capability.
+
+ You can check this capability by looking at a 'Debug port' bit in
+ the lspci -vvv output:
+
+ # lspci -vvv
+ ...
+ 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
+         Subsystem: Lenovo ThinkPad T61
+         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
+         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
+         Latency: 0
+         Interrupt: pin D routed to IRQ 19
+         Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
+         Capabilities: [50] Power Management version 2
+                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
+                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
+         Capabilities: [58] Debug port: BAR=1 offset=00a0
+                            ^^^^^^^^^^^ <==================== [ HERE ]
+	 Kernel driver in use: ehci_hcd
+         Kernel modules: ehci-hcd
+ ...
+
+( If your system does not list a debug port capability then you probably
+  wont be able to use the USB debug key. )
+
+ b.) You also need a Netchip USB debug cable/key:
+
+        http://www.plxtech.com/products/NET2000/NET20DC/default.asp
+
+     This is a small blue plastic connector with two USB connections,
+     it draws power from its USB connections.
+
+ c.) Thirdly, you need a second client/console system with a regular USB port.
+
+2. Software requirements:
+
+ a.) On the host/target system:
+
+    You need to enable the following kernel config option:
+
+      CONFIG_EARLY_PRINTK_DBGP=y
+
+    And you need to add the boot command line: "earlyprintk=dbgp".
+    (If you are using Grub, append it to the 'kernel' line in
+     /etc/grub.conf)
+
+    NOTE: normally earlyprintk console gets turned off once the
+    regular console is alive - use "earlyprintk=dbgp,keep" to keep
+    this channel open beyond early bootup. This can be useful for
+    debugging crashes under Xorg, etc.
+
+ b.) On the client/console system:
+
+    You should enable the following kernel config option:
+
+      CONFIG_USB_SERIAL_DEBUG=y
+
+    On the next bootup with the modified kernel you should
+    get a /dev/ttyUSBx device(s).
+
+    Now this channel of kernel messages is ready to be used: start
+    your favorite terminal emulator (minicom, etc.) and set
+    it up to use /dev/ttyUSB0 - or use a raw 'cat /dev/ttyUSBx' to
+    see the raw output.
+
+ c.) On Nvidia Southbridge based systems: the kernel will try to probe
+     and find out which port has debug device connected.
+
+3. Testing that it works fine:
+
+   You can test the output by using earlyprintk=dbgp,keep and provoking
+   kernel messages on the host/target system. You can provoke a harmless
+   kernel message by for example doing:
+
+     echo h > /proc/sysrq-trigger
+
+   On the host/target system you should see this help line in "dmesg" output:
+
+     SysRq : HELP : loglevel(0-9) reBoot Crashdump terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z)
+
+   On the client/console system do:
+
+       cat /dev/ttyUSB0
+
+   And you should see the help line above displayed shortly after you've
+   provoked it on the host system.
+
+If it does not work then please ask about it on the linux-kernel@vger.kernel.org
+mailing list or contact the x86 maintainers.
