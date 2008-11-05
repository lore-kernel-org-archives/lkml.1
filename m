Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbYKEULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbYKEULU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYKEULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:11:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756314AbYKEULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:11:05 -0500
Date: Wed, 5 Nov 2008 12:10:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kay.sievers@vrfy.org, folkert@vanheusden.com, jacmet@sunsite.dk,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: bdi: register sysfs bdi device only once per queue
Message-Id: <20081105121015.75f497d1.akpm@linux-foundation.org>
In-Reply-To: <1225728530.7803.1630.camel@twins>
References: <1225727635.6009.9.camel@linux>
	<1225728530.7803.1630.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 17:08:50 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2008-11-03 at 16:53 +0100, Kay Sievers wrote:
> > Andrew, can you pick this up this please?
> > 
> > Thanks,
> > Kay
> > 
> > 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: bdi: register sysfs bdi device only once per queue
> > 
> > Devices which share the same queue, like floppies and mtd devices,
> > get registered multiple times in the bdi interface, but bdi accounts
> > only the last registered device of the devices sharing one queue.
> 
> David, is there any reason the mtd devices do this?

[tap tap - is this thing turned on?]

> > On remove, all earlier registered devices leak, stay around in
> > sysfs, and cause "duplicate filename" errors if the devices are
> > re-created.
> > 
> > This prevents the creation of multiple bdi interfaces per queue,
> > and the bdi device will carry the dev_t name of the block device
> > which is the first one registered, of the pool of devices using
> > the same queue.
> > 
> > Tested-By: Peter Korsgaard <jacmet@sunsite.dk>
> > Acked-By: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> > ---
> > 
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index f2e574d..e6676e5 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
> >  	int ret = 0;
> >  	struct device *dev;
> >  
> > +	if (bdi->dev)
> > +		goto exit;
> > +
> >  	va_start(args, fmt);
> >  	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
> >  	va_end(args);
> 
> Would it make sense to make it print something like, please fix me?

Yes, I think it would.

--- a/mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue-fix
+++ a/mm/backing-dev.c
@@ -176,7 +176,7 @@ int bdi_register(struct backing_dev_info
 	int ret = 0;
 	struct device *dev;
 
-	if (bdi->dev)
+	if (WARN_ON(bdi->dev))
 		goto exit;
 
 	va_start(args, fmt);
_


It's a bit cheeky to add a known-to-trigger WARN_ON into -rc4 but if we
don't do this then the issue will just get swept under the carpet.

