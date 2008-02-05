Return-Path: <linux-kernel-owner+w=401wt.eu-S1761693AbYBEWAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693AbYBEWAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbYBEWAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:00:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38893 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755780AbYBEWAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:00:35 -0500
Date: Tue, 5 Feb 2008 22:44:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: ipw3945-devel@lists.sourceforge.net, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: ipw3945: not only it periodically dies, it also BUG()s
Message-ID: <20080205214441.GA1518@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Under not-even-high load, it periodically restarts:

Feb  5 21:08:50 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Feb  5 21:08:52 amd kernel: iwl3945: Can't stop Rx DMA.
Feb  5 21:12:51 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Feb  5 21:12:53 amd kernel: iwl3945: Can't stop Rx DMA.
Feb  5 21:21:44 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Feb  5 21:21:46 amd kernel: iwl3945: Can't stop Rx DMA.
Feb  5 21:27:32 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Feb  5 21:27:34 amd kernel: iwl3945: Can't stop Rx DMA.
Feb  5 21:41:29 amd -- MARK --
Feb  5 22:01:29 amd -- MARK --
Feb  5 22:09:11 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000008.
Feb  5 22:09:12 amd kernel: iwl3945: Can't stop Rx DMA.

...I've reported this before, with full debugging. Not sure if
anything happened.

Now, I got BUG() in iwl3945-base.c: 3824

static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
                                struct iwl3945_rx_mem_buffer *rxb)
{
        struct iwl3945_rx_packet *pkt = (struct iwl3945_rx_packet
*)rxb->skb->data;
        u16 sequence = le16_to_cpu(pkt->hdr.sequence);
        int txq_id = SEQ_TO_QUEUE(sequence);
        int index = SEQ_TO_INDEX(sequence);
        int huge = sequence & SEQ_HUGE_FRAME;
        int cmd_index;
        struct iwl3945_cmd *cmd;

        /* If a Tx command is being handled and it isn't in the actual
         * command queue then there a command routing bug has been
introduced
         * in the queue management code. */
        if (txq_id != IWL_CMD_QUEUE_NUM)
                IWL_ERROR("Error wrong command queue %d command id
0x%X\n",
                          txq_id, pkt->hdr.cmd);
        BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here. Any ideas?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
