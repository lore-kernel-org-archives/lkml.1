Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYI0U5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYI0U5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYI0U5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:57:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:2896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYI0U5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qlendSj7sqLvZxxM39cJh1FDTl68fvZ9En+KjII3Ug/3fWt846GRl2kEeYOraxrj0L
         VRZHZp/EyuY3EZlBig3CLzJfdSce5Q3kvoz/gCP4dzP7hPGsNsAP4yvXTq+1S0HlUSPF
         4fuGyZC7/S+hlUa4JUWrO1PQHg4NuKdzuATJ8=
Message-ID: <7d553cf40809271357r54c2b717lae637a4393c286c6@mail.gmail.com>
Date: Sat, 27 Sep 2008 16:57:05 -0400
From: Paul <paul14075@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables aireplay-ng and others to work
In-Reply-To: <7d553cf40809271343m57b8d64er99c979fdc8c35e61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7d553cf40809271343m57b8d64er99c979fdc8c35e61@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch, in text form:

--- drivers/net/wireless/ipw2200.c      2008-09-09 19:27:49.000000000
-0400
+++ drivers/net/wireless/ipw2200-new.c  2008-09-27 15:48:03.000000000
-0400
@@ -179,7 +179,7 @@ static int ipw_queue_reset(struct ipw_pr

 static int ipw_queue_tx_hcmd(struct ipw_priv *priv, int hcmd, void
*buf,
                             int len, int sync);
-
+static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb
*txb, int pri);
 static void ipw_tx_queue_free(struct ipw_priv *);

 static struct ipw_rx_queue *ipw_rx_queue_alloc(struct ipw_priv *);
@@ -1862,6 +1862,62 @@ static ssize_t store_net_stats(struct de
 static DEVICE_ATTR(net_stats, S_IWUSR | S_IRUGO,
                   show_net_stats, store_net_stats);

+/* SYSFS INJECT */
+static ssize_t store_inject(struct device *d,
+        struct device_attribute *attr,
+        const char *buf, size_t count)
+{
+        struct ipw_priv *priv = (struct ipw_priv *)d->driver_data;
+        struct ieee80211_device *ieee = priv->ieee;
+        struct ieee80211_txb * txb;
+        struct sk_buff *skb_frag;
+        unsigned char * newbuf;
+        unsigned long flags;
+
+        // should test (ieee->is_queue_full)
+
+        // Fw only accepts data, so avoid accidental fw errors.
+        if ( (buf[0]&0x0c) != '\x08') {
+              //printk("ipw2200: inject: discarding non-data frame
(type=%02X)\n",(int)(unsigned char)buf[0]);
+              return count;
+        }
+
+        if (count>1500) {
+              count=1500;
+              printk("ipw2200: inject: cutting down frame to 1500
bytes\n");
+        }
+
+        spin_lock_irqsave(&priv->lock, flags);
+
+        // Create a txb with one skb
+        txb = kmalloc(sizeof(struct ieee80211_txb) + sizeof(u8 *),
GFP_ATOMIC);
+        if (!txb)
+              goto nosepuede;
+        txb->nr_frags=1;
+        txb->frag_size = ieee->tx_headroom;
+        txb->fragments[0]=__dev_alloc_skb(count + ieee->tx_headroom,
GFP_ATOMIC);
+        if (!txb->fragments[0]) {
+              kfree(txb);
+              goto nosepuede;
+        }
+        skb_reserve(txb->fragments[0], ieee->tx_headroom);
+        txb->encrypted=0;
+        txb->payload_size=count;
+        skb_frag = txb->fragments[0];
+        newbuf=skb_put(skb_frag, count);
+
+        // copy data into txb->skb and send it
+        memcpy(newbuf, buf, count);
+
+        ipw_tx_skb(priv, txb, 0);
+
+nosepuede:
+        spin_unlock_irqrestore(&priv->lock, flags);
+        return count;
+}
+
+static DEVICE_ATTR(inject, S_IWUSR, NULL, store_inject);
+
 static ssize_t show_channels(struct device *d,
                             struct device_attribute *attr,
                             char *buf)
@@ -10512,6 +10568,10 @@ static int ipw_net_set_mac_address(struc
        mutex_lock(&priv->mutex);
        priv->config |= CFG_CUSTOM_MAC;
        memcpy(priv->mac_addr, addr->sa_data, ETH_ALEN);
+
+        if (rtap_iface)
+               memcpy(priv->prom_net_dev->dev_addr, addr->sa_data,
ETH_ALEN);
+
        printk(KERN_INFO "%s: Setting MAC to %s\n",
               priv->net_dev->name, print_mac(mac, priv->mac_addr));
        queue_work(priv->workqueue, &priv->adapter_restart);
@@ -11478,6 +11538,7 @@ static struct attribute *ipw_sysfs_entri
 #ifdef CONFIG_IPW2200_PROMISCUOUS
        &dev_attr_rtap_iface.attr,
        &dev_attr_rtap_filter.attr,
+       &dev_attr_inject.attr,
 #endif
        NULL
 };
--- drivers/net/wireless/ipw2200.h      2008-09-09 19:27:49.000000000 -0400
+++ drivers/net/wireless/ipw2200-new.h  2008-09-27 15:32:23.000000000 -0400
@@ -2007,4 +2007,13 @@ struct ipw_cmd_log {

 #define IPW_MAX_CONFIG_RETRIES 10

+/*
+ * Hhack to get code compiling on new kernels, the define below
+ * seem to be removed from the linux headers.
+ */
+#ifndef MAC_ARG
+#define MAC_ARG(x)
((u8*)(x))[0],((u8*)(x))[1],((u8*)(x))[2],((u8*)(x))[3],((u8*)(x))[4],((u8*)(x))[5]
+#endif
+
+
 #endif                         /* __ipw2200_h__ */


On Sat, Sep 27, 2008 at 4:43 PM, Paul <paul14075@gmail.com> wrote:
> I made this patch using bits and pieces from various other "ipw2200
> injection patches".  I can not take credit for the content, as I
> basically just changed the line numbers in the .diff files.  However I
> applied this patch to the version of ipw2200 included in kernel
> 2.6.27-rc6  (i believe it's ipw2200-1.2.2) and it worked like a charm.
>
> Previously I was unable to inject wifi packets using aireplay-ng due
> to this error:
>
> "ARP linktype is set to 1 (Ethernet) - expected ARPHRD_IEEE80211 or
> ARPHRD_IEEE80211_PRISM instead.  Make sure RFMON is enabled: run
> 'ifconfig wifi0 up; iwconfig wifi0 mode Monitor channel <#>' Sysfs
> injection support was not found either."
>
> However, after switching to Monitor mode, even though aireplay would
> ACT AS IF it was working, it wasn't.
>
> After applying this patch, everything worked great.
>
> I don't see why this patch isnt already included in ipw2200.
>
> Thanks,
> - Paul
>
