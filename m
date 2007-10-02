Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXJBHN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXJBHN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXJBHNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:13:19 -0400
Received: from owa.c2.net ([207.235.78.2]:3081 "EHLO email.c2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXJBHNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:13:18 -0400
Subject: Re: [PATCH] Inconsistent mmap()/mremap() flags
From: Thayne Harbaugh <thayne@c2.net>
Reply-To: thayne@c2.net
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, discuss@x86-64.org
In-Reply-To: <20071002051526.GA29615@one.firstfloor.org>
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
	 <200710011313.30171.andi@firstfloor.org>
	 <1191293830.5200.22.camel@phantasm.home.enterpriseandprosperity.com>
	 <20071002051526.GA29615@one.firstfloor.org>
Content-Type: text/plain
Organization: C2
Date: Tue, 02 Oct 2007 01:06:12 -0600
Message-Id: <1191308772.5200.66.camel@phantasm.home.enterpriseandprosperity.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2007 07:13:18.0074 (UTC) FILETIME=[B4EEC5A0:01C804C3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 07:15 +0200, Andi Kleen wrote:
> On Mon, Oct 01, 2007 at 08:57:10PM -0600, Thayne Harbaugh wrote:

> For mmap you can emulate it by passing a low hint != 0 (e.g. getpagesize()) 
> in address but without MAP_FIXED and checking if the result is not beyond
> your range.

Cool.  That's a much better solution for multiple reasons - like you
mention, MAP_32BIT is only 2GB as well as it's only available on x86_64.

> > > Given for mremap() it is not that easy because there is no "hint" argument
> > > without MREMAP_FIXED; but unless someone really needs it i would prefer
> > > to not propagate the hack. If it's really needed it's probably better
> > > to implement a start search hint for mremap()
> > 
> > It came up for user-mode Qemu for the case of emulating 32bit archs on
> > x86_64 using mmap.  At the moment it calls mmap with MAP_32BIT and then
> 
> That would limit the 32bit architectures to 2GB; but their real limit
> is 4GB. Losing half of the address space definitely would make users unhappy
> (e.g. at least normal Linux kernels wouldn't run at all) 

Keeping a kernel happy isn't necessary since it's user-space emulation
rather than full emulation.  It is, however, useful to have 4GB rather
than 2GB.

> Does qemu actually need mremap() ?  It would surprise me because
> a lot of other OS don't implement it.

Qemu has two modes: full hardware emulation and user-mode emulation.
User-mode emulation translates the user-mode code and then remaps the
system calls directly into the native kernel (that way all the kernel
and all the I/O runs natively and faster).  As far as mremap(), I'm
trying to get a 32bit arm mremap() emulated syscall mapped onto a 64bit
x86_64 mremap().

