Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZDNJKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZDNJKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZDNJKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:10:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:29697 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZDNJKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xz+lyaoEeLD9O7LUf0t9lqLXksrjKVnoanFhmbo3zBE4QpRssmyGc8VA9XxpHtYyYV
         0HrVnN+RaGnE5L1/2bvnLuiaQEVQFzix4IscqVk0RpEetBi5+9JSnKSBS/ifWR7P4J4E
         1QM7ybG+Wtjw0JmMViMQeDE1FmtiItBAdEGmc=
MIME-Version: 1.0
Date: Tue, 14 Apr 2009 17:10:30 +0800
Message-ID: <7a6b39e50904140210k6560b39qf88f4d7b2d24d7f1@mail.gmail.com>
Subject: 8139too : IntrStatus changs 0x0000
From: michael cui <michaelcui26@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
8139too.c :
static int rtl8139_poll(struct napi_struct *napi, int budget)
{
    struct rtl8139_private *tp = container_of(napi, struct
rtl8139_private, napi);
    struct net_device *dev = tp->dev;
    void __iomem *ioaddr = tp->mmio_addr;
    int work_done;
    spin_lock(&tp->rx_lock);
    work_done = 0;
    if (likely(RTL_R16(IntrStatus) & RxAckBits))
        work_done += rtl8139_rx(dev, tp, budget);
    ... ...
}
static irqreturn_t rtl8139_interrupt (int irq, void *dev_instance)
{
    status = RTL_R16 (IntrStatus);
    ... ...
    if (status & RxAckBits){
        if (netif_rx_schedule_prep(dev, &tp->napi)) {
             RTL_W16_F (IntrMask, rtl8139_norx_intr_mask);
             __netif_rx_schedule(dev, &tp->napi);
        }
   }

    ... ...
}
When rtl8139_interrupt() was happened,  the IntrStatus was 0x0001 .
Next,rtl8139_poll was invoked . But RTL_R16(IntrStatus)  changed
0x0000 .
Why? I did not do like this : RTL_W16(IntrStatus,0).

So,
static int rtl8139_poll(struct napi_struct *napi, int budget)
{
    struct rtl8139_private *tp = container_of(napi, struct
rtl8139_private, napi);
    struct net_device *dev = tp->dev;
    void __iomem *ioaddr = tp->mmio_addr;
    int work_done;
    spin_lock(&tp->rx_lock);
    work_done = 0;
    --- if (likely(RTL_R16(IntrStatus) & RxAckBits))
        work_done += rtl8139_rx(dev, tp, budget);
    ... ...
}

Is it right? thanks
