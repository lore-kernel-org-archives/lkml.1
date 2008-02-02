Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbYBBQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbYBBQzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 11:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYBBQzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 11:55:24 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:45290 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYBBQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 11:55:23 -0500
Message-ID: <47A49D95.10402@cfl.rr.com>
Date: Sat, 02 Feb 2008 11:43:01 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: 2.6.24-rt1: BUG: using smp_processor_id() in preemptible
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to use an out of kernel GPL driver with the RT-PREEMPT
kernel. Even though this is probably a driver issue I though I'd post it
here in case it might be of interest or if there something I could do to
fix it.


BUG: using smp_processor_id() in preemptible

Feb  2 06:51:08 harley kernel: BUG: using smp_processor_id() in
preemptible [00000000] code: IRQ-16/533
Feb  2 06:51:08 harley kernel: caller is dxb_lock_poller+0x40/0x57 [dgdm]
Feb  2 06:51:08 harley kernel: Pid: 533, comm: IRQ-16 Not tainted
2.6.24-rt1 #1
Feb  2 06:51:08 harley kernel:  [<c01d9856>]
debug_smp_processor_id+0xa2/0xb0
Feb  2 06:51:08 harley kernel:  [<f4cad345>] dxb_lock_poller+0x40/0x57
[dgdm]
Feb  2 06:51:08 harley kernel:  [<f4ca5986>] dgdm_intr+0x4e/0x97 [dgdm]
Feb  2 06:51:08 harley kernel:  [<c014c1da>] handle_IRQ_event+0x48/0xaf
Feb  2 06:51:08 harley kernel:  [<c014c657>] thread_simple_irq+0x3f/0x74
Feb  2 06:51:08 harley kernel:  [<c014cc49>] do_irqd+0x0/0x22f
Feb  2 06:51:08 harley kernel:  [<c014ccfb>] do_irqd+0xb2/0x22f
Feb  2 06:51:08 harley kernel:  [<c014cc49>] do_irqd+0x0/0x22f
Feb  2 06:51:08 harley kernel:  [<c0132336>] kthread+0x38/0x5e
Feb  2 06:51:08 harley kernel:  [<c01322fe>] kthread+0x0/0x5e
Feb  2 06:51:08 harley kernel:  [<c0104cb7>] kernel_thread_helper+0x7/0x10
Feb  2 06:51:08 harley kernel:  =======================

The GPL driver code snipits in question:

#define DGDM_UNLOCK(x,y)       spin_unlock_irqrestore(&(x), y);
#define DGDM_LOCK(x,y)         spin_lock_irqsave(&(x), y);

Interrupt handler:
{
        BOARD_T *brd = voidbrd;

        if(!brd) {
                APR(("Received interrupt with null board associated\n"));
                DGDM_IRQ_RETURN(IRQ_NONE);
        }

        ++brd->intr_count;

        if (brd->triboard && brd->triboard->clear_board_int) {
                if(((*brd->triboard->clear_board_int) (brd->triboard)) &&
                   brd->intr_used) {
                        if(dxb_lock_poller(brd)) {
                                /* poll only receive here */
                                dgdm_tty_poll_board(brd, FALSE, TRUE);
                                dxb_unlock_poller(brd);
                        }
                }
                DGDM_IRQ_RETURN(IRQ_HANDLED);
        } else {
                APR(("Board received an interrupt but there is no way to "
                     "to clear it.\nDisabling interrupts for that
board\n"));
                free_irq(brd->irq, brd);
                DGDM_IRQ_RETURN(IRQ_NONE);
        }
}

GLOBAL int dxb_lock_poller(BOARD_T *brd)
{
        unsigned long flags;
        int rc;

        DGDM_LOCK(brd->dxb_spinlock, flags);

        if (brd->poller_locked || brd->dxb_locked) {
                brd->dxb_needpoll = 1;
                rc = 0;
        } else {
                brd->poller_locked = 1;
                brd->poll_processor = DGDM_PROCID();
                rc = 1;
        }

        DGDM_UNLOCK(brd->dxb_spinlock, flags);

        return(rc);
}

Thanks and Regards
Mark

