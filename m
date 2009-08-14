Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZHNCku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZHNCku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZHNCkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:40:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57775 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZHNCks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:40:48 -0400
Date: Fri, 14 Aug 2009 12:40:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dhananjay Phadke <dhananjay@netxen.com>,
       Amit Kumar Salecha <amit@netxen.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20090814124040.534dd43c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the net tree got a conflict in
drivers/net/netxen/netxen_nic_main.c between commits
e424fa9d6a0add1a9b812b07e3607daaa5b9e53d ("netxen: remove netxen
workqueue") and 232e7d68d50c9ac3a55d716e5ae215ecd1e043b9 ("netxen: free
napi resources during detach") from the net-current tree and commits
6598b169b856793f8f9b80a3f3c5a48f5eaf40e3 ("netxen: enable ip addr
hashing"), f17443f4b01659a5c44d5fc6f5c502c39c293959 ("netxen: refactor
net_device setup code") and 7042cd8f148345bfca6c336f009c96a416674f5e
("netxen: support for ethtool set ringparam") from the net tree.

I fixed it up (I hope) (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/netxen/netxen_nic_main.c
index 28f270f,98271f9..0000000
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@@ -905,19 -923,15 +935,17 @@@ netxen_nic_attach(struct netxen_adapte
  	struct nx_host_rds_ring *rds_ring;
  	struct nx_host_tx_ring *tx_ring;
  
+ 	if (adapter->is_up == NETXEN_ADAPTER_UP_MAGIC)
+ 		return 0;
+ 
  	err = netxen_init_firmware(adapter);
 -	if (err != 0) {
 -		printk(KERN_ERR "Failed to init firmware\n");
 -		return -EIO;
 -	}
 +	if (err)
 +		return err;
 +
 +	err = netxen_napi_add(adapter, netdev);
 +	if (err)
 +		return err;
  
- 	if (adapter->fw_major < 4)
- 		adapter->max_rds_rings = 3;
- 	else
- 		adapter->max_rds_rings = 2;
- 
  	err = netxen_alloc_sw_resources(adapter);
  	if (err) {
  		printk(KERN_ERR "%s: Error in setting sw resources\n",
@@@ -981,6 -1000,95 +1015,91 @@@ netxen_nic_detach(struct netxen_adapte
  	adapter->is_up = 0;
  }
  
+ int
+ netxen_nic_reset_context(struct netxen_adapter *adapter)
+ {
+ 	int err = 0;
+ 	struct net_device *netdev = adapter->netdev;
+ 
+ 	if (adapter->is_up == NETXEN_ADAPTER_UP_MAGIC) {
+ 
+ 		if (netif_running(netdev))
+ 			netxen_nic_down(adapter, netdev);
+ 
+ 		netxen_nic_detach(adapter);
+ 
+ 		err = netxen_nic_attach(adapter);
+ 		if (err)
+ 			goto done;
+ 
+ 		if (netif_running(netdev))
+ 			err = netxen_nic_up(adapter, netdev);
+ 	}
+ done:
+ 	return err;
+ }
+ 
+ static int
+ netxen_setup_netdev(struct netxen_adapter *adapter,
+ 		struct net_device *netdev)
+ {
+ 	int err = 0;
+ 	struct pci_dev *pdev = adapter->pdev;
+ 
+ 	adapter->rx_csum = 1;
+ 	adapter->mc_enabled = 0;
+ 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
+ 		adapter->max_mc_count = 38;
+ 	else
+ 		adapter->max_mc_count = 16;
+ 
+ 	netdev->netdev_ops	   = &netxen_netdev_ops;
+ 	netdev->watchdog_timeo     = 2*HZ;
+ 
+ 	netxen_nic_change_mtu(netdev, netdev->mtu);
+ 
+ 	SET_ETHTOOL_OPS(netdev, &netxen_nic_ethtool_ops);
+ 
+ 	netdev->features |= (NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
+ 	netdev->features |= (NETIF_F_GRO);
+ 	netdev->vlan_features |= (NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO);
+ 
+ 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
+ 		netdev->features |= (NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
+ 		netdev->vlan_features |= (NETIF_F_IPV6_CSUM | NETIF_F_TSO6);
+ 	}
+ 
+ 	if (adapter->pci_using_dac) {
+ 		netdev->features |= NETIF_F_HIGHDMA;
+ 		netdev->vlan_features |= NETIF_F_HIGHDMA;
+ 	}
+ 
+ 	if (adapter->capabilities & NX_FW_CAPABILITY_FVLANTX)
+ 		netdev->features |= (NETIF_F_HW_VLAN_TX);
+ 
+ 	netdev->irq = adapter->msix_entries[0].vector;
+ 
 -	err = netxen_napi_add(adapter, netdev);
 -	if (err)
 -		return err;
 -
+ 	init_timer(&adapter->watchdog_timer);
+ 	adapter->watchdog_timer.function = &netxen_watchdog;
+ 	adapter->watchdog_timer.data = (unsigned long)adapter;
+ 	INIT_WORK(&adapter->watchdog_task, netxen_watchdog_task);
+ 	INIT_WORK(&adapter->tx_timeout_task, netxen_reset_task);
+ 
+ 	if (netxen_read_mac_addr(adapter))
+ 		dev_warn(&pdev->dev, "failed to read mac addr\n");
+ 
+ 	netif_carrier_off(netdev);
+ 	netif_stop_queue(netdev);
+ 
+ 	err = register_netdev(netdev);
+ 	if (err) {
+ 		dev_err(&pdev->dev, "failed to register net device\n");
+ 		return err;
+ 	}
+ 
+ 	return 0;
+ }
+ 
  static int __devinit
  netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  {
@@@ -1189,17 -1245,13 +1256,15 @@@ static void __devexit netxen_nic_remove
  
  	unregister_netdev(netdev);
  
 +	cancel_work_sync(&adapter->watchdog_task);
 +	cancel_work_sync(&adapter->tx_timeout_task);
 +
- 	if (adapter->is_up == NETXEN_ADAPTER_UP_MAGIC) {
- 		netxen_nic_detach(adapter);
- 	}
+ 	netxen_nic_detach(adapter);
  
  	if (adapter->portnum == 0)
- 		netxen_free_adapter_offload(adapter);
+ 		netxen_free_dummy_dma(adapter);
  
  	netxen_teardown_intr(adapter);
 -	netxen_free_sds_rings(&adapter->recv_ctx);
  
  	netxen_cleanup_pci_map(adapter);
  
@@@ -1225,11 -1277,7 +1290,10 @@@ netxen_nic_suspend(struct pci_dev *pdev
  	if (netif_running(netdev))
  		netxen_nic_down(adapter, netdev);
  
 +	cancel_work_sync(&adapter->watchdog_task);
 +	cancel_work_sync(&adapter->tx_timeout_task);
 +
- 	if (adapter->is_up == NETXEN_ADAPTER_UP_MAGIC)
- 		netxen_nic_detach(adapter);
+ 	netxen_nic_detach(adapter);
  
  	pci_save_state(pdev);
  
@@@ -1686,11 -1746,15 +1779,14 @@@ void netxen_watchdog_task(struct work_s
  
  static void netxen_tx_timeout(struct net_device *netdev)
  {
 -	struct netxen_adapter *adapter = (struct netxen_adapter *)
 -						netdev_priv(netdev);
 +	struct netxen_adapter *adapter = netdev_priv(netdev);
+ 
+ 	dev_err(&netdev->dev, "transmit timeout, resetting.\n");
+ 
 -	SCHEDULE_WORK(&adapter->tx_timeout_task);
 +	schedule_work(&adapter->tx_timeout_task);
  }
  
- static void netxen_tx_timeout_task(struct work_struct *work)
+ static void netxen_reset_task(struct work_struct *work)
  {
  	struct netxen_adapter *adapter =
  		container_of(work, struct netxen_adapter, tx_timeout_task);
@@@ -1844,6 -2025,14 +2057,11 @@@ static int __init netxen_init_module(vo
  {
  	printk(KERN_INFO "%s\n", netxen_nic_driver_string);
  
 -	if ((netxen_workq = create_singlethread_workqueue("netxen")) == NULL)
 -		return -ENOMEM;
 -
+ #ifdef CONFIG_INET
+ 	register_netdevice_notifier(&netxen_netdev_cb);
+ 	register_inetaddr_notifier(&netxen_inetaddr_cb);
+ #endif
+ 
  	return pci_register_driver(&netxen_driver);
  }
  
@@@ -1852,6 -2041,12 +2070,11 @@@ module_init(netxen_init_module)
  static void __exit netxen_exit_module(void)
  {
  	pci_unregister_driver(&netxen_driver);
+ 
+ #ifdef CONFIG_INET
+ 	unregister_inetaddr_notifier(&netxen_inetaddr_cb);
+ 	unregister_netdevice_notifier(&netxen_netdev_cb);
+ #endif
 -	destroy_workqueue(netxen_workq);
  }
  
  module_exit(netxen_exit_module);
