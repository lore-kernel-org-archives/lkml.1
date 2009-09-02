Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZIBE0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZIBE0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZIBE0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:26:21 -0400
Received: from mail-yx0-f181.google.com ([209.85.210.181]:62720 "EHLO
	mail-yx0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZIBE0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x/8R0Fk/aNKLl5CpkwKq2htWCk8W4ueBNcfl04BgUDLs2ZFdWFTeg4IcOgv+64JMUJ
         J+17EJ7pBUc/sEchjf2nugFBPmR4FZNyilUfaB8gHwTjlXVuGNO0ACmQ1XOZhuH0jGK/
         NSfJBya+itIBe3/Xkg8TZGD44Jn7+sShfmaWg=
Message-ID: <4A9DF3E9.9090309@gmail.com>
Date: Tue, 01 Sep 2009 22:26:17 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Raphael Manfredi <Raphael_Manfredi@pobox.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
References: <6661.1251822466@nice.ram.loc>
In-Reply-To: <6661.1251822466@nice.ram.loc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2009 10:27 AM, Raphael Manfredi wrote:
> Since I have switched to 2.6.x two years ago, I've been experiencing weird
> IDE lockups that I did not have when I was running 2.4.x, on the exact same
> hardware.
>
> What happens is that when I launch a SMART long test on /dev/hda, I get the
> following messages on the netconsole:
>
> hda: lost interrupt
> hda: ide_dma_sff_timer_expiry: DMA status (0x61)
> hda: DMA timeout error
>
> followed by a hard lockup.
>
> I've added traces to understand what is happening, but I find them weird,
> and my lack of IDE expertise shows.  Here's the netconsole ooutput from
> the initial "lost interrupt" incident to the lockup:
>
> -- entering ide_timer_expiry() --
> hda: in ide_timer_expiry, expiry = 0x00000000
> hda: drive->waiting_for_dma = 0
> hda: hwif->ack_intr = 0x00000000
> hda: hwif->handler = 0xc022fb08<task_no_data_intr>
> hda: request queue is not empty
> --- entering drive_is_ready() ---
> hda: reading alt status
> hda: drive_is_ready: stat = -/ATA_DRDY/-/-/-
> --- leaving drive_is_ready() ---
> hda: lost interrupt
> --- entering task_no_data_intr() ---
> hda: entering task_no_data_intr
> hda: task_no_data_intr: stat = -/ATA_DRDY/-/-/-
> --- leaving task_no_data_intr() ---
> hda: startstop = "stopped"
> hda: exiting from ide_timer_expiry, plug_device=1
> -- leaving ide_timer_expiry() --
>
> <a few secs later>
>
> -- entering ide_timer_expiry() --
> hda: in ide_timer_expiry, expiry = 0xc0233a94<ide_dma_sff_timer_expiry>
> hda: drive->waiting_for_dma = 1
> hda: hwif->ack_intr = 0x00000000
> hda: hwif->handler = 0xc023392c<ide_dma_intr>
> hda: request queue is not empty
> --- entering ide_timer_expiry() --
> hda: ide_dma_sff_timer_expiry: DMA status (0x61)
> --- leaving ide_timer_expiry() --
> hda: will be waiting (3000)
> -- leaving ide_timer_expiry() --
>
> <3 secs later>
>
> -- entering ide_timer_expiry() --
> hda: in ide_timer_expiry, expiry = 0x00000000
> hda: drive->waiting_for_dma = 1
> hda: hwif->ack_intr = 0x00000000
> hda: hwif->handler = 0xc023392c<ide_dma_intr>
> hda: request queue is not empty
> --- entering drive_is_ready() ---
> hda: drive waiting for DMA
> --- leaving drive_is_ready() ---
> --- entering ide_dma_timeout_retry() ---
> hda: entering ide_dma_timeout_retry
> hda: hwif->handler = 0x00000000
> hda: hwif->expiry = 0x00000000
> hda: DMA timeout error
> hda: ended DMA
> hda: unmapped command
> hda: reading status with "hwif->tp_ops->read_status(hwif)"
>
> [hard lockup, ALT-SysRq is not responding]
>
> Here is what I find weird: initially, when ide_timer_expiry() is called,
> the drive is not waiting for a DMA, and indeed task_no_data_intr() is
> called.  Processing there leads to the call of ide_plug_device(), which
> enqueues a request.  But this time, this is a DMA request?  So that's not
> the request  that caused the initial "lost interrupt" condition?
>
> The whole "rescue" chain highlighted above leads to a hang when the
> kernel tries to read the status register from the IDE interface.
>
> I'm looking for some hints as to what is happening here, how to further
> diagnose the problem, and find a possible workaround.  Currently, I cannot
> schedule weekly SMART long tests on my drives since this locks the machine
> up, but I've recently lost a RAID array because of corruption of some
> sectors that had been silently developping for too long...
>
> Can someone please suggest some course of action?

It's most likely a bug in the IDE code somewhere, but realistically the 
most effective course of action would likely be to switch from the old 
IDE drivers and use libata instead. The IDE code doesn't receive that 
much testing these days, and it's really hard to debug (as you've seen, 
the debugging output is rather atrocious).
