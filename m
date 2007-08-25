Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbXHYBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbXHYBWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXHYBWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:22:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXHYBWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:22:11 -0400
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070825004640.GA21756@kroah.com>
References: <20070824224707.GA7275@Krystal>
	 <20070824161029.6236a5f4.akpm@linux-foundation.org>
	 <20070825001638.GB9811@Krystal>
	 <20070824174450.70337f4f.akpm@linux-foundation.org>
	 <20070825004640.GA21756@kroah.com>
Content-Type: text/plain
Date: Sat, 25 Aug 2007 03:26:18 +0200
Message-Id: <1188005178.3548.49.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+izLg8RwbwaeA6FywfPikP9BwHGY/FVp48DOi
 88Dqd4SSOMrKfpsYzMknxtWJs7Q3VtiLxTfZtMHdtZ43RnCQZp
 lGGK/dTsgrtXpAwSnQQgAHP8NKIwVMc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 17:46 -0700, Greg KH wrote:
> On Fri, Aug 24, 2007 at 05:44:50PM -0700, Andrew Morton wrote:
> > On Fri, 24 Aug 2007 20:16:38 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > > On Fri, 24 Aug 2007 18:47:07 -0400
> > > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > > > > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > > > > you would have some ideas about what is causing this problem. I'll start
> > > > > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > > > > kobject_uevent_env.
> > > > 
> > > > hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> > > > much all of the fixes were in rc3-mm1 anyway.
> > > > 
> > > > I doubt if bisection will tell us a lot: it'll probably point at
> > > > gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> > > > 
> > > > What we _would_ like to know is which sysfs file is being written to.  We
> > > > used to have a debug patch to exactly address this problem but it got
> > > > transferred into Greg's tree from whence it mysteriously disappeared.
> > > > 
> > > 
> > > Ok, here it is:
> > > 
> > > filename :
> > > 
> > > /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
> > 
> > Bah.  I've never found a sane way of going from a sysfs pathname back to the
> > code which implements that pathname :(
> > 
> > <greps the tree for '"rev"'>
> > 
> > <comes up with zilch>
> 
> It's a scsi file, as the above is a scsi device.  It's created in the
> drivers/scsi/scsi_sysfs.c file.
> 
> Kay, did you miss this set of attributes somehow?

We didn't really touch anything in scsi. I expect it's something messing
around with the buffer values.

Mathieu,
does this fix it? If it does, we need to find what's going wrong, as it
probably just hides a bug somewhere.

Thanks,
Kay


--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -176,7 +176,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 		/* allocate message with the maximum possible size */
 		len = strlen(action_string) + strlen(devpath) + 2;
-		skb = alloc_skb(len + env->buflen, GFP_KERNEL);
+		skb = alloc_skb(len + UEVENT_BUFFER_SIZE, GFP_KERNEL);
 		if (skb) {
 			char *scratch;
 

