Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbXGKKzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbXGKKzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760498AbXGKKzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:55:23 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49442 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978AbXGKKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:55:22 -0400
Message-ID: <4694B702.2050507@s5r6.in-berlin.de>
Date: Wed, 11 Jul 2007 12:54:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] try parent numa_node at first before using default
References: <200707101641.17672.yinghai.lu@sun.com> <200707101652.31378.yinghai.lu@sun.com>
In-Reply-To: <200707101652.31378.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -547,6 +547,8 @@ static void klist_children_put(struct klist_node *n)
>  
>  void device_initialize(struct device *dev)
>  {
> +	int node;
> +
>  	kobj_set_kset_s(dev, devices_subsys);
>  	kobject_init(&dev->kobj);
>  	klist_init(&dev->klist_children, klist_children_get,
> @@ -557,7 +559,9 @@ void device_initialize(struct device *dev)
>  	spin_lock_init(&dev->devres_lock);
>  	INIT_LIST_HEAD(&dev->devres_head);
>  	device_init_wakeup(dev, 0);
> -	set_dev_node(dev, -1);
> +
> +	node = dev->parent ? dev_to_node(dev->parent) : -1;
> +	set_dev_node(dev, node);
>  }

Two remarks:

  - device_add() is perhaps a better place to do this.  Otherwise you
    had to change code like drivers/input/gameport/gameport.c::
    gameport_init_port() which sets the parent device *after* the
    call to device_initialize().

  - device_move() should update the device.node.
-- 
Stefan Richter
-=====-=-=== -=== -=-==
http://arcgraph.de/sr/
