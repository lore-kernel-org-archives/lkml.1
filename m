Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYIZMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYIZMmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYIZMmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:42:22 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48292 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbYIZMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:42:21 -0400
Date: Fri, 26 Sep 2008 21:42:15 +0900 (JST)
Message-Id: <20080926.214215.45417575.taka@valinux.co.jp>
To: vgoyal@redhat.com
Cc: ryov@valinux.co.jp, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       righi.andrea@gmail.com, jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080924145202.GC547@redhat.com>
References: <20080922143042.GA19222@redhat.com>
	<20080924.191803.100102323.taka@valinux.co.jp>
	<20080924145202.GC547@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > One additional issue with my scheme I just noticed is that I am putting
> > > bio-cgroup in rb-tree. If there are stacked devices then bio/requests from
> > > same cgroup can be at multiple levels of processing at same time. That
> > > would mean that a single cgroup needs to be in multiple rb-trees at the
> > > same time in various layers. So I might have to create a temporary object
> > > which can associate with cgroup and get rid of that object once I don't
> > > have the requests any more...
> > 
> > You mean each layer should have its rb-tree? Is it per device?
> > One lvm logical volume may probably consist from several physical
> > volumes, which will be shared with other logical volumes.
> > And some layers may split one bio into several bios.
> > I hardly can imagine how these structures will be.
> > 
> 
> Yes, one rb-tree per device, be it physical device or logical device
> (because there is one request queue associated per physical/logical block
> device).

No, logical block devices doesn't have any request queues and
they essentially won't block any bios unless it is impossible to
handle them at the moment. Device-mappers never touch any request queues.

> I was thinking of getting hold/hijack the bios as soon as they are
> submitted to the device using associated request function. So if there
> is a logical device built on top of two physical device, the associated
> bio copy or other logic should not even see the bio the moment it is 
> submitted to the deivce. It will see the bio only when it is released
> from associated rb-tree to them. Do you think this will not work? To me
> this is what dm-ioband is doing logically. The only difference is that it
> does this with the help of a separate request queue. 

I think it's easy to just make all logical device --- device mapper
device  --- and all physical device have their own bandwidth control
mechanism.
But I'm not clear how your algorithm works to control the bandwidth.
At which level are you going to guarantee the bandwidth, at the logical
volumes layer such as lvm or at the physical device layer?

Thanks,
Hirokazu Takahashi.

