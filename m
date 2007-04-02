Return-Path: <linux-kernel-owner+w=401wt.eu-S965736AbXDBTbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736AbXDBTbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965741AbXDBTbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:31:11 -0400
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:34895 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965736AbXDBTbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:31:10 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 15:31:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nk0NgQ+og/Xkihp/tOVpcwRNuXra3vlr9okBcCQg1CY/FGSYjpIo33PoxrI3cStKTkw4wLGceV36Pk+TGSFW2Tw92YKEj/KzZHcogdqf5l7wrnkyI1EiHEl2qV+4EGG5b8XydYbBVvqqQ6ksXlzKZMgJp5YJgsj9fFELui7tDN4=;
X-YMail-OSG: EJe0ww4VM1kw44M4b.LXTV7PzDa1NgK9WjrqChdX
Date: Mon, 2 Apr 2007 12:24:28 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
To: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
In-Reply-To: <460DD1B0.4080605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <875017.73166.qm@web31811.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> Cornelia Huck wrote:
> > On Sat, 31 Mar 2007 00:08:19 +0900,
> > Tejun Heo <htejun@gmail.com> wrote:
> > 
> >> (3) make sure all existing kobjects are released by module exit function.
> >>
> >> For example, let's say there is a hypothetical disk device /dev/dk0
> >> driven by a hypothetical driver mydrv.  /dev/dk0 is represented like the
> >> following in the sysfs tree.
> >>
> >> /sys/devices/pci0000:00/0000:00:1f.0/dk0/{myknob0,myknob1}
> >>
> >> Owner of both attrs myknob0 and myknob1 is mydrv and opening either
> >> increases the reference counts of dk0 and mydrv and closing does the
> >> opposite.
> >>
> >> * When there is no opener of either knob and the /dev/dk0 isn't used by
> >> anyone.  Reference count of dk0 is 1, mydrv 0.
> > 
> > Hm, but as long as dk0 is registered, it can be looked up and someone
> > could get a reference on it.
> 
> Yeah, exactly.  That's why any getting any kobject reference backed by a
> module must be accompanied by try_module_get().

Tejun,

This has always been the case.

By design, the kobject infrastructure is one such that allows for
different behavior implementations.  You could use it to accomplish
what you want and describe in your RFD, or you could use it to implement
what we have today or you could use it to implement completely different
(refcount) infrastructure.

    Luben


> 
> int mydrv_get_dk(struct dk *dk)
> {
> 	rc = try_module_get(mydrv);
> 	if (rc)
> 		return rc;
> 	kobject_get(&dk->kobj);
> 	return 0;
> }
> 
> >> * User issues rmmod mydrv.  As mydrv's reference count is zero, unload
> >> proceeds and mydrv's exit function is called.
> >>
> >> * mydrv's exit function looks like the following.
> >>
> >>   mydrv_exit()
> >>   {
> >> 	sysfs_remove_file(dk0, myknob0);
> >> 	sysfs_remove_file(dk1, myknob1);
> >> 	device_del(dk0);
> >> 	deinit controller;
> >> 	release all resources;
> >>   }
> >>
> >> The device_del(dk0) drops dk0's reference count to zero and its
> >> ->release is invoked immediately.
> > 
> > And here is the problem if someone else still has a reference. The
> > module will be unloaded, but ->release will not be called until the
> > "someone else" gives up the reference...
> 
> Exactly, in that case, module reference count must not be zero.  You and
> I are saying the same thing.  Why are we running in circle?
> 
> -- 
> tejun
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

