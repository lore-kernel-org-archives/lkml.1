Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYACUKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYACUKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYACUKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:10:24 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:63380 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYACUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:10:23 -0500
Date: Thu, 03 Jan 2008 15:09:17 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [ofa-general] Re: list corruption on ib_srp load in v2.6.24-rc5
In-reply-to: <20080103173330T.tomof@acm.org>
To: FUJITA Tomonori <tomof@acm.org>
Cc: rdreier@cisco.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, general@lists.openfabrics.org
Message-id: <1199390957.7561.33.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <20071223014407L.tomof@acm.org>
 <1198689251.25003.2.camel@lap75545.ornl.gov> <adaprwkundh.fsf@cisco.com>
 <20080103173330T.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 17:30 +0900, FUJITA Tomonori wrote:
> On Wed, 02 Jan 2008 09:51:38 -0800
> Roland Dreier <rdreier@cisco.com> wrote:
> 
> >  > > Can you try this?
> >  > 
> >  > That patched oopsed in scsi_remove_host(), but reversing the order has
> >  > survived over 500 insert/probe/remove cycles.
> >  > 
> >  > Tested-by: David Dillow <dillowda@ornl.gov>
> >  > ---
> >  > diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> >  > index 950228f..77e8b90 100644
> >  > --- a/drivers/infiniband/ulp/srp/ib_srp.c
> >  > +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> >  > @@ -2054,6 +2054,7 @@ static void srp_remove_one(struct ib_device *device)
> >  >  		list_for_each_entry_safe(target, tmp_target,
> >  >  					 &host->target_list, list) {
> >  >  			scsi_remove_host(target->scsi_host);
> >  > +			srp_remove_host(target->scsi_host);
> >  >  			srp_disconnect_target(target);
> > 
> > Where do we stand on this?  What is the right place to put the
> > srp_remove_host?  Is there a bug somewhere else?
> 
> {sas|fc}_remove_host is called before scsi_remove_host. And in
> srp_remove_work(), we call srp_remove_host and then
> scsi_remove_host. ibmvscsi also calls them in that order.
> 
> I thought that I messed up something in srp_transport_class. But I
> can't figure out what's wrong. The above patch works and is unlikely
> to lead to critical problems so I'm fine with it for now.

I added some debugging printk's -- the first word is the function name:
printk(KERN_DEBUG "ib_srp:srp_remove_one %p %p\n", target,
			target->scsi_host);

printk(KERN_DEBUG "srp_rport_del %p %p %p %s\n", shost, rport, dev,
			dev->kobj.k_name);

printk(KERN_DEBUG "transport_remove_dev %p %d\n", dev,
			atomic_read(&dev->kobj.kref.refcount));

printk(KERN_DEBUG "transport_remove_classdev %p\n", dev);

printk(KERN_DEBUG "scsi_target_reap_usercontext %p %p %p\n", shost,
			starget, &starget->dev);


And the dmesg output:

ib_srp:srp_remove_one ffff810845498450 ffff810845498000
srp_rport_del ffff810845498000 ffff8108450d6000 ffff8108450d6000 port-3:1
transport_remove_dev ffff8108450d6000 4
transport_remove_classdev ffff8108450d6000
srp_rport_del done
srp_rport_del ffff810845498000 ffff810845123028 ffff810845123028 target3:0:0
transport_remove_dev ffff810845123028 9
srp_rport_del done
transport_remove_dev ffff81084557f920 6
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
transport_remove_dev ffff8108454f6920 6
sd 0:0:0:1: [sdb] Synchronizing SCSI cache
sd 0:0:0:1: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
scsi_target_reap_usercontext ffff810845498000 ffff810845123000 ffff810845123028
transport_remove_dev ffff810845123028 2


It looks like srp_rport_del() is getting called for a device object it
doesn't own -- target3:0:0. And when scsi_remove_host() goes to remove
it, it is already gone.

Adding

if (strncpy(dev->kobject.k_name, "port-", 5))
	return;

to the top of srp_rport_del() fixes the oops, so that seems to confirm
my hypothesis.

When scsi_remove_host() is called before srp_remove_host(), it removes
that "target3:0:0" entry, and all is happy, so the fix already posted
should be fine for 2.6.24, though we may want to fix up
srp_remove_work() as well -- I've not looked at it to see if it would
have the same problem.

As for a better fix, I'm not sure. I'll go out on a limb and bet the
other users of srp_remove_host() may have the same issue.
Dave


