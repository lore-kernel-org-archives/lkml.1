Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYBTA7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYBTA7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYBTA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:59:26 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38026 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbYBTA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:59:25 -0500
Date: Wed, 20 Feb 2008 02:58:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: flatif@neteffect.com, gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: infiniband/hw/nes/nes_cm.c: use-after-free
Message-ID: <20080220005848.GA31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by the Coverity checker.

<--  snip  -->

...
static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
                struct nes_cm_listener *listener, int free_hanging_nodes)
{
        int ret = 1;
        unsigned long flags;
        spin_lock_irqsave(&cm_core->listen_list_lock, flags);
        if (!atomic_dec_return(&listener->ref_count)) {
                list_del(&listener->list);

                /* decrement our listen node count */
                atomic_dec(&cm_core->listen_node_cnt);

                spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);

                if (listener->nesvnic) {
                        nes_manage_apbvt(listener->nesvnic, listener->loc_port,
                                        PCI_FUNC(listener->nesvnic->nesdev->pcidev->devfn), NES_MANAGE_APBVT_DEL);
                }

                nes_debug(NES_DBG_CM, "destroying listener (%p)\n", listener);

                kfree(listener);     <----------------------------------
                ret = 0;
                cm_listens_destroyed++;
        } else {
                spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
        }
        if (listener) {
                if (atomic_read(&listener->pend_accepts_cnt) > 0)
...                              ^^^^^^^^^^^^^^^^^^^^^^^^^^

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

