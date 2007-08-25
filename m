Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbXHYDk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbXHYDk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 23:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXHYDkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 23:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:53087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXHYDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 23:40:45 -0400
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
From: Kay Sievers <kay.sievers@vrfy.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070825030251.GA15827@Krystal>
References: <20070824224707.GA7275@Krystal>
	 <20070824161029.6236a5f4.akpm@linux-foundation.org>
	 <20070825001638.GB9811@Krystal>
	 <20070824174450.70337f4f.akpm@linux-foundation.org>
	 <20070825004640.GA21756@kroah.com>  <20070825030251.GA15827@Krystal>
Content-Type: text/plain
Date: Sat, 25 Aug 2007 05:44:43 +0200
Message-Id: <1188013483.2641.8.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+TJsIufqBtQYxNozLBTyIbLf3H5aKg+5lZOI+
 WQpALdOyyIqaGVXAVIXLfcvNB+Ix1LLujQ3it33qrujCBIsrqH
 VhmGiPnOEBzpsiPqh13I9FuwqusvjlY
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 23:02 -0400, Mathieu Desnoyers wrote:
> * Greg KH (greg@kroah.com) wrote:
> > On Fri, Aug 24, 2007 at 05:44:50PM -0700, Andrew Morton wrote:
> > > On Fri, 24 Aug 2007 20:16:38 -0400
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > > > On Fri, 24 Aug 2007 18:47:07 -0400
> > > > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > > > 
> > > > > > Hi Andrew,
> > > > > > 
> > > > > > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > > > > > you would have some ideas about what is causing this problem. I'll start
> > > > > > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > > > > > kobject_uevent_env.

> > > > > hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> > > > > much all of the fixes were in rc3-mm1 anyway.
> > > > > 
> > > > > I doubt if bisection will tell us a lot: it'll probably point at
> > > > > gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> > > > > 
> > > > > What we _would_ like to know is which sysfs file is being written to.  We
> > > > > used to have a debug patch to exactly address this problem but it got
> > > > > transferred into Greg's tree from whence it mysteriously disappeared.
> > > > > 
> > > > 
> > > > Ok, here it is:
> > > > 
> > > > filename :
> > > > 
> > > > /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
> > > 
> > > Bah.  I've never found a sane way of going from a sysfs pathname back to the
> > > code which implements that pathname :(
> > > 
> > > <greps the tree for '"rev"'>
> > > 
> > > <comes up with zilch>
> > 
> > It's a scsi file, as the above is a scsi device.  It's created in the
> > drivers/scsi/scsi_sysfs.c file.

> I think I am slowly getting there.. it looks like an off-by-one in
> lib/kobject_uevent.c: add_uevent_var
> 
> when testing the return value of vsnprintf
> 
> if (len + 1 >= (sizeof(env->buf) - env->buflen))
> 
> should be
> 
> if (len >= (sizeof(env->buf) - env->buflen))
> 
> And then the problem underneath is that the array is too short for some
> values.

That should be changed, yes. But we should not reach the end of the
buffer.

> Since the return value of add_uevent_var is always ignored (why?)

Because nobody added these checks, most of the callers check, some
don't. We should fix that step by step, sure.

> from its callers, fixing the off-by-one will just fail silently, which is
> almost worse.
> 
> I think we should find some better way of handling full static arrays.
> 
> And the bug is still there even if I fix these. So I'll continue my
> investigation.

Yeah, before these changes it was the environment buffer which got
corrupted, but seems nobody noticed it. Now it triggers BUG() if we run
into problems.

This needs a fix. It may be the reason for the too small buffer, you are
seeing.

Thanks,
Kay

--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -155,6 +155,7 @@ static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 			   sizeof(env->buf) - env->buflen);
 	if (len >= (sizeof(env->buf) - env->buflen))
 		return -ENOMEM;
+	env->buflen += len;
 	return 0;
 }
 

