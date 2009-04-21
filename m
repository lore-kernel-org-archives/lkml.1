Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZDUJSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZDUJSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZDUJSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:18:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10687 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZDUJSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:18:41 -0400
X-BigFish: VPS-34(zz1432R98dR936eQ1805M936fKzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KIG1TU-04-8SH-01
Date: Tue, 21 Apr 2009 11:20:16 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, benh@kernel.crashing.org, greg@kroah.com
Subject: Re: dma-debug: add a check dma memory leaks
Message-ID: <20090421092016.GH17438@amd.com>
References: <200903302101.n2UL1O1n011970@hera.kernel.org> <1240005065.19059.19.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1240005065.19059.19.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Apr 2009 09:17:52.0604 (UTC) FILETIME=[0C51C9C0:01C9C262]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:51:05PM +0100, David Woodhouse wrote:
> On Mon, 2009-03-30 at 21:01 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/linus/41531c8f5f05aba5ec645d9770557eedbf75b422
> > Commit:     41531c8f5f05aba5ec645d9770557eedbf75b422
> 
> >     dma-debug: add a check dma memory leaks
> >     
> >     Impact: allow architectures to monitor busses for dma mem leakage
> >     
> >     This patch adds checking code to detect if a device has pending DMA
> >     operations when it is about to be unbound from its device driver.
> >     
> >     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> 
> > +static int dma_debug_device_change(struct notifier_block *nb,
> > +				    unsigned long action, void *data)
> > +{
> > +	struct device *dev = data;
> > +	int count;
> > +
> > +
> > +	switch (action) {
> > +	case BUS_NOTIFY_UNBIND_DRIVER:
> > +		count = device_dma_allocations(dev);
> > +		if (count == 0)
> > +			break;
> > +		err_printk(dev, NULL, "DMA-API: device driver has pending "
> > +				"DMA allocations while released from device "
> > +				"[count=%d]\n", count);
> 
> Hm, cute... but not quite functioning as you intended. If you look at
> __device_release_driver() in drivers/base/dd.c you'll see it actually
> calls the notifier _before_ calling into the driver's ->remove() method.
> So it's hardly surprising that not everything has been freed yet...
> 
> Reported by Reinette when it bit iwlwifi.
> 
> Ben, can we get away with changing the order so that the ->remove() is
> called before the notifier, in this case?

Ben? I would like to keep this check. If its not possible to move this
one behind the drivers ->remove function it may be an option to add
another notifier?

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

