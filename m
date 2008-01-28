Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbYA1VMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbYA1VMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYA1VMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:12:05 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:40209 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYA1VMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:12:01 -0500
Message-ID: <479E4531.9050600@keyaccess.nl>
Date: Mon, 28 Jan 2008 22:12:17 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] Allocate pnp resources dynamically via	krealloc	-	working
 version - Addon patch 3
References: <1200772810.3708.42.camel@queen>	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>	 <1201536284.20940.424.camel@queen.suse.de>  <479E19C9.7020201@keyaccess.nl> <1201547548.20940.435.camel@queen.suse.de>
In-Reply-To: <1201547548.20940.435.camel@queen.suse.de>
Content-Type: multipart/mixed;
 boundary="------------050800080304050106080209"
X-Spam-Score: 1.6 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050800080304050106080209
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 28-01-08 20:12, Thomas Renninger wrote:

> This was more a step backward, hopefully this one (on top), gets the
> area bugfree?

I'm afraid not. Next oops in pnp_check_port(). The attached lets it get past 
that point but _then_ things fall apart a little bit further on again which 
seems to mean it's something a bit more fundamental. Should pnp_check_* even 
be called without any initialised resources?

Without the attached:

===
pnp: the driver 'cs4236_isapnp' has been registered
cs4236_isapnp 01:01.00: driver attached
cs4236_isapnp 01:01.02: driver attached
cs4236_isapnp 01:01.03: driver attached
BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000000c
printing eip: c10e4365 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
snd soundcore s
nd_page_alloc nfsd lockd nfs_acl sunrpc exportfs

Pid: 1350, comm: modprobe Not tainted (2.6.24-local #6)
EIP: 0060:[<c10e4365>] EFLAGS: 00010246 CPU: 0
EIP is at pnp_check_port+0x15/0x125
EAX: ef8f5800 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: ef8f5800 EDI: 00000000 EBP: ef8f5800 ESP: e447edec
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1350, ti=e447e000 task=ed35f4c0 task.ti=e447e000)
Stack: 00000000 e447d900 c108ab97 ef8fe100 ef8f5800 00000000 ef82ae40 c10e5295
        00000534 00000537 00000000 40000101 efa4e360 c108b88b e4462180 ef8fe100
        00000000 ef8f5800 c10e5426 00000001 ef8f5964 00000000 00000000 00000000
Call Trace:
  [<c108ab97>] sysfs_find_dirent+0x13/0x23
  [<c10e5295>] pnp_assign_port+0xe5/0x104
  [<c108b88b>] sysfs_create_link+0xd0/0x111
  [<c10e5426>] pnp_assign_resources+0x172/0x23a
  [<c10e5555>] pnp_auto_config_dev+0x67/0xa6
  [<c10e373a>] pnp_request_card_device+0x9b/0xbe
  [<c10e55a7>] pnp_activate_dev+0x13/0x3c
  [<f0a4b559>] snd_cs423x_pnpc_detect+0xe4/0x35f [snd_cs4236]
  [<c10e330d>] pnp_alloc+0xe/0x25
  [<c10e3652>] card_probe+0xba/0x107
  [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
  [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
  [<c103258a>] sys_init_module+0x1379/0x149b
  [<c104773a>] unmap_region+0xe5/0x100
  [<c1003d62>] syscall_call+0x7/0xb
  =======================
Code: ac 29 c1 75 a7 b8 01 00 00 00 eb 02 31 c0 83 c4 0c 5b 5e 5f 5d c3 55 
89 c5 57 56 53 6b da 1c 83 ec 0c 89 14 24 03 98 64 01 00 00 <f7> 43 0c 00 00 
00 30 0
f 85 f2 00 00 00 83 b8 54 01 00 00 00 75
EIP: [<c10e4365>] pnp_check_port+0x15/0x125 SS:ESP 0068:e447edec
---[ end trace 149e6ce75dd3870f ]---
===

With the attached:

===
pnp: the driver 'cs4236_isapnp' has been registered
cs4236_isapnp 01:01.00: driver attached
cs4236_isapnp 01:01.02: driver attached
cs4236_isapnp 01:01.03: driver attached
pnp: Port allocate: ed366400 - ed369500; Allocated: 448 bytes, size 
ofstruct: 28 - allocated ports: 8
pnp: Dma allocate: ed276a80 - ed2776c0; Allocated: 112 bytes, size ofstruct: 
28 - allocated dmas: 2
cs4236_isapnp 01:01.00: activated
BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000000
printing eip: f0a4b5a8 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
snd soundcore snd_page_alloc nfsd lockd nfs_acl sunrpc exportfs

Pid: 1348, comm: modprobe Not tainted (2.6.24-local #9)
EIP: 0060:[<f0a4b5a8>] EFLAGS: 00010202 CPU: 0
EIP is at snd_cs423x_pnpc_detect+0x133/0x35f [snd_cs4236]
EAX: 00000000 EBX: ef8f5800 ECX: 00000220 EDX: 00000001
ESI: 00000000 EDI: 00000534 EBP: ed338200 ESP: ed3cfe90
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1348, ti=ed3cf000 task=ed2c79f0 task.ti=ed3cf000)
Stack: 00000286 00000001 f0a4d780 c10e330d c12b7c6c ef8f5e00 ed26fe80 ed3383bc
        ef8f5e00 ed26fe80 f0a4e0a4 00000003 c10e3652 f0a4d740 ef8f5600 f0a4d740
        efa4f514 f0a8aa4c 00000000 c10e3b75 00000001 f0a4e440 f08de02f ed338fc4
Call Trace:
  [<c10e330d>] pnp_alloc+0xe/0x25
  [<c10e3652>] card_probe+0xba/0x107
  [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
  [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
  [<c103258a>] sys_init_module+0x1379/0x149b
  [<c104773a>] unmap_region+0xe5/0x100
  [<c1003d62>] syscall_call+0x7/0xb
  =======================
Code: d6 a4 f0 7e 10 8b 83 64 01 00 00 8b 40 1c 89 04 b5 60 d6 a4 f0 8b 83 
64 01 00 00 8b 48 38 89 0c b5 40 d6 a4 f0 8b 83 7c 01 00 00 <8b> 00 89 04 b5 
20 d6 a4 f0 8b 83 74 01 00 00 8b 00 89 04 b5 e0
EIP: [<f0a4b5a8>] snd_cs423x_pnpc_detect+0x133/0x35f [snd_cs4236] SS:ESP 
0068:ed3cfe90
---[ end trace 9f2b1188efb740f7 ]---
===

For reference:

# cat /sys/bus/pnp/devices/01\:01.00/options
Dependent: 01 - Priority preferred
    port 0x534-0x534, align 0x3, size 0x4, 16-bit address decoding
    port 0x388-0x388, align 0x7, size 0x4, 16-bit address decoding
    port 0x220-0x220, align 0x1f, size 0x10, 16-bit address decoding
    irq 5 High-Edge
    dma 1 8-bit master byte-count type-F
    dma 0 8-bit master byte-count type-F

Rene.


--------------050800080304050106080209
Content-Type: text/plain;
 name="foo.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="foo.diff"

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index f1fdd96..21719e5 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -219,13 +219,14 @@ int pnp_check_port(struct pnp_dev *dev, int idx)
 	struct pnp_dev *tdev;
 	resource_size_t *port, *end, *tport, *tend;
 
-	port = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.port_resource[idx].flags))
+	if (!pnp_port_ok(dev, idx) ||
+	    cannot_compare(dev->res.port_resource[idx].flags))
 		return 1;
 
+	port = &dev->res.port_resource[idx].start;
+	end = &dev->res.port_resource[idx].end;
+
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
@@ -277,13 +278,14 @@ int pnp_check_mem(struct pnp_dev *dev, int idx)
 	struct pnp_dev *tdev;
 	resource_size_t *addr, *end, *taddr, *tend;
 
-	addr = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
-
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.mem_resource[idx].flags))
+	if (!pnp_mem_ok(dev, idx) ||
+	    cannot_compare(dev->res.mem_resource[idx].flags))
 		return 1;
 
+	addr = &dev->res.mem_resource[idx].start;
+	end = &dev->res.mem_resource[idx].end;
+
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
@@ -338,12 +340,15 @@ int pnp_check_irq(struct pnp_dev *dev, int idx)
 {
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t *irq = &dev->res.irq_resource[idx].start;
+	resource_size_t *irq;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.irq_resource[idx].flags))
+	if (!pnp_irq_ok(dev, idx) ||
+	    cannot_compare(dev->res.irq_resource[idx].flags))
 		return 1;
 
+	irq = &dev->res.irq_resource[idx].start;
+
 	/* check if the resource is valid */
 	if (*irq < 0 || *irq > 15)
 		return 0;
@@ -407,12 +412,15 @@ int pnp_check_dma(struct pnp_dev *dev, int idx)
 #ifndef CONFIG_IA64
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t *dma = &dev->res.dma_resource[idx].start;
+	resource_size_t *dma;
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.dma_resource[idx].flags))
+	if (!pnp_dma_ok(dev, idx) ||
+	    cannot_compare(dev->res.dma_resource[idx].flags))
 		return 1;
 
+	dma = &dev->res.dma_resource[idx].start;
+
 	/* check if the resource is valid */
 	if (*dma < 0 || *dma == 4 || *dma > 7)
 		return 0;

--------------050800080304050106080209--
