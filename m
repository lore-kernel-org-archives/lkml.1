Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYKFQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYKFQvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYKFQvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:51:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYKFQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:51:39 -0500
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <20081106163957.GB7461@redhat.com>
References: <20081106153022.215696930@redhat.com>
	 <1225986593.7803.4688.camel@twins> <20081106160154.GA7461@redhat.com>
	 <1225988173.7803.4723.camel@twins>  <20081106163957.GB7461@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 17:52:07 +0100
Message-Id: <1225990327.7803.4776.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 11:39 -0500, Vivek Goyal wrote:
> On Thu, Nov 06, 2008 at 05:16:13PM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-11-06 at 11:01 -0500, Vivek Goyal wrote:
> > 
> > > > Does this still require I use dm, or does it also work on regular block
> > > > devices? Patch 4/4 isn't quite clear on this.
> > > 
> > > No. You don't have to use dm. It will simply work on regular devices. We
> > > shall have to put few lines of code for it to work on devices which don't
> > > make use of standard __make_request() function and provide their own
> > > make_request function. 
> > > 
> > > Hence for example, I have put that few lines of code so that it can work
> > > with dm device. I shall have to do something similar for md too.
> > > 
> > > Though, I am not very sure why do I need to do IO control on higher level
> > > devices. Will it be sufficient if we just control only bottom most
> > > physical block devices?
> > > 
> > > Anyway, this approach should work at any level.
> > 
> > Nice, although I would think only doing the higher level devices makes
> > more sense than only doing the leafs.
> > 
> 
> I thought that we should be doing any kind of resource management only at
> the level where there is actual contention for the resources.So in this case
> looks like only bottom most devices are slow and don't have infinite bandwidth
> hence the contention.(I am not taking into account the contention at 
> bus level or contention at interconnect level for external storage,
> assuming interconnect is not the bottleneck).
> 
> For example, lets say there is one linear device mapper device dm-0 on
> top of physical devices sda and sdb. Assuming two tasks in two different
> cgroups are reading two different files from deivce dm-0. Now if these
> files both fall on same physical device (either sda or sdb), then they
> will be contending for resources. But if files being read are on different
> physical deivces then practically there is no device contention (Even on
> the surface it might look like that dm-0 is being contended for). So if
> files are on different physical devices, IO controller will not know it.
> He will simply dispatch one group at a time and other device might remain
> idle.
> 
> Keeping that in mind I thought we will be able to make use of full
> available bandwidth if we do IO control only at bottom most device. Doing
> it at higher layer has potential of not making use of full available bandwidth.
> 
> > Is there any reason we cannot merge this with the regular io-scheduler
> > interface? afaik the only problem with doing group scheduling in the
> > io-schedulers is the stacked devices issue.
> 
> I think we should be able to merge it with regular io schedulers. Apart
> from stacked device issue, people also mentioned that it is so closely
> tied to IO schedulers that we will end up doing four implementations for
> four schedulers and that is not very good from maintenance perspective.
> 
> But I will spend more time in finding out if there is a common ground
> between schedulers so that a lot of common IO control code can be used
> in all the schedulers.
> 
> > 
> > Could we make the io-schedulers aware of this hierarchy?
> 
> You mean IO schedulers knowing that there is somebody above them doing
> proportional weight dispatching of bios? If yes, how would that help?

Well, take the slightly more elaborate example or a raid[56] setup. This
will need to sometimes issue multiple leaf level ios to satisfy one top
level io.

How are you going to attribute this fairly?

I don't think the issue of bandwidth availability like above will really
be an issue, if your stripe is set up symmetrically, the contention
should average out to both (all) disks in equal measures.

The only real issue I can see is with linear volumes, but those are
stupid anyway - non of the gains but all the risks.
