Return-Path: <linux-kernel-owner+w=401wt.eu-S934785AbZJOGvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785AbZJOGvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZJOGvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:51:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:45369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbZJOGvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:51:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,564,1249282800"; 
   d="scan'208";a="503390823"
Subject: Re: [Ipw2100-devel] 2.6.32-rc4 ipw2200: oops on missing firmware
From: Zhu Yi <yi.zhu@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Ferenc Wagner <wferi@niif.hu>,
       "ipw2100-devel@lists.sourceforge.net" 
	<ipw2100-devel@lists.sourceforge.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200910131855.25878.elendil@planet.nl>
References: <87hbu3h023.fsf@tac.ki.iif.hu>
	 <200910131855.25878.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 14:50:28 +0800
Message-Id: <1255589428.3719.465.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 00:55 +0800, Frans Pop wrote:
> Adding relevant CCs. Original message follows.
> 
> ==============
> Hi,
> 
> See the screenshot at http://apt.niif.hu/ipw_oops.png.  During bootup,
> initramfs-tools tried to load the ipw2200 module, but nobody fed it
> the necessary firmware, so request_firmware timed out and the module
> unload cleanup oopsed in device_pm_remove:
> 
> void device_pm_remove(struct device *dev)
> {
>         pr_debug("PM: Removing info for %s:%s\n",
>                  dev->bus ? dev->bus->name : "No Bus",
>                  kobject_name(&dev->kobj));
>         mutex_lock(&dpm_list_mtx);
>         list_del_init(&dev->power.entry);
>         mutex_unlock(&dpm_list_mtx);
>         pm_runtime_remove(dev);
> }
> 
> 00000a0a <device_pm_remove>:
>  a0a:   55                      push   %ebp
>  a0b:   89 e5                   mov    %esp,%ebp
>  a0d:   53                      push   %ebx
>  a0e:   89 c3                   mov    %eax,%ebx
>  a10:   b8 08 00 00 00          mov    $0x8,%eax
>  a15:   e8 fc ff ff ff          call   a16 <device_pm_remove+0xc>
>  a1a:   8d 4b 5c                lea    0x5c(%ebx),%ecx
>  a1d:   8b 53 5c                mov    0x5c(%ebx),%edx
>  a20:   8b 43 60                mov    0x60(%ebx),%eax
>  a23:   89 42 04                mov    %eax,0x4(%edx)
>  a26:   89 10                   mov    %edx,(%eax)
>  a28:   89 4b 5c                mov    %ecx,0x5c(%ebx)
>  a2b:   89 4b 60                mov    %ecx,0x60(%ebx)
>  a2e:   b8 08 00 00 00          mov    $0x8,%eax
>  a33:   e8 fc ff ff ff          call   a34 <device_pm_remove+0x2a>
>  a38:   89 d8                   mov    %ebx,%eax
>  a3a:   e8 fc ff ff ff          call   a3b <device_pm_remove+0x31>
>  a3f:   5b                      pop    %ebx
>  a40:   5d                      pop    %ebp
>  a41:   c3                      ret    
> 
> The offending IP translates to line a23, so the problem is edx being 0
> at that point.  I'm not sure which struct device field has offset
> 0x5c, maybe power, but I'm lost at this point anyway.

OK. The rfkill device is removed without being added before! The root
cause is, for non-monitor interfaces, the syntax for
alloc_ieee80211/free_80211 is wrong. Because alloc_ieee80211 only
creates (wiphy_new) a wiphy, but free_80211() does wiphy_unregister()
also. This is only correct when the later wiphy_register() is called
successfully, which apparently is not the case for your fw doesn't exist
one. Please see if this patch fix the problem.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 240cff1..a741d37 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6325,8 +6325,10 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 
       fail:
 	if (dev) {
-		if (registered)
+		if (registered) {
+			unregister_ieee80211(priv->ieee);
 			unregister_netdev(dev);
+		}
 
 		ipw2100_hw_stop_adapter(priv);
 
@@ -6383,6 +6385,7 @@ static void __devexit ipw2100_pci_remove_one(struct pci_dev *pci_dev)
 		/* Unregister the device first - this results in close()
 		 * being called if the device is open.  If we free storage
 		 * first, then close() will crash. */
+		unregister_ieee80211(priv->ieee);
 		unregister_netdev(dev);
 
 		/* ipw2100_down will ensure that there is no more pending work
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 7f169e1..e2af22b 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11823,6 +11823,7 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
 		if (err) {
 			IPW_ERROR("Failed to register promiscuous network "
 				  "device (error %d).\n", err);
+			unregister_ieee80211(priv->ieee);
 			unregister_netdev(priv->net_dev);
 			goto out_remove_sysfs;
 		}
@@ -11873,6 +11874,7 @@ static void __devexit ipw_pci_remove(struct pci_dev *pdev)
 
 	mutex_unlock(&priv->mutex);
 
+	unregister_ieee80211(priv->ieee);
 	unregister_netdev(priv->net_dev);
 
 	if (priv->rxq) {
diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index bf45391..f42ade6 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -1020,6 +1020,7 @@ static inline int libipw_is_cck_rate(u8 rate)
 /* ieee80211.c */
 extern void free_ieee80211(struct net_device *dev, int monitor);
 extern struct net_device *alloc_ieee80211(int sizeof_priv, int monitor);
+extern void unregister_ieee80211(struct libipw_device *ieee);
 extern int libipw_change_mtu(struct net_device *dev, int new_mtu);
 
 extern void libipw_networks_age(struct libipw_device *ieee,
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index a0e9f6a..be5b809 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -235,16 +235,19 @@ void free_ieee80211(struct net_device *dev, int monitor)
 	libipw_networks_free(ieee);
 
 	/* free cfg80211 resources */
-	if (!monitor) {
-		wiphy_unregister(ieee->wdev.wiphy);
-		kfree(ieee->a_band.channels);
-		kfree(ieee->bg_band.channels);
+	if (!monitor)
 		wiphy_free(ieee->wdev.wiphy);
-	}
 
 	free_netdev(dev);
 }
 
+void unregister_ieee80211(struct libipw_device *ieee)
+{
+	wiphy_unregister(ieee->wdev.wiphy);
+	kfree(ieee->a_band.channels);
+	kfree(ieee->bg_band.channels);
+}
+
 #ifdef CONFIG_LIBIPW_DEBUG
 
 static int debug = 0;
@@ -330,3 +333,4 @@ module_init(libipw_init);
 
 EXPORT_SYMBOL(alloc_ieee80211);
 EXPORT_SYMBOL(free_ieee80211);
+EXPORT_SYMBOL(unregister_ieee80211);


