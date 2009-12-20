Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbZLTRx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbZLTRx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZLTRx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:53:27 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42628 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZLTRx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BTrnwRcqD3sTmt6pj9aiNL3SlHGGGmzuLJzNW5XjfJqMzZIsXQy3K2Z4je5m5efxSR
         f98YFjAg9dyw0aeUhfhanAVQsJzvXsaBnQLNkr75Rig9O4SVCCq8l9t5Hy6jx5eMQ0VK
         BbHXGGbdoltK5XRWIOKGRYInhgWKjTudxkzpk=
MIME-Version: 1.0
In-Reply-To: <64bb37e0912191154n4a7ea5benbb3da57f1aabdbe6@mail.gmail.com>
References: <alpine.LFD.2.00.0912171745160.15740@localhost.localdomain>
	 <64bb37e0912191154n4a7ea5benbb3da57f1aabdbe6@mail.gmail.com>
Date: Sun, 20 Dec 2009 18:53:24 +0100
Message-ID: <64bb37e0912200953j2046a935n2f9ecd2cdfed780f@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc1
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 8:54 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> [    5.061998] EDAC MC: Ver: 2.1.0 Dec 18 2009
> [    5.062186] EDAC amd64_edac:  Ver: 3.3.0 Dec 18 2009
> [    5.062235] EDAC amd64: ECC is enabled by BIOS.
> [    5.062297] EDAC amd64: ECC is enabled by BIOS.
> [    5.128332] EDAC MC: Rev F or later detected
> [    5.134186] EDAC amd64: amd64_read_mc_registers: error reading F2x190.
> [    5.142290] EDAC amd64: amd64_read_mc_registers: error reading F2x194.
> [    5.150355] EDAC MC: DCT0 chip selects:
> [    5.150357] EDAC MC:  0:   512MB 1:   512MB
> [    5.150358] EDAC MC:  2:     0MB 3:     0MB
> [    5.150361] EDAC MC:  4:     0MB 5:     0MB
> [    5.150362] EDAC MC:  6:     0MB 7:     0MB
> [    5.150519] EDAC MC0: Giving out device to 'amd64_edac' 'RevF': DEV
> 0000:00:18.2
> [    5.150522] EDAC MC: Rev F or later detected
> [    5.150530] EDAC amd64: amd64_read_mc_registers: error reading F2x190.
> [    5.150532] EDAC amd64: amd64_read_mc_registers: error reading F2x194.
> [    5.150533] EDAC MC: DCT0 chip selects:
> [    5.150535] EDAC MC:  0:   512MB 1:   512MB
> [    5.150536] EDAC MC:  2:     0MB 3:     0MB
> [    5.150537] EDAC MC:  4:     0MB 5:     0MB
> [    5.150539] EDAC MC:  6:     0MB 7:     0MB
> [    5.150664] EDAC MC1: Giving out device to 'amd64_edac' 'RevF': DEV
> 0000:00:19.2
> [    5.150742] EDAC PCI0: Giving out device to module 'amd64_edac'
> controller 'EDAC PCI
>  controller': DEV '0000:00:18.2' (POLLED)
>
> The system has 4x 1GB RAM sticks (2 on each CPU).

After reading the code in drivers/edac/amd64_edac.c and the
documentation in the AMD reference doc (#32559, I have Rev. 3.08) the
bug is, that the current code does not try to differentiate between
the 64bit and the 128bit mode.
In the doc the sizes for the 64bit mode in table 10, section 4.5.8.1
are identical to the table ddr2_dbam in amd64_edac.c.
But for the 128bit mode the table 11 should be used, there the sizes
are doubled.

The code uses the bit 11 (named F10_WIDTH_128 in amd64_edac.h) of the
lower DRAM configuration register to determine the number of channels
in k8_early_channel_count(), but this is not used in
amd64_debug_display_dimm_sizes()

> And there is no line like 'EDAC PCI0' for the DRAM controller of the
> second CPU (19.2). Is that normal?

amd64_edac_init() calls amd64_init_2nd_stage() for each northbrigde,
but amd64_setup_pci_device() only once.

But from looking at the code, I can't see if a second device is needed or not.

Torsten
