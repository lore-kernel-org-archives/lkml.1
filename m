Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXI3Sjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXI3Sjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 14:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXI3Sjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 14:39:47 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:20312 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXI3Sjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RKdoDP2B7vd4m63E9ZyKvGlHx0ZvfG9hRs9sLPmw74Tb4dNDCFxA67Uc7HIirfwHqxYRiHWyWRSwUNe7ikQLpuM780gHc69eYLMeeFdfE5cCTaMrABSO8NY1KiDto21GlkpfoZE0c1oXoGxAXukchm9aKe/B+9o9xSTVdY3+dxg=
Message-ID: <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
Date: Sun, 30 Sep 2007 20:39:44 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46FFDF64.1080005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
	 <46FB4CB3.3090004@garzik.org>
	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
	 <46FC1104.8080105@gmail.com>
	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFB412.20202@gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/07, Tejun Heo <htejun@gmail.com> wrote:
> Torsten Kaiser wrote:
> > What I find kind of interessing is, that while I got three different
> > error codes the cmd part of the output was always the same.
>
> That's NCQ write command.  You'll be using it a lot if you're rebuilding
> md5.

It's not rebuilding the RAID at that point.
If one drive fails, I reboot into a "safe" kernel, fix the RAID and
that way try the next boot with a clean RAID again.

The error happens when the RAID is initialized, might be the first
write into the superblock to mark it dirty/inuse that triggers the
error.

> It seems like something is going wrong with request DMA or sg
> mapping.  Maybe some change in block/*.[hc]?

The sg-chaining-patch stands out, but I have no conclusive proof that
it really is the cause.
As noted in this thread, a long time I thought that rc7 with the
sg-chaining-patch was safe, but one time it also showed the error.

> > It's not just 2.6.23-rc4-mm1. All -mm's after rc4 are broken for me.
> > Confirmed breakage on -rc4-mm1, -rc6-mm1 and -rc8-mm1. I'm just
> > narrowing on rc4-mm1 because that was the first version to break.
> >
> > I'm currently trying to bisect 2.6.23-rc4-mm1. Here is the current status:
>
> Have you tested 2.6.23-rc4 without mm patches?  It could be something
> introduced between -rc3 and 4.

Not directly, but I have 4 good boots with one part of the mm-patches.
So I would tend to say that mainline 2.6.23-rc4 does not have this
bug.

> > [the 2.6.23-rc4-mm1 series-file has 2013 lines]
> > Up to (incl.) x86_64-convert-to-clockevents.patch (line 747): 2 good boots
> > Up to (incl.) x86_64-cleanup-struct-irqaction-initializers-patch
> > (line779): 2 good boots
> > Up to (incl.) slub-optimize-cacheline-use-for-zeroing.patch (line
> > 1045): 1 failed
> > Up to (incl.) fix-discrepancy-between-vdso-based... (line1461): 1 good, 1 failed
> >
> > Next try: up to patch fs-remove-some-aop_truncated_page.patch

Looks more like this is OK too.

> > That means from the patches added to the rc4 variant of the mm-kernel
> > the following are remaining:
[snip]
> > memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
> > memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
> > memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
> > update-n_high_memory-node-state-for-memory-hotadd.patch
> > slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
> > slub-do-not-use-page-mapping.patch
> > slub-move-page-offset-to-kmem_cache_cpu-offset.patch
> > slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
> > slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
> > slub-optimize-cacheline-use-for-zeroing.patch
> >
> > But due to the unreliable nature of the bug, I can't be to sure about that.
>
> Yeah, that's what I'm worried about.  Bisection is extremely difficult
> if errors are intermittent and takes long time to reproduce.

Yes...

As for the remaining patches:
memoryless-nodes-*
Don't think so: I do have a NUMA system, but both nodes have memory.
flush-cache-before-*
Don't think so: No ia64 system, unchanged from rc3
# grouping pages by mobility patches
... no idee, but seem unchanged
maps2.*
Don't think that related...
remaining slub-* patches
Might be...

As for you printk:
>From two goot boots, I had not had any failures with it:
First one:
Sep 30 19:24:53 treogen [    3.810000] XXX sil24 cb=ffff810037ef0000
cb_dma=37ef0000
Sep 30 19:24:53 treogen [    3.820000] XXX sil24 cb=ffff810037f00000
cb_dma=37f00000
Second:
Sep 30 20:06:22 treogen [    3.820000] XXX sil24 cb=ffff810037f00000
cb_dma=37f00000
Sep 30 20:06:22 treogen [    3.830000] XXX sil24 cb=ffff810037f10000
cb_dma=37f10000

Torsten
