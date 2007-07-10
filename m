Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXGJAwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXGJAwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbXGJAwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:52:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40668 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760400AbXGJAwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:52:36 -0400
Date: Mon, 9 Jul 2007 17:52:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Greg KH <greg@kroah.com>
cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, akpm@linux-foundation.org, ak@suse.de,
       rientjes@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] try parent numa_node at first before using default
In-Reply-To: <20070710004416.GA6905@kroah.com>
Message-ID: <Pine.LNX.4.64.0707091751410.2269@schroedinger.engr.sgi.com>
References: <200707031835.l63IZo9K008197@imap1.linux-foundation.org>
 <200707031731.02456.yinghai.lu@sun.com> <20070710004416.GA6905@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Greg KH wrote:

> > @@ -547,6 +547,8 @@ static void klist_children_put(struct klist_node *n)
> >  
> >  void device_initialize(struct device *dev)
> >  {
> > +	int node;
> > +
> >  	kobj_set_kset_s(dev, devices_subsys);
> >  	kobject_init(&dev->kobj);
> >  	klist_init(&dev->klist_children, klist_children_get,
> > @@ -557,7 +559,9 @@ void device_initialize(struct device *dev)
> >  	spin_lock_init(&dev->devres_lock);
> >  	INIT_LIST_HEAD(&dev->devres_head);
> >  	device_init_wakeup(dev, 0);
> > -	set_dev_node(dev, -1);
> > +
> > +	node = dev->parent ? dev_to_node(dev->parent) : -1;
> > +	set_dev_node(dev, node);
> >  }
> 
> What is this going to give us?
> 
> Doesn't it mean that all devices will end up on the same node?

It means that the node for the device is the same as the parent device.
F.e. if the parent device is a bus that is connected to node 4 then all 
the devices hooked up to the bus are allocated on that node.
