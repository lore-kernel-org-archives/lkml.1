Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbXI3Rli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbXI3Rli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbXI3Rlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:41:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:13758 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbXI3Rl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pemZoSXUXX3IQBGNVKyAFff6tUaW+Yqc56xfT2cuuMlkDVqD3sJ72PjSeqbeEEGjHVZ6MVnjg6gU5QqpGFjF+maRGCIml0+CPRMPrUkj0Ril5j/kFCUKgAmFYDNzaFklGppDTy5Bt8LP7oper0QG2J+c2yVqywyNAHcf3+DIwdo=
Message-ID: <46FFDF64.1080005@gmail.com>
Date: Sun, 30 Sep 2007 10:39:48 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>	 <46FB4CB3.3090004@garzik.org>	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>	 <46FC1104.8080105@gmail.com>	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>	 <46FFB412.20202@gmail.com> <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
In-Reply-To: <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> That boot ended in a minimal initrd environment that normally only
> starts the RAID5 and then opens contained encrypted real root.
> I was just able to push the output from dmesg through the serial link,
> but had no man pages to tell me about -s ...
> And that kind of error was until now a one-of-a-kind one. All other
> errors where not "internal error" but "timeout".
> But one time I had another SGT related error:
> Sep 11 19:19:24 treogen [   33.340000] ata1.00: exception Emask 0x20
> SAct 0x1 SErr 0x0 action 0x2
> Sep 11 19:19:24 treogen [   33.340000] ata1.00: irq_stat 0x00020002,
> PCI master abort while fetching SGT
> Sep 11 19:19:24 treogen [   33.340000] ata1.00: cmd
> 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> Sep 11 19:19:24 treogen [   33.340000]          res
> 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask 0x20 (host bus error)
> 
> What I find kind of interessing is, that while I got three different
> error codes the cmd part of the output was always the same.

That's NCQ write command.  You'll be using it a lot if you're rebuilding
md5.  It seems like something is going wrong with request DMA or sg
mapping.  Maybe some change in block/*.[hc]?

> It's not just 2.6.23-rc4-mm1. All -mm's after rc4 are broken for me.
> Confirmed breakage on -rc4-mm1, -rc6-mm1 and -rc8-mm1. I'm just
> narrowing on rc4-mm1 because that was the first version to break.
> 
> I'm currently trying to bisect 2.6.23-rc4-mm1. Here is the current status:

Have you tested 2.6.23-rc4 without mm patches?  It could be something
introduced between -rc3 and 4.

> [the 2.6.23-rc4-mm1 series-file has 2013 lines]
> Up to (incl.) x86_64-convert-to-clockevents.patch (line 747): 2 good boots
> Up to (incl.) x86_64-cleanup-struct-irqaction-initializers-patch
> (line779): 2 good boots
> Up to (incl.) slub-optimize-cacheline-use-for-zeroing.patch (line
> 1045): 1 failed
> Up to (incl.) fix-discrepancy-between-vdso-based... (line1461): 1 good, 1 failed
> 
> Next try: up to patch fs-remove-some-aop_truncated_page.patch
> 
> That means from the patches added to the rc4 variant of the mm-kernel
> the following are remaining:
> git-xfs-build-fix.patch
> enforce-noreplace-smp-in-alternative_instructions.patch
> paravirt-fix-preemptible-lazy-mode-bug.patch
> i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
> fix-the-max-path-calculation-in-radix-treec-update.patch
> mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
> introduce-write_begin-write_end-aops-fix2.patch
> implement-simple-fs-aops-fix.patch
> ext2-convert-to-new-aops-fix2.patch
> ext3-convert-to-new-aops-fix-fix.patch
> ext4-convert-to-new-aops-fix-fix.patch
> gfs2-convert-to-new-aops-fix.patch
> reiserfs-convert-to-new-aops-fix2.patch
> hostfs-convert-to-new-aops-fix-fix.patch
> ufs-convert-to-new-aops-fix2.patch
> sysv-convert-to-new-aops-fix2.patch
> minix-convert-to-new-aops-fix2.patch
> affs-convert-to-new-aops-fix-fix.patch
> memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
> memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
> update-n_high_memory-node-state-for-memory-hotadd.patch
> slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
> slub-do-not-use-page-mapping.patch
> slub-move-page-offset-to-kmem_cache_cpu-offset.patch
> slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
> slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
> slub-optimize-cacheline-use-for-zeroing.patch
> 
> But due to the unreliable nature of the bug, I can't be to sure about that.

Yeah, that's what I'm worried about.  Bisection is extremely difficult
if errors are intermittent and takes long time to reproduce.

> Next version is compiled, now again switching the PC off for an hour...

Thanks a lot.  Much appreciated.

-- 
tejun
