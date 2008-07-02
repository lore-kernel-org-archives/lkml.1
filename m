Return-Path: <linux-kernel-owner+w=401wt.eu-S1763158AbYGBKVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763158AbYGBKVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYGBKVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:21:15 -0400
Received: from bu3sch.de ([62.75.166.246]:42330 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYGBKVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:21:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 -mm 1/2] add the device argument to dma_mapping_error
Date: Wed, 2 Jul 2008 12:20:43 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, amit.shah@qumranet.com, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080702030723.dabf7546.akpm@linux-foundation.org> <200807021218.41153.mb@bu3sch.de>
In-Reply-To: <200807021218.41153.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021220.44339.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008 12:18:40 Michael Buesch wrote:
> On Wednesday 02 July 2008 12:07:23 Andrew Morton wrote:
> > On Mon, 19 May 2008 15:31:28 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > dma_mapping_error doesn't take a pointer to the device unlike other
> > > DMA operations. So we can't have dma_mapping_ops per device.
> > > 
> > > Note that POWER already has dma_mapping_ops per device but all the
> > > POWER IOMMUs use the same dma_mapping_error function. x86 IOMMUs use
> > > different dma_mapping_error functions. So dma_mapping_error needs the
> > > device argument.
> > 
> > This patch continues to turn my hair grey.
> > 
> > I'm currently staring at this, in include/linux/ssb/ssb.h:
> > 
> > static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
> > {
> > 	switch (dev->bus->bustype) {
> > 	case SSB_BUSTYPE_PCI:
> > 		return pci_dma_mapping_error(dev->dev, addr);
> > 	case SSB_BUSTYPE_SSB:
> > 		return dma_mapping_error(dev->dev, addr);
> > 	default:
> > 		__ssb_dma_not_implemented(dev);
> > 	}
> > 	return -ENOSYS;
> > }
> > 
> > How do I go from an ssb_device* to a pci_dev*?
> > 
> > Dunno.  I think I'll cheat and do:
> > 
> > static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
> > {
> > 	switch (dev->bus->bustype) {
> > 	case SSB_BUSTYPE_PCI:
> > 		return dma_mapping_error(dev->dev, addr);
> 
> The statement above is wrong. The PCI-specific dma-mapping-error function
> must be used here. (I hope such a thing exists. Otherwise the API is broken).
> So
> 		return pci_mapping_error(dev->bus->host_pci, addr);

Oh wait I see you quoted the function above. So the statement should be:

		return pci_dma_mapping_error(dev->bus->host_pci, addr);


-- 
Greetings Michael.
