Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbYD1Gu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbYD1Gu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYD1GuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:50:07 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:5345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753580AbYD1GuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RBSUkLL4d8whC58ettyYSyR+Sx+ttsiRJlp9gs4PANz7QOadEUMq4dx0bybMF1m5jSNfEGXyXC+8ozBFnNuhDLE8zQb3kVEPhh0itGwiFhKgsGCFbReWxyfvLV9U/R7BLTQAfhxuQSLBxWOHULahUQxJZVVUpvGDMwZaZcmEgho=
Message-ID: <86802c440804272350y33d69a32o5533dc01dc5a6c96@mail.gmail.com>
Date: Sun, 27 Apr 2008 23:50:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com
In-Reply-To: <20080426035614.a30afb17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801202256.48365.yinghai.lu@sun.com>
	 <20080122165125.GA17992@elte.hu>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 3:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 22 Jan 2008 16:23:20 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
>  > [PATCH] x86_32: trim memory by updating e820 v3
>  >
>  > when mtrr is not covering all e820 table, need to trim the ram, need to update e820
>  >
>  > reuse some code for x86_64
>  >
>  > here need to add early_get_cap and use it in early_cpu_detect, and move mtrr_bp_init early
>  >
>  > need Justine to test with his special system with bug bios.
>  >
>  > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>
>  Speaking of mtrr and e820....
>
>  Could someone please take a peek at
>  http://bugzilla.kernel.org/show_bug.cgi?id=10508 ?
>
>  For some reason we seem to have turned this:
>
>  [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
>  [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
>  [    0.000000]  BIOS-e820: 00000000bf6d0000 - 00000000bf6e3000 (ACPI NVS)
>  [    0.000000]  BIOS-e820: 00000000bf6e3000 - 00000000c0000000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
>  [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
>  [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
>
>  into this:
>
>  reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>  reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
>  reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>  reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>  reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>
>  which screws up the X server's attempt to map the video memory at
>  0xd0000000.

please try the patch at

http://lkml.org/lkml/2008/4/28/52

with mtrr_chunk_size=1g, and you should get

you should get
>  reg00: base=0x00000000 ( 0MB), size=2048MB: write-back, count=1
>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>  reg02: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>  reg03: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>  reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1

YH
YH
