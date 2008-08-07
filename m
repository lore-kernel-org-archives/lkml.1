Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYHGVlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYHGVlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYHGVlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:41:09 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35559 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbYHGVlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:41:08 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Zach Amsden <zach@vmware.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B6710.9000604@kernel.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 07 Aug 2008 14:41:05 -0700
Message-Id: <1218145265.23770.69.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 14:20 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> >
> > VMI relies on relocating the fixmap area to make room for the
> > hypervisor. These 2 commits started accessing the fixmap area's and
> > using them before VMI got a chance to check if it wants to relocate the
> > fixmap area. Once VMI got to the point of relocating the fixmap area's
> > it resulted in BUG's.
> >
> 
> Could you describe this in more detail? 

Hi Peter,

The first commit,
x86: use acpi_numa_init to parse on 32-bit numa
commit 1c6e55032e24ff79668581a0f296c278ef7edd4e

Moves the call to dmi_scan_machine before the vmi_initialization is
done, dmi_scan_machine internally calls early_ioremap, which does
early_set_fixmap effectively making use of FIXMAP areas before VMI gets
a chance to relocate it.

Similarly, in the other commit,
x86: move fix mapping page table range early
commit e7b3789524eecc96213dd69d6686efd429235051

There is this new call to early_ioremap_page_table_range_init which is
done from init_memory_mapping, this uses FIXADDR_TOP to initialize the
page table range. 

Now if you look at vmi_init, we relocate the fixmap area by changing the
__FIXADDR_TOP  value. So this needs to happen before anybody starts
using the fixmap area. 

>  I am not super-happy about this
> solution if there is a better one,

>  like simply locating the fixmap area
> out of the way to start with.

I won't say that i completely understand this statement , but IMO the
patch that i sent effectively does the same thing, we make sure that the
fixmap area is set to a final value before anybody else starts using
it. 

Thanks,
Alok
> 
>         -hpa

