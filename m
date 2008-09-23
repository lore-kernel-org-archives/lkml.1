Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYIWPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYIWPoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYIWPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:44:00 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:36737 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYIWPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:43:59 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq preemption, eHCA is close
Date: Tue, 23 Sep 2008 17:43:23 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <RAISCH@de.ibm.com>,
       Benjamin Herrenschmidt <bherren@au1.ibm.com>, gilles.carry@ext.bull.net,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, jean-pierre.dion@bull.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev@vger.kernel.org,
       Thomas Q Klein <TKLEIN@de.ibm.com>, tinytim@us.ibm.com,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
References: <20080915100406.342e027a@bull.net> <OFD7842B7A.ADC47EED-ONC12574C8.003A2CB3-C12574C8.003AC948@de.ibm.com> <20080918143146.77db81d5@bull.net>
In-Reply-To: <20080918143146.77db81d5@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231743.23828.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think these are the "functional" changes that need to be included in
the ibmebus driver. We'll add a RT flag in the final version to enable
these changes only for RT-Linux for now. 
Ben, can you / your team look into the implementation
of the set_irq_type functionality needed for XICS?

Regards,
Jan-Bernd & Christoph

diff -Nurp b/arch/powerpc/kernel/ibmebus.c a/arch/powerpc/kernel/ibmebus.c
--- b/arch/powerpc/kernel/ibmebus.c	2008-09-22 00:29:55.000000000 +0200
+++ a/arch/powerpc/kernel/ibmebus.c	2008-09-23 12:04:53.000000000 +0200
@@ -216,12 +216,16 @@ int ibmebus_request_irq(u32 ist, irq_han
 			unsigned long irq_flags, const char *devname,
 			void *dev_id)
 {
+	int ret;
 	unsigned int irq = irq_create_mapping(NULL, ist);
 
 	if (irq == NO_IRQ)
 		return -EINVAL;
 
-	return request_irq(irq, handler, irq_flags, devname, dev_id);
+	ret = request_irq(irq, handler, irq_flags, devname, dev_id);
+	set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
+
+	return ret;
 }
 EXPORT_SYMBOL(ibmebus_request_irq);
 


