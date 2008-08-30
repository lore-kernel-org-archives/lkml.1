Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYH3VCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYH3VCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYH3VCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:02:17 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54440 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbYH3VCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:02:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=gxgLmRFhb/7Jz6No8xAls1HX4U2p1XaghogSdq6r0XHSVdQ1AF3gEBBtS7SsdB+X4MJQOOev0hqunRaqUtP0unG+M9iU0qhBt4NmpUAGppxiz5az4KmSqTg0v8yKhZDd;
Message-ID: <48B9B552.8060406@simon.arlott.org.uk>
Date: Sat, 30 Aug 2008 22:02:10 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org>
In-Reply-To: <20080830174516.GD1239@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/08 18:45, Matthew Wilcox wrote:
> On Sat, Aug 30, 2008 at 12:24:50PM -0500, James Bottomley wrote:
>> No, this is wrong.  By mandated standards the manufacturers are allowed
>> to calculate MB by dividing by 10^6.  This is a fiddle to allow them to
>> make their drives look slightly bigger.  However, we want the printed
>> information to match that written on the drive, so in this printk, we
>> use the manufacturer standard for calculation (and then do everything
>> else in bytes so we don't have to bother with it ever again).

It's unlikely to match what's on the drive, "1000204886016" isn't 1TB 
by any standard.

> I was looking at this code recently because it looks really bizarre when
> you create a half-petabyte filesystem:
> 
> $ sudo insmod drivers/ata/ata_ram.ko capacity=1099511627776 preallocate=0
> 
> [12095.028093] ata7.00: 1099511627776 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [12095.028093] ata7.00: configured for UDMA/133
> [12095.041915] scsi 7:0:0:0: Direct-Access     ATA      Linux RAM Drive 0.01 PQ: 0 ANSI: 5
> [12095.041915] sd 7:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
> [12095.041915] sd 7:0:0:0: [sdc] 1099511627776 512-byte hardware sectors (562949953 MB)
> [12095.041915] sd 7:0:0:0: [sdc] Write Protect is off
> [12095.041915] sd 7:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

This looks useful for testing this... do you have an updated version?

> 1. Avoiding 64-bit divisions is _so_ last decade.  We have
> linux/math64.h, we should use it.
> 
> 2. We should report in GB or TB when appropriate.  The exact definition
> of 'appropriate' is going to vary from person to person.  Might I
> suggest that we should report between two and four significant digits.
> eg 9543 MB is ok, 10543 MB should be 10 GB.

I've gone with five digits, it switches to GB at ~98GB, and to TB 
at ~98TB etc.

> 3. I hate myself for saying this ... but maybe we should be using the
> horrific MiB/GiB/TiB instead of MB/GB/TB.

Somehow this stuff got into net-tools (ifconfig) too, so I have a
patch to remove it from my systems.

> 4. I've been far too busy to write said patch.  Simon, would you mind
> doing the honours?

Sure, patch will follow this email... it can only go as far as 8192EB 
and then there's not enough space to store more than 2^64 512-byte 
sectors.

(And if you only modify drivers/scsi/sd.c, the kernel make system 
won't recompile sd.o!)

-- 
Simon Arlott



