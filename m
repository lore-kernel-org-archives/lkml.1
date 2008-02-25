Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYBYT7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYBYT7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbYBYT7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:59:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:46479 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753584AbYBYT73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:59:29 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18+au0KYL4+4r5cLnrfubCEE0jlJ02SGQEOOiCmpt
	qtGQVdObJzBGHq
Date: Mon, 25 Feb 2008 20:59:24 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Message-ID: <20080225195924.GA23176@atjola.homenet>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.02.07 00:58:42 +0100, Thomas Gleixner wrote:
> current mainline triggers:
> 
> WARNING: at /home/tglx/work/kernel/x86/linux-2.6/arch/x86/mm/highmem_32.c:52 kmap_atomic_prot+0xe5/0x19b()
> Modules linked in: ahci(+) sata_sil libata sd_mod scsi_mod raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd
> Pid: 0, comm: swapper Not tainted 2.6.24 #173
>  [<c0126b60>] warn_on_slowpath+0x41/0x51
>  [<c011c5eb>] ? __enqueue_entity+0x9c/0xa4
>  [<c011c717>] ? enqueue_entity+0x124/0x13b
>  [<c011cedb>] ? enqueue_task_fair+0x41/0x4c
>  [<c032ce88>] ? _spin_lock_irqsave+0x14/0x2e
>  [<c012e885>] ? lock_timer_base+0x1f/0x3e
>  [<c011ad6d>] kmap_atomic_prot+0xe5/0x19b
>  [<c011ae37>] kmap_atomic+0x14/0x16
>  [<f88ea218>] ata_scsi_rbuf_get+0x1e/0x2c [libata]
>  [<f88ea821>] atapi_qc_complete+0x23f/0x289 [libata]
>  [<f88e3d00>] __ata_qc_complete+0x8e/0x93 [libata]
>  [<f88e3fc7>] ata_qc_complete+0x115/0x128 [libata]
>  [<f88e8d47>] ata_qc_complete_multiple+0x86/0xa0 [libata]
>  [<f8841a5d>] ahci_interrupt+0x370/0x40d [ahci]
>  [<c01512c6>] handle_IRQ_event+0x21/0x48
>  [<c01521ca>] handle_edge_irq+0xc9/0x10a
>  [<c0152101>] ? handle_edge_irq+0x0/0x10a
>  [<c0107518>] do_IRQ+0x8b/0xb7
>  [<c01055db>] common_interrupt+0x23/0x28
>  [<c032007b>] ? init_chipset_cmd64x+0xb/0x93
>  [<c010316e>] ? mwait_idle_with_hints+0x39/0x3d
>  [<c0103172>] ? mwait_idle+0x0/0xf
>  [<c010317f>] mwait_idle+0xd/0xf
>  [<c0103761>] cpu_idle+0xb0/0xe4
>  [<c031b509>] rest_init+0x5d/0x5f
> 
> This is not a new problem. It was pointed out some time ago already,
> but now the WARN_ON() finally made it into mainline :)
> 
> The fix is not obvious, as this code seems to be called from various
> call sites.

Hm, do you have lockdep enabled? If not, does lockdep make this go away?
Because lockdep will set IRQF_DISABLED for all interrupt handlers, and
unless that flag is set, handle_IRQ_event will reenable interrupts while
the handler is running. And ahci_interrupt only uses a plain spin_lock,
so interrupts keep being enabled. The patch below should help with that.

Hmhm, maybe that also solves the deadlock you saw? Dunno...

I can't come up with an useful commit message right now, but I'll resend
in suitable form for submission if that thing actually works.

Björn


diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1db93b6..ae3dbc8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1739,6 +1739,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 	unsigned int i, handled = 0;
 	void __iomem *mmio;
 	u32 irq_stat, irq_ack = 0;
+	unsigned long flags;
 
 	VPRINTK("ENTER\n");
 
@@ -1751,7 +1752,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 	if (!irq_stat)
 		return IRQ_NONE;
 
-	spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap;
@@ -1778,7 +1779,7 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 		handled = 1;
 	}
 
-	spin_unlock(&host->lock);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	VPRINTK("EXIT\n");
 
