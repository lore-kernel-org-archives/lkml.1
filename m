Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbXEIO7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbXEIO7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbXEIO7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:59:11 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:25565 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXEIO7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=s86wXYnKNFPAA0l6CdlH5CsSTnnFpiEL/Jop7f18NC1XEa2QNXjumpYUwu7wJl0bUWEp2k6zt36QRdi5uPDu9WMJq6ACw5jngXSJD3oOU5W91mpVqPVJ/LQb3evVIiokCwmiotOgD5yHW/Qpx4+EsEqLKrZWAAzG4Rksi6yQVHU=
Message-ID: <4641E1AF.9060201@gmail.com>
Date: Wed, 09 May 2007 16:58:55 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       maneesh@in.ibm.com,
       "cornelia.huck@de.ibm.com >> Cornelia Huck" 
	<cornelia.huck@de.ibm.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel
 bug 8198)
References: <691707.19263.qm@web52910.mail.re2.yahoo.com>	 <4641D6A2.8070406@gmail.com> <d120d5000705090735o65591855yea6649d725fabb13@mail.gmail.com>
In-Reply-To: <d120d5000705090735o65591855yea6649d725fabb13@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------060005040408070909020407"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060005040408070909020407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dmitry Torokhov wrote:
>> As written above, I think it's better to risk module unload / sysfs race
>> than keeping the current sysfs deletion / open race.  What do you guys
>> think?
>>
> 
> How about embedding struct attribute fro devt into struct
> [class_]device for now? It is not too big and device is still going to
> be pinned into memory while there are sysfs users... I don't like
> fattening of device structures but leaks and/or oopses are worse in my
> book.

Right, your book is apparently much better than mine.  Actually, we can
just free devt_attr in device_release().  Looking at the code, class
device is already doing it that way, so here's the full-assed fix.
Chris, can you please test the attached patch?

Thanks.

-- 
tejun

--------------060005040408070909020407
Content-Type: text/plain;
 name="fix-devt_attr-release"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-devt_attr-release"

---
 drivers/base/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: tree0/drivers/base/core.c
===================================================================
--- tree0.orig/drivers/base/core.c
+++ tree0/drivers/base/core.c
@@ -93,6 +93,9 @@ static void device_release(struct kobjec
 {
 	struct device * dev = to_dev(kobj);
 
+	kfree(dev->devt_attr);
+	dev->devt_attr = NULL;
+
 	if (dev->release)
 		dev->release(dev);
 	else if (dev->class && dev->class->dev_release)
@@ -650,10 +653,8 @@ void device_del(struct device * dev)
 
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (dev->devt_attr) {
+	if (dev->devt_attr)
 		device_remove_file(dev, dev->devt_attr);
-		kfree(dev->devt_attr);
-	}
 	if (dev->class) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		/* If this is not a "fake" compatible device, remove the

--------------060005040408070909020407--
