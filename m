Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYKPMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYKPMhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYKPMh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:37:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:49072 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYKPMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:37:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:sender;
        b=LXytBSlB94T3yxK7XzHZe/Q0R8iJ/Lk/hAJXYitjFhPSVifbyuv7kHtGIjED6ME0+F
         3JowcNASttQ2743/abkGjXtVulx2OLAEjbX8nSWPLfKOYRWPxqJ0cM+2mNF+/NQpavKf
         Qqh8QjZzxDJZ6pp+Gml92kYFNORIeCsyouV7Q=
Message-ID: <49201401.1060600@tuffmail.co.uk>
Date: Sun, 16 Nov 2008 12:37:21 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: csnook@redhat.com, atl1-devel@lists.sourceforge.net
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: atl2: don't mess up irq on suspend/resume (probably msi only)
Content-Type: multipart/mixed;
 boundary="------------090909090803030204020501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090909090803030204020501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

According to Documentation/power/pci.txt, the correct suspend sequence is:

    A reference implementation
    -------------------------
    .suspend()
    {
        /* driver specific operations */

        /* Disable IRQ */
        free_irq();
        /* If using MSI */
        pci_disable_msi();

        pci_save_state();
        pci_enable_wake();
        /* Disable IO/bus master/irq router */
        pci_disable_device();
        pci_set_power_state(pci_choose_state());
    }


Whereas atl2 calls pci_save_state() *before* free_irq() and
pci_disable_msi().  Hilarity ensues on resume as pci_restore_state()
restores a state with MSI enabled; the atl2 resume handler then enables
msi for the second time.  Looking at /proc/interrupts, it seems to leak
an irq each time this happens.  (I had 6 entries for "eth0" by the time
I noticed this).  It also triggers a warning.

I was able to avoid the warning + leak by re-ordering the resume
method.  Patch attached - it's just a few lines, I hope that's all
that's necessary.

------------[ cut here ]------------
WARNING: at drivers/pci/msi.c:570 pci_enable_msi+0x3a/0x1cd()
Modules linked in: cpufreq_stats freq_table nls_iso8859_1 nls_cp437 vfat fat rfkill_input ae
Pid: 2620, comm: NetworkManager Tainted: G        W  2.6.28-rc4eeepc #136
Call Trace:
 [<c011b89a>] warn_on_slowpath+0x40/0x59
 [<c023df15>] raw_pci_read+0x4d/0x55
 [<c023dff3>] pci_read+0x1c/0x21
 [<c01bcd81>] __pci_find_next_cap_ttl+0x44/0x70
 [<c01bce86>] __pci_find_next_cap+0x1a/0x1f
 [<c01bcef9>] pci_find_capability+0x28/0x2c
 [<c01c4144>] pci_msi_check_device+0x53/0x62
 [<c01c49c2>] pci_enable_msi+0x3a/0x1cd
 [<e019f17b>] atl2_write_phy_reg+0x40/0x5f [atl2]
 [<c01061b1>] dma_generic_alloc_coherent+0x0/0xd7
 [<e019f107>] atl2_request_irq+0x15/0x49 [atl2]
 [<e01a1481>] atl2_open+0x20b/0x297 [atl2]
 [<c024a35c>] dev_open+0x62/0x91
 [<c0248b9a>] dev_change_flags+0x93/0x141
 [<c024f308>] do_setlink+0x238/0x2d5
 [<c02501b2>] rtnl_setlink+0xa9/0xbf
 [<c0297f0c>] mutex_lock+0xb/0x19
 [<c024ffa7>] rtnl_dump_ifinfo+0x0/0x69
 [<c0250109>] rtnl_setlink+0x0/0xbf
 [<c024fe42>] rtnetlink_rcv_msg+0x185/0x19f
 [<c0240fd1>] sock_rmalloc+0x23/0x57
 [<c024fcbd>] rtnetlink_rcv_msg+0x0/0x19f
 [<c0259457>] netlink_rcv_skb+0x2d/0x71
 [<c024fcb7>] rtnetlink_rcv+0x14/0x1a
 [<c025929e>] netlink_unicast+0x184/0x1e4
 [<c025992a>] netlink_sendmsg+0x233/0x240
 [<c023f405>] sock_sendmsg+0xb7/0xd0
 [<c0129131>] autoremove_wake_function+0x0/0x2b
 [<c0129131>] autoremove_wake_function+0x0/0x2b
 [<c0147796>] mempool_alloc+0x2d/0x9e
 [<c020c923>] scsi_pool_alloc_command+0x35/0x4f
 [<c0297f0c>] mutex_lock+0xb/0x19
 [<c028e867>] unix_stream_recvmsg+0x357/0x3e2
 [<c01b81c9>] copy_from_user+0x23/0x4f
 [<c02452ea>] verify_iovec+0x3e/0x6c
 [<c023f5ab>] sys_sendmsg+0x18d/0x1f0
 [<c023ffa8>] sys_recvmsg+0x146/0x1c8
 [<c0240016>] sys_recvmsg+0x1b4/0x1c8
 [<c0118f48>] __wake_up+0xf/0x15
 [<c02586cd>] netlink_table_ungrab+0x17/0x19
 [<c01b83ba>] copy_to_user+0x25/0x3b
 [<c023fe4a>] move_addr_to_user+0x50/0x68
 [<c0240266>] sys_getsockname+0x6f/0x9a
 [<c0240280>] sys_getsockname+0x89/0x9a
 [<c015046a>] do_wp_page+0x3ae/0x41a
 [<c0151525>] handle_mm_fault+0x4c5/0x540
 [<c02405d0>] sys_socketcall+0x176/0x1b0
 [<c010376d>] sysenter_do_call+0x12/0x21
---[ end trace ad80134e35e20aad ]---





--------------090909090803030204020501
Content-Type: text/plain;
 name="msi"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="msi"

diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index f5bdc92..bfc334a 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -1553,6 +1553,7 @@ static int atl2_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (netif_running(netdev)) {
 		WARN_ON(test_bit(__ATL2_RESETTING, &adapter->flags));
 		atl2_down(adapter);
+		atl2_free_irq(adapter);
 	}
 
 #ifdef CONFIG_PM
@@ -1654,9 +1655,6 @@ wol_dis:
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), 0);
 
 suspend_exit:
-	if (netif_running(netdev))
-		atl2_free_irq(adapter);
-
 	pci_disable_device(pdev);
 
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));

--------------090909090803030204020501--
