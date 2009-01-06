Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZAFJwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZAFJwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZAFJwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:52:06 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:57265 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751566AbZAFJwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:52:00 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: 2.6.28: warn_slowpath in orinoco receive path
Date: Tue, 6 Jan 2009 12:51:39 +0300
User-Agent: KMail/1.10.92 (Linux/2.6.28-1avb; KDE/4.1.85; i686; ; )
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200901052005.12428.arvidjaar@mail.ru> <49626E4D.3010705@gmail.com>
In-Reply-To: <49626E4D.3010705@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tmyYJ93IgGZkXNg"
Message-Id: <200901061251.41628.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tmyYJ93IgGZkXNg
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=9F=D0=BE=D0=BD=D0=B5=D0=B4=D0=B5=D0=BB=D1=8C=D0=BD=D0=B8=D0=BA 05 =
=D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 23:32:13 Dave wrote:

> Looks like the RX interrupt occurred at an inconvenient point during
> the list_del call in the RX tasklet (orinoco_rx_isr_tasklet).
>
> The call needs to be protected from the RX interrupt.
>
> Quick patch included below - I'm not sure that the local_irq_*
> functions are the ones we need, but it compiles and runs.
>

As was already pointed out, we can't be sure tasklet runs on the same=20
CPU as interrupt handler. What about attached patch? It actually moves=20
list to temporary head which can be processed without races; the idea is=20
to minimize amount and number of times we need to disable interrupts.=20
Patch compiles and runs :)

> I don't suppose you're able to reproduce the error?
>

Right.

By the way. Agere driver takes different approach. The only thing it=20
does in interrupt handler directly is to turn off Hermes interrupts and=20
start off another thread to process pending events. After all events are=20
processed interrupts are enabled again. It means the bulk of code is=20
executed in non-interrupt context; and looking how much is done in=20
orinoco driver during interrupt processing, this does not sound like bad=20
idea. Do you see any obvious cons here?

--Boundary-00=_tmyYJ93IgGZkXNg
Content-Type: message/rfc822;
  name="orinoco-rx_list-protect"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="orinoco-rx_list-protect"

Subject: [PATCH] orinoco: protect rx_list manipulation in orinoco_rx_isr_tasklet
From: Andrey Borzenkov <arvidjaar@mail.ru>

The list is changed both in normal and interrupt context. Protect
manipulation in non-interrupt case; this hopefully fixes this warning:

[89479.105038] WARNING: at /home/bor/src/linux-git/lib/list_debug.c:30
__list_add+0x8f/0xa0()
[89479.105058] list_add corruption. prev->next should be next (dddb3568),
but was cbc28978. (prev=dddb3568).
[89479.106002] Pid: 15746, comm: X Not tainted 2.6.28-1avb #26
[89479.106020] Call Trace:
[89479.106062]  [<c011d3b0>] warn_slowpath+0x60/0x80
[89479.106104]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.106194]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.106218]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
[89479.106254]  [<c02f9c9d>] ? _spin_unlock+0x1d/0x20
[89479.106270]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
[89479.106302]  [<c01ff2a7>] ? delay_tsc+0x17/0x24
[89479.106319]  [<c01ff221>] ? __const_udelay+0x21/0x30
[89479.106376]  [<dfa8b1e2>] ? hermes_bap_seek+0x112/0x1e0 [hermes]
[89479.106396]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
[89479.106418]  [<c018e307>] ? __kmalloc_track_caller+0xb7/0x110
[89479.106448]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
[89479.106465]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
[89479.106482]  [<c020e13f>] __list_add+0x8f/0xa0
[89479.106551]  [<dfd0fcae>] orinoco_interrupt+0xcae/0x16c0 [orinoco]
[89479.106574]  [<c013b0e3>] ? tick_dev_program_event+0x33/0xb0
[89479.106594]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.106613]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.106662]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
[89479.106892]  [<dfe7faa7>] ? usb_hcd_irq+0x97/0xa0 [usbcore]
[89479.106926]  [<c015ba79>] handle_IRQ_event+0x29/0x60
[89479.106947]  [<c015cf89>] handle_level_irq+0x69/0xe0
[89479.106963]  [<c015cf20>] ? handle_level_irq+0x0/0xe0
[89479.106977]  <IRQ>  [<c02ca933>] ? tcp_v4_rcv+0x633/0x6e0
[89479.107025]  [<c0103f0c>] ? common_interrupt+0x28/0x30
[89479.107057]  [<c02a0000>] ? sk_run_filter+0x320/0x7a0
[89479.107078]  [<c020e041>] ? list_del+0x21/0x90
[89479.107106]  [<dfd0d24e>] ? orinoco_rx_isr_tasklet+0x2ce/0x480 [orinoco]
[89479.107131]  [<c01402e0>] ? __lock_acquire+0x160/0x1650
[89479.107151]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.107169]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.107200]  [<c012249a>] ? irq_enter+0xa/0x60
[89479.107217]  [<c0104e52>] ? do_IRQ+0xd2/0x130
[89479.107518]  [<c010342c>] ? restore_nocheck_notrace+0x0/0xe
[89479.107542]  [<c0122830>] ? __do_softirq+0x0/0x110
[89479.107561]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
[89479.107583]  [<c01ff678>] ? trace_hardirqs_on_thunk+0xc/0x10
[89479.107602]  [<c0122087>] ? tasklet_action+0x27/0x90
[89479.107620]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
[89479.107638]  [<c01220a3>] ? tasklet_action+0x43/0x90
[89479.107655]  [<c012289f>] ? __do_softirq+0x6f/0x110
[89479.107674]  [<c0122830>] ? __do_softirq+0x0/0x110
[89479.107685]  <IRQ>  [<c015cf20>] ? handle_level_irq+0x0/0xe0
[89479.107715]  [<c012246d>] ? irq_exit+0x5d/0x80
[89479.107732]  [<c0104e52>] ? do_IRQ+0xd2/0x130
[89479.107747]  [<c0103337>] ? sysenter_exit+0xf/0x16
[89479.107765]  [<c013f83d>] ? trace_hardirqs_on_caller+0xfd/0x140
[89479.107782]  [<c0103f0c>] ? common_interrupt+0x28/0x30
[89479.107797] ---[ end trace a1fc0a52df4a729d ]---

Patch based on suggestion of Dave but using spinlock instead of
local_irq_*.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

---

 drivers/net/wireless/orinoco.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 1d7e14b..09fc080 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1568,9 +1568,15 @@ static void orinoco_rx_isr_tasklet(unsigned long data)
 	struct orinoco_rx_data *rx_data, *temp;
 	struct hermes_rx_descriptor *desc;
 	struct sk_buff *skb;
+	struct list_head temp_rx_list;
+
+	/* Move list to temporary head to avoid races with interrupt handler */
+	spin_lock_irq(&priv->lock);
+	list_replace_init(&priv->rx_list, &temp_rx_list);
+	spin_unlock_irq(&priv->lock);
 
 	/* extract desc and skb from queue */
-	list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
+	list_for_each_entry_safe(rx_data, temp, &temp_rx_list, list) {
 		desc = rx_data->desc;
 		skb = rx_data->skb;
 		list_del(&rx_data->list);

--Boundary-00=_tmyYJ93IgGZkXNg--
