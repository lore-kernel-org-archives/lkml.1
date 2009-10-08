Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZJHIU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZJHIU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZJHIU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:20:29 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:47772 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZJHIU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:20:27 -0400
From: Alexander Strakh <strakh@ispras.ru>
Organization: ISP RAS
To: Benjamin Kong <benjamin_kong@ali.com.tw>, Samuel Ortiz <samuel@sortiz.org>,
       rda-users@lists.sourceforge.net,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] ali-ircc.c sleeping function called from invalid context
Date: Thu, 8 Oct 2009 12:22:29 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081222.29956.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
Driver reports/drivers/net/irda/ali-ircc.c might sleep in attomic context, 
because it calls ali_ircc_change_speed after spin_lock_irqsave:

drivers/net/irda/ali-ircc.c:
2028static int ali_ircc_net_ioctl(struct net_device *dev, struct ifreq *rq, 
int cmd)
...
2056                spin_lock_irqsave(&self->lock, flags);
2057                ali_ircc_change_speed(self, irq->ifr_baudrate);         
...

Path to might_sleep macro from ali_ircc_change_speed:
1. ali_ircc_change_speed calls ali_ircc_sir_change_speed 
./drivers/net/irda/ali-ircc.c:999
2. ali_ircc_sir_change_speed calls spin_lock_irqsave at 
./drivers/net/irda/ali-ircc.c:1084

Found by: Linux Driver Verification

