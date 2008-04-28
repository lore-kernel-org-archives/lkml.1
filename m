Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbYD1Go1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbYD1Go1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbYD1GoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:44:19 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:2562 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756338AbYD1GoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:44:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fip7Xr0FkgFS5FDbAcZ15g61Zsvum9eWbJEi/qGng1RXXMms+LZktag9FmjFJ4Q0NiohP4Un0LWCHl1988HnkW4lEsYpKizTc77hgx231zRjL2C6WDKqMUZyvM9fN59IXiFqH0wyl0DcsbiV0r4c1l1Q+ZYpOrXTACS31LfC7rE=
Message-ID: <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>
Date: Sun, 27 Apr 2008 23:44:17 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <48132665.8050202@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801202256.48365.yinghai.lu@sun.com>
	 <20080122165125.GA17992@elte.hu>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 5:56 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>
> Andrew Morton wrote:
>  > On Tue, 22 Jan 2008 16:23:20 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>  >
>  >> [PATCH] x86_32: trim memory by updating e820 v3
>  >>
>  >> when mtrr is not covering all e820 table, need to trim the ram, need to update e820
>  >>
>  >> reuse some code for x86_64
>  >>
>  >> here need to add early_get_cap and use it in early_cpu_detect, and move mtrr_bp_init early
>  >>
>  >> need Justine to test with his special system with bug bios.
>  >>
>  >> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>  >
>  > Speaking of mtrr and e820....
>  >
>  > Could someone please take a peek at
>  > http://bugzilla.kernel.org/show_bug.cgi?id=10508 ?
>  >
>  > For some reason we seem to have turned this:
>  >
>  > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  > [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
>  > [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
>  > [    0.000000]  BIOS-e820: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
>  > [    0.000000]  BIOS-e820: 00000000bf6e3000 - 00000000c0000000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  > [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
>  > [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
>  >
>  > into this:
>  >
>  > reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>  > reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
>  > reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>  > reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>  > reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>  >
>  > which screws up the X server's attempt to map the video memory at
>  > 0xd0000000.
>
>  I see that on my box with ASUS P5E-VM DO and 4G RAM.
>  It has an Q35 intel chipset and the intel card is set to use 256MB in BIOS.
>
>  I tested 2.6.{24*,25,25-next,25-latest-git} 32/64 bit.
>
>  Also I get the mtrr type mismatch message on 32 and 64 bit kernels.
>
>  ...
>
>  [    0.000000] BIOS-provided physical RAM map:
>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
>  [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf550000 (usable)
>  [    0.000000]  BIOS-e820: 00000000cf550000 - 00000000cf55e000 (ACPI data)
>  [    0.000000]  BIOS-e820: 00000000cf55e000 - 00000000cf5e0000 (ACPI NVS)
>  [    0.000000]  BIOS-e820: 00000000cf5e0000 - 00000000cf600000 (reserved)
>
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  [    0.000000]  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
>  ...
>
>  cat /proc/mtrr :
>
>  reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>  reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>  reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>  reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>  reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>  reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>  reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1

please try the patch at

http://lkml.org/lkml/2008/4/28/52

with mtrr_chunk_size=1g

YH
