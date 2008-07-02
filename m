Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbYGBKJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbYGBKJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYGBKJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:09:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbYGBKJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:09:29 -0400
Date: Wed, 2 Jul 2008 03:07:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, amit.shah@qumranet.com, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v2 -mm 1/2] add the device argument to dma_mapping_error
Message-Id: <20080702030723.dabf7546.akpm@linux-foundation.org>
In-Reply-To: <1211178689-3507-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1211178689-3507-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 15:31:28 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> dma_mapping_error doesn't take a pointer to the device unlike other
> DMA operations. So we can't have dma_mapping_ops per device.
> 
> Note that POWER already has dma_mapping_ops per device but all the
> POWER IOMMUs use the same dma_mapping_error function. x86 IOMMUs use
> different dma_mapping_error functions. So dma_mapping_error needs the
> device argument.

This patch continues to turn my hair grey.

I'm currently staring at this, in include/linux/ssb/ssb.h:

static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
{
	switch (dev->bus->bustype) {
	case SSB_BUSTYPE_PCI:
		return pci_dma_mapping_error(dev->dev, addr);
	case SSB_BUSTYPE_SSB:
		return dma_mapping_error(dev->dev, addr);
	default:
		__ssb_dma_not_implemented(dev);
	}
	return -ENOSYS;
}

How do I go from an ssb_device* to a pci_dev*?

Dunno.  I think I'll cheat and do:

static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
{
	switch (dev->bus->bustype) {
	case SSB_BUSTYPE_PCI:
		return dma_mapping_error(dev->dev, addr);
	case SSB_BUSTYPE_SSB:
		return dma_mapping_error(dev->dev, addr);
	default:
		__ssb_dma_not_implemented(dev);
	}
	return -ENOSYS;
}

please take a look, see if we can do better?
