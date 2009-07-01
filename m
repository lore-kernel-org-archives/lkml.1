Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZGARW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZGARW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZGARWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:22:15 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:53016 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754110AbZGARWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:22:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=N5JpjLipM2xwWu5RvjVkUA6CQ5NM+M6ac7GiAuLwU3FRyk16W9dLj7Db3KsL6szhur/9s+nZ/X7Kn8fzPF+9iClXOTuFo/Hc45u0rIH0vFfLy7s6uJE4ZSK5CsjetOjQ;
Date: Wed, 1 Jul 2009 10:22:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Alberto Gonzalez <alberto6674@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090701102214.352bfe72@jbarnes-g45>
In-Reply-To: <200907010909.03645.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
	<alpine.DEB.2.00.0906300445550.4758@skynet.skynet.ie>
	<20090630090835.5536a465@jbarnes-g45>
	<200907010909.03645.info@gnebu.es>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/1mRRSRdLUx_1//oMaYjXfcv"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/1mRRSRdLUx_1//oMaYjXfcv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 1 Jul 2009 09:09:03 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Tuesday 30 June 2009 18:08:35 Jesse Barnes wrote:
> > On Tue, 30 Jun 2009 04:46:38 +0100 (IST)
> >
> > Dave Airlie <airlied@linux.ie> wrote:
> > > > On Sunday 28 June 2009 16:28:44 Kay Sievers wrote:
> > > > > If there isn't something else running which acts on uevents
> > > > > that trigger drm events, which I wouldn't expect, it seems
> > > > > like a drm kernel problem.
> > > >
> > > > Ok, thanks for looking at it. I'll sum up the problem for DRM
> > > > people:
> > > >
> > > > The problem started after upgrading to 2.6.30. At some point,
> > > > udevd starts to use a lot of CPU time. It happens randomly, but
> > > > it seems easier to trigger when running something graphics
> > > > intensive (glxgears, gtkperf, tuxracer..).
> > > >
> > > > Killing udevd and starting it with the --debug switch throws up
> > > > this when the problem starts:
> > >
> > > I've added jbarnes to the list,
> > >
> > > Jesses are we sending events yet? what for?
> >
> > Right now we just send uevents at hotplug time, so maybe one of our
> > hotplug interrupt bits is getting stuck, resulting in a continuous
> > stream of events as we generate other interrupts (which would happen
> > when running 3D apps for example).
> >
> > There's a DRM_DEBUG statement in drivers/gpu/drm/i915/i915_irq.c
> > under the if (I915_HAS_HOTPLUG(dev)) { check, if you make it into
> > DRM_ERROR we can see which one is getting stuck.
> 
> I am afraid I'll need a bit more guidance here. I guess this means
> patching the kernel. Would it be possible to get a test patch against
> 2.6.30? And then after patching and compiling, how should I debug it?

Here's a patch against git, it should apply to 2.6.30 though I think.

I'll just need your dmesg output from when the problem is occurring (if
I'm right this patch should flood your logs).

-- 
Jesse Barnes, Intel Open Source Technology Center


--MP_/1mRRSRdLUx_1//oMaYjXfcv
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=i915-hotplug-error.patch

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 228546f..6c31408 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -353,7 +353,7 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 		    (iir & I915_DISPLAY_PORT_INTERRUPT)) {
 			u32 hotplug_status = I915_READ(PORT_HOTPLUG_STAT);
 
-			DRM_DEBUG("hotplug event received, stat 0x%08x\n",
+			DRM_ERROR("hotplug event received, stat 0x%08x\n",
 				  hotplug_status);
 			if (hotplug_status & dev_priv->hotplug_supported_mask)
 				schedule_work(&dev_priv->hotplug_work);

--MP_/1mRRSRdLUx_1//oMaYjXfcv--
