Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZAMSvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZAMSvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZAMSvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:51:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51053 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbZAMSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:51:14 -0500
Date: Tue, 13 Jan 2009 20:51:11 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rt2860: remove kernel version compatibility wrappers
Message-ID: <Pine.LNX.4.64.0901132050120.26236@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The driver is in mainline now so there's no point in keeping the
kernel version compatibility wrappers around.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/rt2860/2860_main_dev.c |   43 +------------
 drivers/staging/rt2860/rt2860.h        |   18 -----
 drivers/staging/rt2860/rt_linux.c      |   23 +-------
 drivers/staging/rt2860/rt_linux.h      |   19 ------
 drivers/staging/rt2860/rt_main_dev.c   |  107 +++-----------------------------
 drivers/staging/rt2860/sta_ioctl.c     |   10 ---
 6 files changed, 12 insertions(+), 208 deletions(-)

diff --git a/drivers/staging/rt2860/2860_main_dev.c b/drivers/staging/rt2860/2860_main_dev.c
index 08ca81f..e2f9480 100644
--- a/drivers/staging/rt2860/2860_main_dev.c
+++ b/drivers/staging/rt2860/2860_main_dev.c
@@ -90,12 +90,10 @@ void init_thread_task(PRTMP_ADAPTER pAd);
 static void __exit rt2860_cleanup_module(void);
 static int __init rt2860_init_module(void);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #ifdef CONFIG_PM
 static int rt2860_suspend(struct pci_dev *pci_dev, pm_message_t state);
 static int rt2860_resume(struct pci_dev *pci_dev);
 #endif // CONFIG_PM //
-#endif
 
 
 //
@@ -128,22 +126,15 @@ static struct pci_driver rt2860_driver =
     name:       "rt2860",
     id_table:   rt2860_pci_tbl,
     probe:      rt2860_init_one,
-#if LINUX_VERSION_CODE >= 0x20412
     remove:     __devexit_p(rt2860_remove_one),
-#else
-    remove:     __devexit(rt2860_remove_one),
-#endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #ifdef CONFIG_PM
 	suspend:	rt2860_suspend,
 	resume:		rt2860_resume,
 #endif
-#endif
 };
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #ifdef CONFIG_PM
 
 VOID RT2860RejectPendingPackets(
@@ -284,16 +275,11 @@ static int rt2860_resume(
 	return 0;
 }
 #endif // CONFIG_PM //
-#endif
 
 
 static INT __init rt2860_init_module(VOID)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	return pci_register_driver(&rt2860_driver);
-#else
-    return pci_module_init(&rt2860_driver);
-#endif
 }
 
 
@@ -374,11 +360,7 @@ static VOID __devexit rt2860_remove_one(
 	}
 
 	// Free pre-allocated net_device memory
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	free_netdev(net_dev);
-#else
-	kfree(net_dev);
-#endif
 }
 
 //
@@ -758,11 +740,7 @@ static void ac0_dma_done_tasklet(unsigned long data)
 int print_int_count;
 
 IRQ_HANDLE_TYPE
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))
 rt2860_interrupt(int irq, void *dev_instance)
-#else
-rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs)
-#endif
 {
 	struct net_device *net_dev = (struct net_device *) dev_instance;
 	PRTMP_ADAPTER pAd = net_dev->ml_priv;
@@ -809,11 +787,7 @@ rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs)
 	if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS) ||
 		RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_HALT_IN_PROGRESS))
 	{
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-        return  IRQ_HANDLED;
-#else
-        return;
-#endif
+		return IRQ_HANDLED;
 	}
 
 	//
@@ -832,11 +806,7 @@ rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs)
 	if (IntSource.word == 0xffffffff)
 	{
 		RTMP_SET_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST | fRTMP_ADAPTER_HALT_IN_PROGRESS);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-        return  IRQ_HANDLED;
-#else
-        return;
-#endif
+		return IRQ_HANDLED;
 	}
 
 	if (IntSource.word & TxCoherent)
@@ -970,10 +940,7 @@ rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs)
 	}
 #endif // CONFIG_STA_SUPPORT //
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
     return  IRQ_HANDLED;
-#endif
-
 }
 
 /*
@@ -1026,11 +993,7 @@ BOOLEAN RT28XXNetDevInit(
     ULONG	csr_addr;
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-    print_name = pci_dev ? pci_name(pci_dev) : "rt2860";
-#else
-    print_name = pci_dev ? pci_dev->slot_name : "rt2860";
-#endif // LINUX_VERSION_CODE //
+	print_name = pci_dev ? pci_name(pci_dev) : "rt2860";
 
 	net_dev->base_addr = 0;
 	net_dev->irq = 0;
diff --git a/drivers/staging/rt2860/rt2860.h b/drivers/staging/rt2860/rt2860.h
index 0172019..54bac00 100644
--- a/drivers/staging/rt2860/rt2860.h
+++ b/drivers/staging/rt2860/rt2860.h
@@ -46,18 +46,10 @@
 	Status = NDIS_STATUS_SUCCESS;
 
 /* function declarations */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #define IRQ_HANDLE_TYPE  irqreturn_t
-#else
-#define IRQ_HANDLE_TYPE  void
-#endif
 
 IRQ_HANDLE_TYPE
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))
 rt2860_interrupt(int irq, void *dev_instance);
-#else
-rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs);
-#endif
 
 /* ----------------- Frimware Related MACRO ----------------- */
 #define RT28XX_WRITE_FIRMWARE(_pAd, _pFwImage, _FwLen)				\
@@ -237,9 +229,7 @@ rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs);
 #define RTMP_MSI_DISABLE(_pAd)
 #endif // PCI_MSI_SUPPORT //
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
 #define SA_SHIRQ IRQF_SHARED
-#endif
 
 #define RT28XX_IRQ_REQUEST(net_dev)							\
 {	PRTMP_ADAPTER _pAd = (PRTMP_ADAPTER)((net_dev)->ml_priv);	\
@@ -251,20 +241,12 @@ rt2860_interrupt(int irq, void *dev_instance, struct pt_regs *regs);
 		printk("RT2860: request_irq  ERROR(%d)\n", retval);	\
 	return retval; } }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #define RT28XX_IRQ_RELEASE(net_dev)								\
 {	PRTMP_ADAPTER _pAd = (PRTMP_ADAPTER)((net_dev)->ml_priv);		\
 	POS_COOKIE _pObj = (POS_COOKIE)(_pAd->OS_Cookie);			\
 	synchronize_irq(_pObj->pci_dev->irq);						\
 	free_irq(_pObj->pci_dev->irq, (net_dev));					\
 	RTMP_MSI_DISABLE(_pAd); }
-#else
-#define RT28XX_IRQ_RELEASE(net_dev)								\
-{	PRTMP_ADAPTER _pAd = (PRTMP_ADAPTER)((net_dev)->priv);		\
-	POS_COOKIE _pObj = (POS_COOKIE)(_pAd->OS_Cookie);			\
-	free_irq(_pObj->pci_dev->irq, (net_dev));					\
-	RTMP_MSI_DISABLE(_pAd); }
-#endif
 
 #define RT28XX_IRQ_INIT(pAd)										\
 	{	pAd->int_enable_reg = ((DELAYINTMASK) |						\
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index f145009..70a1bca 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -1005,35 +1005,14 @@ err_free_sk_buff:
 
 void rtmp_os_thread_init(PUCHAR pThreadName, PVOID pNotify)
 {
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	daemonize(pThreadName /*"%s",pAd->net_dev->name*/);
 
 	allow_signal(SIGTERM);
 	allow_signal(SIGKILL);
 	current->flags |= PF_NOFREEZE;
-#else
-	unsigned long flags;
-
-	daemonize();
-	reparent_to_init();
-	strcpy(current->comm, pThreadName);
-
-	siginitsetinv(&current->blocked, sigmask(SIGTERM) | sigmask(SIGKILL));
 
-	/* Allow interception of SIGKILL only
-	 * Don't allow other signals to interrupt the transmission */
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,4,22)
-	spin_lock_irqsave(&current->sigmask_lock, flags);
-	flush_signals(current);
-	recalc_sigpending(current);
-	spin_unlock_irqrestore(&current->sigmask_lock, flags);
-#endif
-#endif
-
-    /* signal that we've started the thread */
+	/* signal that we've started the thread */
 	complete(pNotify);
-
 }
 
 void RTMP_IndicateMediaState(
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 0fd58f5..1f670a7 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -111,8 +111,6 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 #endif // PCI_DEVICE //
 #endif // RT2860 //
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-
 #define RTMP_TIME_AFTER(a,b)		\
 	(typecheck(unsigned long, (unsigned long)a) && \
 	 typecheck(unsigned long, (unsigned long)b) && \
@@ -123,11 +121,7 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 	 typecheck(unsigned long, (unsigned long)b) && \
 	 ((long)(a) - (long)(b) >= 0))
 #define RTMP_TIME_BEFORE(a,b)	RTMP_TIME_AFTER_EQ(b,a)
-#else
-#define RTMP_TIME_AFTER(a,b) time_after(a, b)
-#endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #define RT_MOD_INC_USE_COUNT() \
 	if (!try_module_get(THIS_MODULE)) \
 	{ \
@@ -136,10 +130,6 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 	}
 
 #define RT_MOD_DEC_USE_COUNT() module_put(THIS_MODULE);
-#else
-#define RT_MOD_INC_USE_COUNT()	MOD_INC_USE_COUNT;
-#define RT_MOD_DEC_USE_COUNT() MOD_DEC_USE_COUNT;
-#endif
 
 #define OS_HZ			HZ
 
@@ -171,21 +161,12 @@ typedef int (*HARD_START_XMIT_FUNC)(struct sk_buff *skb, struct net_device *net_
 #define NDIS_PACKET_TYPE_ALL_MULTICAST	3
 #endif // CONFIG_STA_SUPPORT //
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
 typedef	struct pid *	THREAD_PID;
 #define	THREAD_PID_INIT_VALUE	NULL
 #define	GET_PID(_v)	find_get_pid(_v)
 #define	GET_PID_NUMBER(_v)	pid_nr(_v)
 #define CHECK_PID_LEGALITY(_pid)	if (pid_nr(_pid) >= 0)
 #define KILL_THREAD_PID(_A, _B, _C)	kill_pid(_A, _B, _C)
-#else
-typedef	pid_t	THREAD_PID;
-#define	THREAD_PID_INIT_VALUE	-1
-#define	GET_PID(_v)	_v
-#define	GET_PID_NUMBER(_v)	_v
-#define CHECK_PID_LEGALITY(_pid)	if (_pid >= 0)
-#define KILL_THREAD_PID(_A, _B, _C)	kill_proc(_A, _B, _C)
-#endif
 
 struct os_lock  {
 	spinlock_t		lock;
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index 3873c47..246fb0a 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -58,11 +58,7 @@ UINT32 CW_MAX_IN_BITS;
 
 char *mac = "";		   // default 00:00:00:00:00:00
 char *hostname = "";		   // default CMPC
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,12)
-MODULE_PARM (mac, "s");
-#else
 module_param (mac, charp, 0);
-#endif
 MODULE_PARM_DESC (mac, "rt28xx: wireless mac addr");
 
 
@@ -87,13 +83,6 @@ INT __devinit rt28xx_probe(IN void *_dev_p, IN void *_dev_id_p,
 static int rt28xx_init(IN struct net_device *net_dev);
 INT rt28xx_send_packets(IN struct sk_buff *skb_p, IN struct net_device *net_dev);
 
-#if LINUX_VERSION_CODE <= 0x20402	// Red Hat 7.1
-struct net_device *alloc_netdev(
-	int sizeof_priv,
-	const char *mask,
-	void (*setup)(struct net_device *));
-#endif // LINUX_VERSION_CODE //
-
 static void CfgInitHook(PRTMP_ADAPTER pAd);
 
 #ifdef CONFIG_STA_SUPPORT
@@ -808,9 +797,7 @@ static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER p
 	dev->stop = MainVirtualIF_close; //rt28xx_close;
 	dev->priv_flags = INT_MAIN;
 	dev->do_ioctl = rt28xx_ioctl;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
-    dev->validate_addr = NULL;
-#endif
+	dev->validate_addr = NULL;
 	// find available device name
 	for (i = 0; i < 8; i++)
 	{
@@ -821,25 +808,11 @@ static NDIS_STATUS rt_ieee80211_if_setup(struct net_device *dev, PRTMP_ADAPTER p
 #endif // MULTIPLE_CARD_SUPPORT //
 		sprintf(slot_name, "ra%d", i);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
-        device = dev_get_by_name(dev_net(dev), slot_name);
-#else
-        device = dev_get_by_name(dev->nd_net, slot_name);
-#endif
-#else
-		device = dev_get_by_name(slot_name);
-#endif
-		if (device != NULL) dev_put(device);
-#else
-		for (device = dev_base; device != NULL; device = device->next)
-		{
-			if (strncmp(device->name, slot_name, 4) == 0)
-				break;
-		}
-#endif
-		if(device == NULL)
+		device = dev_get_by_name(dev_net(dev), slot_name);
+		if (device != NULL)
+			dev_put(device);
+
+		if (device == NULL)
 			break;
 	}
 
@@ -1261,38 +1234,21 @@ INT __devinit   rt28xx_probe(
     DBGPRINT(RT_DEBUG_TRACE, ("STA Driver version-%s\n", STA_DRIVER_VERSION));
 #endif // CONFIG_STA_SUPPORT //
 
-#if LINUX_VERSION_CODE <= 0x20402       // Red Hat 7.1
-    net_dev = alloc_netdev(sizeof(PRTMP_ADAPTER), "eth%d", ether_setup);
-#else
     net_dev = alloc_etherdev(sizeof(PRTMP_ADAPTER));
-#endif
     if (net_dev == NULL)
     {
         printk("alloc_netdev failed\n");
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-		module_put(THIS_MODULE);
-#endif //LINUX_VERSION_CODE < KERNEL_VERSION(2,6,15)
-#else
-		MOD_DEC_USE_COUNT;
-#endif
         goto err_out;
     }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-    SET_MODULE_OWNER(net_dev);
-#endif
-
 	netif_stop_queue(net_dev);
 #ifdef NATIVE_WPA_SUPPLICANT_SUPPORT
 /* for supporting Network Manager */
 /* Set the sysfs physical device reference for the network logical device
  * if set prior to registration will cause a symlink during initialization.
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
     SET_NETDEV_DEV(net_dev, &(dev_p->dev));
-#endif
 #endif // NATIVE_WPA_SUPPLICANT_SUPPORT //
 
 	// Allocate RTMP_ADAPTER miniport adapter structure
@@ -1313,13 +1269,8 @@ INT __devinit   rt28xx_probe(
 #endif // CONFIG_STA_SUPPORT //
 
 	// Post config
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	if (RT28XXProbePostConfig(_dev_p, pAd, argc) == FALSE)
-		goto err_out_unmap;
-#else
 	if (RT28XXProbePostConfig(_dev_p, pAd, 0) == FALSE)
 		goto err_out_unmap;
-#endif // LINUX_VERSION_CODE //
 
 #ifdef CONFIG_STA_SUPPORT
 	pAd->OpMode = OPMODE_STA;
@@ -1362,20 +1313,12 @@ err_out_unmap:
 	RT28XX_UNMAP();
 
 err_out_free_netdev:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-    free_netdev(net_dev);
-#else
-	kfree(net_dev);
-#endif
+	free_netdev(net_dev);
 
 err_out:
 	RT28XX_PUT_DEVICE(dev_p);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	return (LONG)NULL;
-#else
-    return -ENODEV; /* probe fail */
-#endif // LINUX_VERSION_CODE //
+	return -ENODEV; /* probe fail */
 } /* End of rt28xx_probe */
 
 
@@ -1495,40 +1438,6 @@ INT rt28xx_send_packets(
 
 
 
-#if LINUX_VERSION_CODE <= 0x20402	// Red Hat 7.1
-struct net_device *alloc_netdev(
-	int sizeof_priv,
-	const char *mask,
-	void (*setup)(struct net_device *))
-{
-    struct net_device	*dev;
-    INT					alloc_size;
-
-
-    /* ensure 32-byte alignment of the private area */
-    alloc_size = sizeof (*dev) + sizeof_priv + 31;
-
-    dev = (struct net_device *) kmalloc(alloc_size, GFP_KERNEL);
-    if (dev == NULL)
-    {
-        DBGPRINT(RT_DEBUG_ERROR,
-				("alloc_netdev: Unable to allocate device memory.\n"));
-        return NULL;
-    }
-
-    memset(dev, 0, alloc_size);
-
-    if (sizeof_priv)
-        dev->priv = (void *) (((long)(dev + 1) + 31) & ~31);
-
-    setup(dev);
-    strcpy(dev->name, mask);
-
-    return dev;
-}
-#endif // LINUX_VERSION_CODE //
-
-
 void CfgInitHook(PRTMP_ADAPTER pAd)
 {
 	pAd->bBroadComHT = TRUE;
diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index 3ea2b2c..340ec0f 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -49,15 +49,9 @@ extern ULONG    RTDebugLevel;
 
 #define GROUP_KEY_NO                4
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
 #define IWE_STREAM_ADD_EVENT(_A, _B, _C, _D, _E)		iwe_stream_add_event(_A, _B, _C, _D, _E)
 #define IWE_STREAM_ADD_POINT(_A, _B, _C, _D, _E)		iwe_stream_add_point(_A, _B, _C, _D, _E)
 #define IWE_STREAM_ADD_VALUE(_A, _B, _C, _D, _E, _F)	iwe_stream_add_value(_A, _B, _C, _D, _E, _F)
-#else
-#define IWE_STREAM_ADD_EVENT(_A, _B, _C, _D, _E)		iwe_stream_add_event(_B, _C, _D, _E)
-#define IWE_STREAM_ADD_POINT(_A, _B, _C, _D, _E)		iwe_stream_add_point(_B, _C, _D, _E)
-#define IWE_STREAM_ADD_VALUE(_A, _B, _C, _D, _E, _F)	iwe_stream_add_value(_B, _C, _D, _E, _F)
-#endif
 
 extern UCHAR    CipherWpa2Template[];
 extern UCHAR    CipherWpaPskTkip[];
@@ -670,11 +664,9 @@ int rt_ioctl_siwmode(struct net_device *dev,
 		case IW_MODE_INFRA:
 			Set_NetworkType_Proc(pAdapter, "Infra");
 			break;
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,4,20))
         case IW_MODE_MONITOR:
 			Set_NetworkType_Proc(pAdapter, "Monitor");
 			break;
-#endif
 		default:
 			DBGPRINT(RT_DEBUG_TRACE, ("===>rt_ioctl_siwmode::SIOCSIWMODE (unknown %d)\n", *mode));
 			return -EINVAL;
@@ -715,12 +707,10 @@ int rt_ioctl_giwmode(struct net_device *dev,
 		*mode = IW_MODE_ADHOC;
     else if (INFRA_ON(pAdapter))
 		*mode = IW_MODE_INFRA;
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,4,20))
     else if (MONITOR_ON(pAdapter))
     {
         *mode = IW_MODE_MONITOR;
     }
-#endif
     else
         *mode = IW_MODE_AUTO;
 
-- 
1.5.6.4

