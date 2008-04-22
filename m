Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYDVUd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYDVUd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYDVUdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:33:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYDVUdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:33:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: device_pm_add (was: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff)
Date: Tue, 22 Apr 2008 22:34:18 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, herbert@gondor.apana.org.au,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com> <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804222234.19936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of April 2008, Linus Torvalds wrote:
> 
> On Tue, 22 Apr 2008, Zdenek Kabelac wrote:
> > 
> > Unsure how it is related to my orginal Oops post - but now when I've
> > debug pagealloc enabled this appeared in my log after resume - should
> > I open new bug for this - or could this be part of the problem I've
> > experienced later?
> > 
> > (Note - now I'm running commit: 8a81f2738f10ca817c975cec893aa58497e873b2
> > 
> >  sd 0:0:0:0: [sda] Starting disk
> >  mmc0: new SD card at address 5a61
> >  mmc mmc0:5a61: parent mmc0 is sleeping, will not add
> >  ------------[ cut here ]------------
> >  WARNING: at drivers/base/power/main.c:78 device_pm_add+0x6c/0xf0()
> 
> This is unrelated to the other issue, I think.
> 
> Your warning comes from commit 58aca23226a19983571bd3b65167521fc64f5869, 
> which admittedly looks like total crap.

Well, I'm sorry that you think so.

> Rafael, what's the point of that commit?

More or less as stated in the changelog.  If we register a child of a sleeping
device, the child ends up on dpm_active before the parent, so the ordering will
be wrong during the next suspend.

That was discussed on linux-pm, mainly with Alan Stern.

> I read the commit message, but I can't make myself agree with the commit 
> code itself. If it's a "checking that the order is correct" thing, it 
> should be a warning, but not change the actual _action_ of the code.

That is easy to change.  Please find appended a patch for that.

> Because the commit refused to add the device, it is also then the direct 
> reason for the oops you get later, as far as I can tell:
> 
> >  BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> >  IP: [klist_del+29/128] klist_del+0x1d/0x80
> >  PGD 0
> >  Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> >  CPU 0
> >  Call Trace:
> >   [bus_remove_device+158/208] bus_remove_device+0x9e/0xd0
> >   [device_add+1358/1376] device_add+0x54e/0x560

There is a bug in device_add() that IMO can be fixed this way:

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -820,11 +820,11 @@ int device_add(struct device *dev)
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
+	bus_attach_device(dev);
 	error = device_pm_add(dev);
 	if (error)
 		goto PMError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
-	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
The problem is that bus_remove_device() assumes bus_attach_device() to have
run, AFAICS.

> So I would suggest reverting that commit, or at least just making it a 
> warning (while still registering the device).

Are drivers supposed to register children of suspended devices?  That doesn't
make much sense IMO ...

Thanks,
Rafael


Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -76,12 +76,10 @@ int device_pm_add(struct device *dev)
 		else
 			dev_warn(dev, "devices are sleeping, will not add\n");
 		WARN_ON(true);
-		error = -EBUSY;
-	} else {
-		error = dpm_sysfs_add(dev);
-		if (!error)
-			list_add_tail(&dev->power.entry, &dpm_active);
 	}
+	error = dpm_sysfs_add(dev);
+	if (!error)
+		list_add_tail(&dev->power.entry, &dpm_active);
 	mutex_unlock(&dpm_list_mtx);
 	return error;
 }
