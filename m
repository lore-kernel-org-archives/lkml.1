Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbXJASA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbXJASA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXJASAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:00:18 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:11611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbXJASAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JIBeBQ60wBCGdxH5o43fUFByhNJkOgunWZVwdBL6TRVfgpfs2sj3XAnem7v1KK7kwgcYOBd9TsZti0pEbvGzy0xvsF+7fVe34hU5he3hLGG7Cei6ncQmw/w0Ac4/pBKEdvDi1i5OYBBfGaG36nKVefm042MyuCo9c5aAX7TXE00=
Message-ID: <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
Date: Mon, 1 Oct 2007 20:00:14 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <46FB4CB3.3090004@garzik.org>
	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
	 <46FC1104.8080105@gmail.com>
	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFB412.20202@gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On 9/30/07, Tejun Heo <htejun@gmail.com> wrote:
> > Torsten Kaiser wrote:
> > > What I find kind of interessing is, that while I got three different
> > > error codes the cmd part of the output was always the same.
> >
> > That's NCQ write command.  You'll be using it a lot if you're rebuilding
> > md5.
>
> It's not rebuilding the RAID at that point.
> If one drive fails, I reboot into a "safe" kernel, fix the RAID and
> that way try the next boot with a clean RAID again.
>
> The error happens when the RAID is initialized, might be the first
> write into the superblock to mark it dirty/inuse that triggers the
> error.

To make that comment "cmd part of the output was always the same" more
clear: I did not only mean that the first (cmd-)byte was the same, but
the whole line:
cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out

I did find ATA_CMD_FPDMA_WRITE = 0x61in ata.h, but I don't find a good
hint for the 08 that follows. The interpretation XFER_PIO_0 = 0x08
seems wrong...

> > It seems like something is going wrong with request DMA or sg
> > mapping.  Maybe some change in block/*.[hc]?
>
> The sg-chaining-patch stands out, but I have no conclusive proof that
> it really is the cause.
> As noted in this thread, a long time I thought that rc7 with the
> sg-chaining-patch was safe, but one time it also showed the error.

If I look at what patches remain, it seems that some other (earlier)
patch that is new in 2.6.23-rc4-mm1 is the trigger, but it will only
fail together with a second patch.

> > > [the 2.6.23-rc4-mm1 series-file has 2013 lines]
> > > Up to (incl.) x86_64-convert-to-clockevents.patch (line 747): 2 good boots
> > > Up to (incl.) x86_64-cleanup-struct-irqaction-initializers-patch
> > > (line779): 2 good boots

Up to (incl.) fs-remove-some-aop_truncated_page.patch (line 956): 2 good boots
Up to (incl.) update-n_high_memory-node-state-for-memory-hotadd.patch (line978)
1 good boot, so I would tend to say that this patches are also OK, but
I will recheck this version.

Up to (incl.) maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
(line 1038): 1 failed

> > > Up to (incl.) slub-optimize-cacheline-use-for-zeroing.patch (line
> > > 1045): 1 failed
> > > Up to (incl.) fix-discrepancy-between-vdso-based... (line1461): 1 good, 1 failed

Updated list of remaining, new patches in rc4:

> > > That means from the patches added to the rc4 variant of the mm-kernel
> > > the following are remaining:
> [snip]
> > > memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
> > > memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
> > > memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
> > > update-n_high_memory-node-state-for-memory-hotadd.patch

And I think these are OK too.
So I think some earlier patch triggers bug together with one of these patches:

categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
make-swappiness-safer-to-use.patch
... these should not change any behaivor from there description

> flush-cache-before-*
> Don't think so: No ia64 system, unchanged from rc3

> # grouping pages by mobility patches
> ... no idee, but seem unchanged

> maps2.*
> Don't think that related...

Will continue to break this down...

> As for you printk:
> From two goot boots, I had not had any failures with it:
> First one:
> Sep 30 19:24:53 treogen [    3.810000] XXX sil24 cb=ffff810037ef0000
> cb_dma=37ef0000
> Sep 30 19:24:53 treogen [    3.820000] XXX sil24 cb=ffff810037f00000
> cb_dma=37f00000
> Second:
> Sep 30 20:06:22 treogen [    3.820000] XXX sil24 cb=ffff810037f00000
> cb_dma=37f00000
> Sep 30 20:06:22 treogen [    3.830000] XXX sil24 cb=ffff810037f10000
> cb_dma=37f10000

Next boot with this kernel was also good:
Oct  1 06:52:32 treogen [    3.740000] XXX sil24 cb=ffff810037f00000
cb_dma=37f00000
Oct  1 06:52:32 treogen [    3.750000] XXX sil24 cb=ffff810037f10000
cb_dma=37f10000

Next kernel (maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch)
Oct  1 18:07:09 treogen [    3.760000] XXX sil24 cb=ffff810005df0000
cb_dma=5df0000
Oct  1 18:07:09 treogen [    3.770000] XXX sil24 cb=ffff810005e00000
cb_dma=5e00000
-> failed, but when rebooting instead of a cold boot that kernel worked:
Oct  1 18:14:42 treogen [    3.800000] XXX sil24 cb=ffff810005df0000
cb_dma=5df0000
Oct  1 18:14:42 treogen [    3.810000] XXX sil24 cb=ffff810005e00000
cb_dma=5e00000
... same values, so thats not an indicator that trouble will follow.

Next kernel (update-n_high_memory-node-state-for-memory-hotadd.patch)
Oct  1 19:31:38 treogen [    3.840000] XXX sil24 cb=ffff81007fa60000
cb_dma=7fa60000
Oct  1 19:31:38 treogen [    3.850000] XXX sil24 cb=ffff810037f00000
cb_dma=37f00000
that was also a good boot.

Torsten
