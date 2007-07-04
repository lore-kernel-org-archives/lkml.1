Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbXGDLEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbXGDLEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbXGDLE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:04:27 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50677 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbXGDLE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:04:26 -0400
Message-ID: <468B7EAA.2040903@s5r6.in-berlin.de>
Date: Wed, 04 Jul 2007 13:04:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: hch@infradead.org, Yinghai.Lu@Sun.COM, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, ak@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] net: use numa_node in net_devcice->dev instead of
 parent
References: <20070703143407.7e4232f8@freepuppy.localdomain.hemminger.net>	<200707031730.51677.yinghai.lu@sun.com>	<20070704085120.GB19515@infradead.org> <20070704.033530.105423846.davem@davemloft.net>
In-Reply-To: <20070704.033530.105423846.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Wed, 4 Jul 2007 09:51:20 +0100
> 
>> On Tue, Jul 03, 2007 at 05:30:51PM -0700, Yinghai Lu wrote:
...
>> >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
>> >  		unsigned int length, gfp_t gfp_mask)
>> >  {
>> > -	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
>> > +	int node = dev_to_node(&dev->dev);
>> 
>> This looks wrong to me unless the device model has once again changed
>> silently.  When I wrote this code &dev->dev was a device allocated
>> as part of the netdevice and the parent is the pci (or whatever) device
>> that has the node information.
> 
> Correct, this change is completely bogus.

I've got a question from a network driver writer's perspective:  In
drivers which sit on top of a midlayer/ multi-protocol infrastructure,
should dev->dev.parent be the lowlevel's pci_dev.dev or the midlayer's
whatever_abstracted_dev.dev?

(Example:  eth1394 network driver sits on top of ieee1394 = FireWire
midlayer, this sits on top of ohci1394 = PCI driver for FireWire
controllers.)

I guess it should be the lowlevel's pci_dev.dev, unless the midlayer
cares to set
  set_dev_node(&midlayer_dev.dev, dev_to_node(midlayer_dev.dev.parent));

And either way, for full effect of NUMA awareness in the highlevel
network driver, the midlayer should be NUMA aware too...
-- 
Stefan Richter
-=====-=-=== -=== --=--
http://arcgraph.de/sr/
