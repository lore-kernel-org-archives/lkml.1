Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYFPRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYFPRhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYFPRhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:37:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39924 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbYFPRhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:37:24 -0400
Date: Mon, 16 Jun 2008 12:37:21 -0500
From: Paul Jackson <pj@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616123721.bb9195e6.pj@sgi.com>
In-Reply-To: <48569D62.9050107@zytor.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
	<20080616032457.718f4d87.pj@sgi.com>
	<1213606435.12968.14.camel@caritas-dev.intel.com>
	<48568B56.7060307@zytor.com>
	<20080616113806.2ff4c1a4.pj@sgi.com>
	<48569D62.9050107@zytor.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa, replying to pj:
> >> Would you recommend doing this with code in arch/x86/kernel/head.c,
> >> that did not invoke reserve_ebda_region() if efi_enabled was set?
> 
> I disagree with it

Ok - that's clear.

So it would seem that I am getting conflicting advice.

One person recommends code that only makes this safety reservation of
the ebda region in the non-EFI case:

    if (!efi_enabled)
	reserve_ebda_region();

and the other recommends code that always makes this safety reservation,
and that handles the possible resulting overlap with the EFI memmap:

    if (!range_in_ebda_area(pmap, pmap + memmap.nr_map * memmap.desc_size))
	reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
	    "EFI memmap");

(The above code should be adjusted in light of Yinghai's suggestion
that it handle partial overlap.)

The resolution of this conflict might be easy, however.

I will readily accept that there exist some 'classic' PCs for which
we need to reserve a 'safe' ebda area.

The question to me is this.  Are there PCs which (1) need such a safety
reservation of an ebda area -and- (2) boot with EFI enabled?  I am not
asking if there -could- be (in the abstract, there certainly is no law
of government or physics prohibiting such).  Rather I am asking as a
practical matter if there is, or is likely to be, such PCs "in the wild."

The safety reservation of this ebda area is a hack.  As hacks go, it is
a rather gentle hack, but still it is a hack.  As such, it is to be
avoided unless there is a practical need.  Some non-efi old PCs have that
need - no debate there.

Should we perpeturate this (gentle) hack for EFI systems as well?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
