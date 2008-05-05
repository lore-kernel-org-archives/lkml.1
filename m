Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYEERsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYEERsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYEERsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:48:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:31107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbYEERsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,438,1204531200"; 
   d="scan'208";a="278068965"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Mon, 5 May 2008 10:45:30 -0700
User-Agent: KMail/1.9.9
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <200805022122.03576.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl>
In-Reply-To: <200805051932.41827.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7e0HIj0cbf+6WGt"
Message-Id: <200805051045.31026.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7e0HIj0cbf+6WGt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, May 05, 2008 10:32 am Frans Pop wrote:
> Sigh. This is going to get complex...
>
> On Monday 05 May 2008, Jesse Barnes wrote:
> > > > If so, it might not be a PAT issue but just a different memory layout
> > > > or something (and therefore it would really just be a cosmetic bug in
> > > > the X driver).
> > >
> > > The artifacts may not be a PAT issue directly, but it is a clear
> > > regression for me as I currently have a nice clean screen when X shuts
> > > down. I'm also 100% sure that it is caused by enabling PAT. A kernel
> > > with same config and only PAT disabled does not show the artifacts.
> > >
> > > Would you like me to file a bug against X for these artifacts?
> > > If so, against what component? The i810 driver or the server?
> >
> > I suspect an i810 driver bug is being uncovered here, since we do have
> > transient VT switch corruption on some other platforms (we're just
> > exposing our chip reprogramming on the screen, rather than keeping it off
> > the whole time).  But there could also be something PAT specific going
> > on, I'll have to walk through those code paths...
>
> I suspect it could be vesafb/fbcon related instead. Normally I boot my
> system with 'quiet vga=791', i.e. with vesafb. I then see the artifacts.
>
> When I boot without 'vga=791', I hit another, unrelated regression (which
> I'll report separately) [1].
>
> When I boot with 'video=vfb:off', I do _not_ get the artifacts when X
> exits.

Ahhh, I missed that part of your config.  That could definitely have an effect 
on things...  You'll probably want something like the attached (there are 
other places in the fb layer that want similar treatment, iirc, maybe 
fb_pgprotect?).

> Note that the "expected mapping type" errors remain the same both with and
> without framebuffer console.
>
> > Oh the messages should be removed or somehow minimized, I agree.  I'm
> > just not sure if the other bug is serious enough to block PAT by default
> > yet, but either way we should fix the bugs!
>
> OK. Thanks. Guess you've also seen "Xorg crash with xf86MapVidMem error"
> that turned out to be due to PAT:
> http://www.gossamer-threads.com/lists/linux/kernel/915300 ?

No, I hadn't seen that...  Venki/Ingo has that issue been fixed already?

Jesse

--Boundary-00=_7e0HIj0cbf+6WGt
Content-Type: text/x-diff;
  charset="utf-8";
  name="vesafb-use-wc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="vesafb-use-wc.patch"

diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index e16322d..95b26f1 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -286,7 +286,8 @@ static int __init vesafb_probe(struct platform_device *dev)
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
-	info->screen_base = ioremap(vesafb_fix.smem_start, vesafb_fix.smem_len);
+	info->screen_base = ioremap_wc(vesafb_fix.smem_start,
+				       vesafb_fix.smem_len);
 	if (!info->screen_base) {
 		printk(KERN_ERR
 		       "vesafb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",

--Boundary-00=_7e0HIj0cbf+6WGt--
