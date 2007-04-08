Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXDHCzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXDHCzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 22:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXDHCzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 22:55:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:18434 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXDHCzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 22:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CDQNV4y7Kr4HmtE2U9KVIcexWeF2cCEUxQnTskFK2l6ikA2HgjKki07na0RnXNOmpfC8r8UvAdIxjVfMBz9Su4TjE4Ycokd3leRNpn5sthHJ0y7zAFbHRPs59p8jwQiLrrv9ByKFo7RqVmVTmu+6cIW+hp/F6hwcFwj+vo0sKU8=
Message-ID: <461859B1.2030506@gmail.com>
Date: Sun, 08 Apr 2007 11:55:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, hugh@veritas.com, cornelia.huck@de.ibm.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oliver@neukum.name>, maneesh@in.ibm.com,
       rpurdie@rpsys.net, James Bottomley <James.Bottomley@SteelEye.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
References: <Pine.LNX.4.44L0.0704071145370.31604-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704071145370.31604-100000@netrider.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Stern wrote:
>>   The problem here is that kobjec_get() in sysfs_schedule_callback()
>>   doesn't grab the module backing the kobject it's grabbing.  By the
>>   time (ss->func)(ss->kobj) runs, scsi_mod is already gone.
> 
> As the author of this routine, I wish you had included my name in your
> CC: list.  :-(

Sorry.  I'll from the next time.  I posted related patchset yesterday.
You can see it at...

  http://thread.gmane.org/gmane.linux.kernel/513334

> The problem here isn't exactly as you described.  scsi_mod needs to be
> pinned (1) because it is the owner of the kobject and hence will be
> called when the kobject is released, and (2) because it is the owner
> of the callback routine.  However this is just a detail; clearly the
> bug needs to be fixed.
> 
> One possibility would be to have scsi_mod's exit_scsi() routine call
> flush_scheduled_work().  Another would be to add such a call in
> sys_delete_module().  Neither of these is attractive.  They would add
> overhead when it's not needed, and they would deadlock if a workqueue
> routine tried to unload a module.
> 
> On balance, the patch below seems better.  Do you agree?

Agreed.  Grabbing module on function schedule should fix the problem.

> With regard to your analysis of lifetime issues, there is a whole
> aspect you did not mention.  A basic assumption of the refcounting
> approach is that once X has a reference to Y, X can freely access and
> use Y as much as it wants until it drops the reference.
> 
> However this is not true when X is a device driver and Y is a device
> structure.  Drivers can be unbound from devices.  If X has been
> unbound from Y then it must not access Y again, no matter how many
> references it possesses.  After all, some other driver may have bound
> to Y in the meantime; this other driver would not appreciate the
> interference.
> 
> Just as bad, if Y represents a hot-pluggable device then some other
> device may have been plugged in and may be using Y's old address.  We
> don't want X sending commands to a new device, thinking that it is Y!
> 
> The complications caused by this requirement affect both the subsystem
> code and device drivers.  Drivers must synchronize their release()
> methods with every action they take -- and refcounts cannot provide
> synchronization.
> 
> A similar problem afflicts the char-device subsystem, and here even
> less care has been taken to address the issues.  The race between
> open() and unregister() is resolved in many places by relying on the
> BKL!
> 
> We should be able to make things better and easier than they are.
> Orphaning open sysfs files was a move in this direction.  But I doubt
> they will ever become truly simple and clear.

Yeap, you're right.  My goal is make driver detach point the automatic
final synchronization point such that after the driver unregisters
itself from all the upper layers including sysfs, it's guaranteed that
there's no user left to the driver or the device it was driving.  Taking
sysfs out of the lifetime equation is a big step toward this goal.
Converting all subsystems and upper layers to immediately disconnect
from the device on driver detach would take some time but I don't think
it will be too difficult.

Thanks.

-- 
tejun
