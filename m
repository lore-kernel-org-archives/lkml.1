Return-Path: <linux-kernel-owner+w=401wt.eu-S1764658AbYA2OTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764658AbYA2OTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762678AbYA2OSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:18:54 -0500
Received: from ns.suse.de ([195.135.220.2]:59828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395AbYA2OSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:18:52 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc -
	working version - Addon debug patch 4
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <479E4531.9050600@keyaccess.nl>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>
	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>
	 <1201536284.20940.424.camel@queen.suse.de> <479E19C9.7020201@keyaccess.nl>
	 <1201547548.20940.435.camel@queen.suse.de> <479E4531.9050600@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 29 Jan 2008 15:18:50 +0100
Message-Id: <1201616330.1222.24.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 22:12 +0100, Rene Herman wrote:
> On 28-01-08 20:12, Thomas Renninger wrote:
> 
> > This was more a step backward, hopefully this one (on top), gets the
> > area bugfree?
> 
> I'm afraid not. Next oops in pnp_check_port(). The attached lets it get past 
> that point but _then_ things fall apart a little bit further on again which 
> seems to mean it's something a bit more fundamental. Should pnp_check_* even 
> be called without any initialised resources?
> 
> Without the attached:
> 
> ===
> pnp: the driver 'cs4236_isapnp' has been registered
> cs4236_isapnp 01:01.00: driver attached
> cs4236_isapnp 01:01.02: driver attached
> cs4236_isapnp 01:01.03: driver attached
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 0000000c
> printing eip: c10e4365 *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
> snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
> snd soundcore s
> nd_page_alloc nfsd lockd nfs_acl sunrpc exportfs
> 
> Pid: 1350, comm: modprobe Not tainted (2.6.24-local #6)
> EIP: 0060:[<c10e4365>] EFLAGS: 00010246 CPU: 0
> EIP is at pnp_check_port+0x15/0x125
> EAX: ef8f5800 EBX: 00000000 ECX: 00000000 EDX: 00000000
> ESI: ef8f5800 EDI: 00000000 EBP: ef8f5800 ESP: e447edec
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 1350, ti=e447e000 task=ed35f4c0 task.ti=e447e000)
> Stack: 00000000 e447d900 c108ab97 ef8fe100 ef8f5800 00000000 ef82ae40 c10e5295
>         00000534 00000537 00000000 40000101 efa4e360 c108b88b e4462180 ef8fe100
>         00000000 ef8f5800 c10e5426 00000001 ef8f5964 00000000 00000000 00000000
> Call Trace:
>   [<c108ab97>] sysfs_find_dirent+0x13/0x23
>   [<c10e5295>] pnp_assign_port+0xe5/0x104
>   [<c108b88b>] sysfs_create_link+0xd0/0x111
>   [<c10e5426>] pnp_assign_resources+0x172/0x23a
>   [<c10e5555>] pnp_auto_config_dev+0x67/0xa6
>   [<c10e373a>] pnp_request_card_device+0x9b/0xbe
>   [<c10e55a7>] pnp_activate_dev+0x13/0x3c
>   [<f0a4b559>] snd_cs423x_pnpc_detect+0xe4/0x35f [snd_cs4236]
>   [<c10e330d>] pnp_alloc+0xe/0x25
>   [<c10e3652>] card_probe+0xba/0x107
>   [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
>   [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
>   [<c103258a>] sys_init_module+0x1379/0x149b
>   [<c104773a>] unmap_region+0xe5/0x100
>   [<c1003d62>] syscall_call+0x7/0xb
>   =======================
> Code: ac 29 c1 75 a7 b8 01 00 00 00 eb 02 31 c0 83 c4 0c 5b 5e 5f 5d c3 55 
> 89 c5 57 56 53 6b da 1c 83 ec 0c 89 14 24 03 98 64 01 00 00 <f7> 43 0c 00 00 
> 00 30 0
> f 85 f2 00 00 00 83 b8 54 01 00 00 00 75
> EIP: [<c10e4365>] pnp_check_port+0x15/0x125 SS:ESP 0068:e447edec
> ---[ end trace 149e6ce75dd3870f ]---
> ===
> 
> With the attached:
> 
> ===
> pnp: the driver 'cs4236_isapnp' has been registered
> cs4236_isapnp 01:01.00: driver attached
> cs4236_isapnp 01:01.02: driver attached
> cs4236_isapnp 01:01.03: driver attached
> pnp: Port allocate: ed366400 - ed369500; Allocated: 448 bytes, size 
> ofstruct: 28 - allocated ports: 8
> pnp: Dma allocate: ed276a80 - ed2776c0; Allocated: 112 bytes, size ofstruct: 
> 28 - allocated dmas: 2
> cs4236_isapnp 01:01.00: activated
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000000
> printing eip: f0a4b5a8 *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
> snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
> snd soundcore snd_page_alloc nfsd lockd nfs_acl sunrpc exportfs
> 
> Pid: 1348, comm: modprobe Not tainted (2.6.24-local #9)
> EIP: 0060:[<f0a4b5a8>] EFLAGS: 00010202 CPU: 0
> EIP is at snd_cs423x_pnpc_detect+0x133/0x35f [snd_cs4236]
> EAX: 00000000 EBX: ef8f5800 ECX: 00000220 EDX: 00000001
> ESI: 00000000 EDI: 00000534 EBP: ed338200 ESP: ed3cfe90
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 1348, ti=ed3cf000 task=ed2c79f0 task.ti=ed3cf000)
> Stack: 00000286 00000001 f0a4d780 c10e330d c12b7c6c ef8f5e00 ed26fe80 ed3383bc
>         ef8f5e00 ed26fe80 f0a4e0a4 00000003 c10e3652 f0a4d740 ef8f5600 f0a4d740
>         efa4f514 f0a8aa4c 00000000 c10e3b75 00000001 f0a4e440 f08de02f ed338fc4
> Call Trace:
>   [<c10e330d>] pnp_alloc+0xe/0x25
>   [<c10e3652>] card_probe+0xba/0x107
>   [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
>   [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
>   [<c103258a>] sys_init_module+0x1379/0x149b
>   [<c104773a>] unmap_region+0xe5/0x100
>   [<c1003d62>] syscall_call+0x7/0xb
>   =======================
> Code: d6 a4 f0 7e 10 8b 83 64 01 00 00 8b 40 1c 89 04 b5 60 d6 a4 f0 8b 83 
> 64 01 00 00 8b 48 38 89 0c b5 40 d6 a4 f0 8b 83 7c 01 00 00 <8b> 00 89 04 b5 
> 20 d6 a4 f0 8b 83 74 01 00 00 8b 00 89 04 b5 e0
> EIP: [<f0a4b5a8>] snd_cs423x_pnpc_detect+0x133/0x35f [snd_cs4236] SS:ESP 
> 0068:ed3cfe90
> ---[ end trace 9f2b1188efb740f7 ]---
> ===
> 
> For reference:
> 
> # cat /sys/bus/pnp/devices/01\:01.00/options
> Dependent: 01 - Priority preferred
>     port 0x534-0x534, align 0x3, size 0x4, 16-bit address decoding
>     port 0x388-0x388, align 0x7, size 0x4, 16-bit address decoding
>     port 0x220-0x220, align 0x1f, size 0x10, 16-bit address decoding
>     irq 5 High-Edge
>     dma 1 8-bit master byte-count type-F
>     dma 0 8-bit master byte-count type-F

This is without these patches and same/similar kernel?
I expect that ports and dmas are found, see allocations above.
But for some reason the irq is not.
Now comes a drawback of my patch... One needs to go through all pnp
layer using drivers and make sure they invoke
pnp_{port,mem,irq,dma}_valid (or at least _ok) macros before they
actually access the resource via e.g. pnp_irq or pnp_port_start...
I wonder where the irq 5 above comes from. Maybe there is another bug or
that is what the pnp_resource_change and friends was for, maybe the
driver somehow falls back to 5 if no sane irq is set by BIOS read
values.

This patch may be a bit too much of sanity checking or maybe a similar
approach (without the pnp_warn) even is the way to go, instead of
checking all pnp using drivers?

Can you try this debug patch out, pls. Hopefully the NULL pointer
exceptions are finally gone?


Sanity check every resource access

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 include/linux/pnp.h |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

Index: linux-2.6.23/include/linux/pnp.h
===================================================================
--- linux-2.6.23.orig/include/linux/pnp.h
+++ linux-2.6.23/include/linux/pnp.h
@@ -33,10 +33,13 @@ struct pnp_dev;
 
 #define pnp_port_ok(dev,bar)	((dev)->res.allocated_ports > (bar))
 
-#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
-#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
-#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
-#define pnp_port_valid(dev,bar) \
+#define pnp_port_start(dev,bar)   (pnp_port_ok((dev),(bar)) ? (dev)->res.port_resource[(bar)].start \
+				   : pnp_warn("Port start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_port_end(dev,bar)     (pnp_port_ok((dev),(bar)) ? (dev)->res.port_resource[(bar)].end \
+				   : pnp_warn("Port end %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_port_flags(dev,bar)   (pnp_port_ok((dev),(bar)) ? (dev)->res.port_resource[(bar)].flags \
+				    : pnp_warn("Port flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_port_valid(dev,bar)	     \
 	(pnp_port_ok((dev),(bar)) && \
 	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
 		== IORESOURCE_IO))
@@ -49,9 +52,12 @@ struct pnp_dev;
 	  pnp_port_start((dev),(bar)) + 1))
 
 #define pnp_mem_ok(dev,bar)	((dev)->res.allocated_mems > (bar))
-#define pnp_mem_start(dev,bar)   ((dev)->res.mem_resource[(bar)].start)
-#define pnp_mem_end(dev,bar)     ((dev)->res.mem_resource[(bar)].end)
-#define pnp_mem_flags(dev,bar)   ((dev)->res.mem_resource[(bar)].flags)
+#define pnp_mem_start(dev,bar)   (pnp_mem_ok((dev),(bar)) ? (dev)->res.mem_resource[(bar)].start \
+				   : pnp_warn("Mem start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_mem_end(dev,bar)     (pnp_mem_ok((dev),(bar)) ? (dev)->res.mem_resource[(bar)].end \
+				   : pnp_warn("Mem end %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_mem_flags(dev,bar)   (pnp_mem_ok((dev),(bar)) ? (dev)->res.mem_resource[(bar)].flags \
+				    : pnp_warn("Mem flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
 #define pnp_mem_valid(dev,bar) \
 	(pnp_mem_ok((dev),(bar)) && \
 	((pnp_mem_flags((dev),(bar)) & (IORESOURCE_MEM | IORESOURCE_UNSET)) \
@@ -65,16 +71,20 @@ struct pnp_dev;
 	  pnp_mem_start((dev),(bar)) + 1))
 
 #define pnp_irq_ok(dev,bar)	((dev)->res.allocated_irqs > (bar))
-#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
-#define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
+#define pnp_irq(dev,bar)	 (pnp_irq_ok((dev),(bar)) ? (dev)->res.irq_resource[(bar)].start \
+				   : pnp_warn("Irq start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_irq_flags(dev,bar)	 (pnp_irq_ok((dev),(bar)) ? (dev)->res.irq_resource[(bar)].flags \
+				    : pnp_warn("Mem flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
 #define pnp_irq_valid(dev,bar) \
 	(pnp_irq_ok((dev),(bar)) && \
 	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
 		== IORESOURCE_IRQ))
 
 #define pnp_dma_ok(dev,bar)	((dev)->res.allocated_dmas > (bar))
-#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
-#define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
+#define pnp_dma(dev,bar)	 (pnp_dma_ok((dev),(bar)) ? (dev)->res.dma_resource[(bar)].start \
+				   : pnp_warn("Dma start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
+#define pnp_dma_flags(dev,bar)	 (pnp_dma_ok((dev),(bar)) ? (dev)->res.dma_resource[(bar)].flags \
+				    : pnp_warn("Mem flags %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))
 #define pnp_dma_valid(dev,bar) \
 	(pnp_dma_ok((dev),(bar)) && \
 	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \


