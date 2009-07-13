Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZGMRaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZGMRaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbZGMR37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:29:59 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60335 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZGMR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:29:58 -0400
Message-ID: <4A5B6F12.6030101@gmail.com>
Date: Mon, 13 Jul 2009 19:29:54 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Teck Choon Giam <giamteckchoon@gmail.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-2.6.30.1 with gcc-3.4.6 compile error
References: <9b5c9bb30907130944l3624870ck507f5a9f0f79452b@mail.gmail.com>
In-Reply-To: <9b5c9bb30907130944l3624870ck507f5a9f0f79452b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 13 Jul 2009 19:29:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teck Choon Giam a écrit :
> Hi,
> 
> Anyone encounter the below error while compiling linux-2.6.30.1 with gcc-3.4.6?
> 
> drivers/net/igb/igb_main.c: In function `igb_up':
> drivers/net/igb/igb_main.c:130: sorry, unimplemented: inlining failed
> in call to 'igb_set_rah_pool': function body not available
> drivers/net/igb/igb_main.c:938: sorry, unimplemented: called from here
> drivers/net/igb/igb_main.c:133: sorry, unimplemented: inlining failed
> in call to 'igb_set_vmolr': function body not available
> drivers/net/igb/igb_main.c:939: sorry, unimplemented: called from here
> make[3]: *** [drivers/net/igb/igb_main.o] Error 1
> make[2]: *** [drivers/net/igb] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> This is CentOS 4.x system.  While using same configuration to compile
> in CentOS 5.x systems with gcc-4.1.2 do not encounter such error and
> my guess is gcc version issue?  Any idea?
> 

You are right, this driver cannot compile with gcc-3.4.6 and needs
following patch.

[PATCH] igb: gcc-3.4.6 fix

forward declaration of inline function should be avoided, or
old gcc cannot compile.

Reported-by: Teck Choon Giam <giamteckchoon@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index be48029..adb09d3 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -127,14 +127,48 @@ static void igb_restore_vlan(struct igb_adapter *);
 static void igb_ping_all_vfs(struct igb_adapter *);
 static void igb_msg_task(struct igb_adapter *);
 static int igb_rcv_msg_from_vf(struct igb_adapter *, u32);
-static inline void igb_set_rah_pool(struct e1000_hw *, int , int);
 static void igb_set_mc_list_pools(struct igb_adapter *, int, u16);
 static void igb_vmm_control(struct igb_adapter *);
-static inline void igb_set_vmolr(struct e1000_hw *, int);
-static inline int igb_set_vf_rlpml(struct igb_adapter *, int, int);
 static int igb_set_vf_mac(struct igb_adapter *adapter, int, unsigned char *);
 static void igb_restore_vf_multicasts(struct igb_adapter *adapter);
 
+static inline void igb_set_vmolr(struct e1000_hw *hw, int vfn)
+{
+	u32 reg_data;
+
+	reg_data = rd32(E1000_VMOLR(vfn));
+	reg_data |= E1000_VMOLR_BAM |	 /* Accept broadcast */
+	            E1000_VMOLR_ROPE |   /* Accept packets matched in UTA */
+	            E1000_VMOLR_ROMPE |  /* Accept packets matched in MTA */
+	            E1000_VMOLR_AUPE |   /* Accept untagged packets */
+	            E1000_VMOLR_STRVLAN; /* Strip vlan tags */
+	wr32(E1000_VMOLR(vfn), reg_data);
+}
+
+static inline int igb_set_vf_rlpml(struct igb_adapter *adapter, int size,
+                                 int vfn)
+{
+	struct e1000_hw *hw = &adapter->hw;
+	u32 vmolr;
+
+	vmolr = rd32(E1000_VMOLR(vfn));
+	vmolr &= ~E1000_VMOLR_RLPML_MASK;
+	vmolr |= size | E1000_VMOLR_LPE;
+	wr32(E1000_VMOLR(vfn), vmolr);
+
+	return 0;
+}
+
+static inline void igb_set_rah_pool(struct e1000_hw *hw, int pool, int entry)
+{
+	u32 reg_data;
+
+	reg_data = rd32(E1000_RAH(entry));
+	reg_data &= ~E1000_RAH_POOL_MASK;
+	reg_data |= E1000_RAH_POOL_1 << pool;;
+	wr32(E1000_RAH(entry), reg_data);
+}
+
 #ifdef CONFIG_PM
 static int igb_suspend(struct pci_dev *, pm_message_t);
 static int igb_resume(struct pci_dev *);
@@ -5418,43 +5452,6 @@ static void igb_io_resume(struct pci_dev *pdev)
 	igb_get_hw_control(adapter);
 }
 
-static inline void igb_set_vmolr(struct e1000_hw *hw, int vfn)
-{
-	u32 reg_data;
-
-	reg_data = rd32(E1000_VMOLR(vfn));
-	reg_data |= E1000_VMOLR_BAM |	 /* Accept broadcast */
-	            E1000_VMOLR_ROPE |   /* Accept packets matched in UTA */
-	            E1000_VMOLR_ROMPE |  /* Accept packets matched in MTA */
-	            E1000_VMOLR_AUPE |   /* Accept untagged packets */
-	            E1000_VMOLR_STRVLAN; /* Strip vlan tags */
-	wr32(E1000_VMOLR(vfn), reg_data);
-}
-
-static inline int igb_set_vf_rlpml(struct igb_adapter *adapter, int size,
-                                 int vfn)
-{
-	struct e1000_hw *hw = &adapter->hw;
-	u32 vmolr;
-
-	vmolr = rd32(E1000_VMOLR(vfn));
-	vmolr &= ~E1000_VMOLR_RLPML_MASK;
-	vmolr |= size | E1000_VMOLR_LPE;
-	wr32(E1000_VMOLR(vfn), vmolr);
-
-	return 0;
-}
-
-static inline void igb_set_rah_pool(struct e1000_hw *hw, int pool, int entry)
-{
-	u32 reg_data;
-
-	reg_data = rd32(E1000_RAH(entry));
-	reg_data &= ~E1000_RAH_POOL_MASK;
-	reg_data |= E1000_RAH_POOL_1 << pool;;
-	wr32(E1000_RAH(entry), reg_data);
-}
-
 static void igb_set_mc_list_pools(struct igb_adapter *adapter,
 				  int entry_count, u16 total_rar_filters)
 {
