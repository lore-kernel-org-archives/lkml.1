Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZAFCHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZAFCHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZAFCHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:07:00 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:49935 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbZAFCG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:06:58 -0500
Message-Id: <200901060206.n0626o5I026322@www262.sakura.ne.jp>
Subject: Re: [regression 2.6.27.10 & 2.6.28] \"nolapic\" option causes \"nosmp\"?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 11:06:50 +0900
References: <200901050318.n053Iu0L068557@www262.sakura.ne.jp> <alpine.LFD.1.10.0901052156460.10676@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0901052156460.10676@ftp.linux-mips.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05012009 #1403796, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Maciej W. Rozycki wrote:
> This is correct behaviour.  The hardware uses the local APIC to 
> communicate between CPUs.  With the subsystem disabled there is no way to 
> reach secondary CPUs on a standard x86 system.

Oh, I didn't know that.
Then, the problem is use of "for_each_possible_cpu".

---
 drivers/net/loopback.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.28.orig/drivers/net/loopback.c
+++ linux-2.6.28/drivers/net/loopback.c
@@ -92,28 +92,35 @@ static int loopback_xmit(struct sk_buff 
 static struct net_device_stats *get_stats(struct net_device *dev)
 {
 	const struct pcpu_lstats *pcpu_lstats;
 	struct net_device_stats *stats = &dev->stats;
 	unsigned long bytes = 0;
 	unsigned long packets = 0;
 	int i;
 
+	printk(KERN_INFO "Entering get_stats()\n");
 	pcpu_lstats = dev->ml_priv;
 	for_each_possible_cpu(i) {
 		const struct pcpu_lstats *lb_stats;
+		printk(KERN_INFO "CPU=%u\n", i);
 
 		lb_stats = per_cpu_ptr(pcpu_lstats, i);
+		if (!lb_stats) {
+			printk(KERN_INFO "lb_stats == NULL for CPU %u\n", i);
+			continue;
+		}
 		bytes   += lb_stats->bytes;
 		packets += lb_stats->packets;
 	}
 	stats->rx_packets = packets;
 	stats->tx_packets = packets;
 	stats->rx_bytes = bytes;
 	stats->tx_bytes = bytes;
+	printk(KERN_INFO "Leaving get_stats()\n");
 	return stats;
 }
 
 static u32 always_on(struct net_device *dev)
 {
 	return 1;
 }
 

Applying the above patch and compiling with config at
http://I-love.SAKURA.ne.jp/tmp/config-2.6.28 and booting with "nolapic"
produces below output.

----------------------------------------
BIOS EBDA/lowmem at: 0009f800/0009f800
Linux version 2.6.28 (root@tomoyo) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #1 SMP Tue Jan 6 10:18:14 JST 2009
(..... snipped .....)
Kernel command line: ro root=LABEL=/ nolapic
(..... snipped .....)
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
system 00:01: ioport range 0xcf0-0xcf1 has been reserved
system 00:0c: ioport range 0x1060-0x107f has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0xdb400000-0xdb5fffff has been reserved
Entering get_stats()
CPU=0
Leaving get_stats()
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
(..... snipped .....)
kjournald starting.  Commit interval 5 seconds
(..... snipped .....)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda1, internal journal
Entering get_stats()
CPU=0
CPU=1
lb_stats == NULL for CPU 1
Leaving get_stats()
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
Entering get_stats()
CPU=0
CPU=1
lb_stats == NULL for CPU 1
Leaving get_stats()
----------------------------------------

When "nolapic" is given, it prints "lb_stats == NULL for CPU 1" message.
If '"nolapic" disables CPU 1' is correct behavior, the "CPU=1" message
should not be printed.

Regards.
