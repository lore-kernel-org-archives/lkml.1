Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZAOJQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZAOJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbZAOJPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:15:55 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:44638 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549AbZAOJPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:15:48 -0500
Date: Thu, 15 Jan 2009 10:15:44 +0100
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Milton Miller <miltonm@bga.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Joe Peterson <joe@skyrush.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4 v2] hvc_console: remove tty->low_latency
Message-ID: <20090115091544.GC895@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Milton Miller <miltonm@bga.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linuxppc-dev list <linuxppc-dev@ozlabs.org>,
	Joe Peterson <joe@skyrush.com>, lkml <linux-kernel@vger.kernel.org>
References: <hvc-console-29-3-1@bga.com> <200901131004.22609.borntraeger@de.ibm.com> <20090113113545.GB26819@cetus.boeblingen.de.ibm.com> <1998eda55e236b70f63c7fb4b956b487@bga.com> <1231880644.22571.47.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231880644.22571.47.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 08:04:04AM +1100, Benjamin Herrenschmidt wrote:
> > So the simplest is to never set it.
> 
> I already applied your previous patch. Please send an incremental fix.
Here is the incremental patch for your powerpc tree along with a summary
as patch description.

Regards,
Hendrik

--
This patch removes the tty->low_latency setting.

For irq based hvc_console backends the tty->low_latency must be set to 0,
because the tty_flip_buffer_push() function must not be called from IRQ context
(see drivers/char/tty_buffer.c).

For polled backends, the low_latency setting causes the bug trace below, because
tty_flip_buffer_push() is called within an atomic context and subsequent calls
might sleep due to mutex_lock.

BUG: sleeping function called from invalid context at /root/cvs/linux-2.6.git/kernel/mutex.c:207
in_atomic(): 1, irqs_disabled(): 0, pid: 748, name: khvcd
1 lock held by khvcd/748:
 #0:  (hvc_structs_lock){--..}, at: [<00000000002ceb50>] khvcd+0x58/0x12c
CPU: 0 Not tainted 2.6.29-rc1git #29
Process khvcd (pid: 748, task: 000000002fb9a480, ksp: 000000002f66bd78)
070000000000000a 000000002f66ba00 0000000000000002 (null) 
       000000002f66baa0 000000002f66ba18 000000002f66ba18 0000000000104f08 
       ffffffffffffc000 000000002f66bd78 (null) (null) 
       000000002f66ba00 000000000000000c 000000002f66ba00 000000002f66ba70 
       0000000000466af8 0000000000104f08 000000002f66ba00 000000002f66ba50 
Call Trace:
([<0000000000104e7c>] show_trace+0x138/0x158)
 [<0000000000104f62>] show_stack+0xc6/0xf8
 [<0000000000105740>] dump_stack+0xb0/0xc0
 [<000000000013144a>] __might_sleep+0x14e/0x17c
 [<000000000045e226>] mutex_lock_nested+0x42/0x3b4
 [<00000000002c443e>] echo_char_raw+0x3a/0x9c
 [<00000000002c688c>] n_tty_receive_buf+0x1154/0x1208
 [<00000000002ca0a2>] flush_to_ldisc+0x152/0x220
 [<00000000002ca1da>] tty_flip_buffer_push+0x6a/0x90
 [<00000000002cea74>] hvc_poll+0x244/0x2c8
 [<00000000002ceb68>] khvcd+0x70/0x12c
 [<000000000015bbd0>] kthread+0x68/0xa0
 [<0000000000109d5a>] kernel_thread_starter+0x6/0xc
 [<0000000000109d54>] kernel_thread_starter+0x0/0xc
1 lock held by khvcd/748:
 #0:  (hvc_structs_lock){--..}, at: [<00000000002ceb50>] khvcd+0x58/0x12c

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/hvc_console.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -318,8 +318,6 @@ static int hvc_open(struct tty_struct *t
 	} /* else count == 0 */
 
 	tty->driver_data = hp;
-	if (!hp->irq_requested)
-		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
 
 	hp->tty = tty;
 
