Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0CBMNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:13:17 -0500
Received: from sh.osrg.net ([192.16.179.4]:56417 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0CBMNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:13:15 -0500
Date: Tue, 2 Mar 2010 21:11:33 +0900
To: James.Bottomley@HansenPartnership.com
Cc: benh@kernel.crashing.org, linux@arm.linux.org.uk, catalin.marinas@arm.com,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, pavel@ucw.cz, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1267333263.2762.11.camel@mulgrave.site>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	<1267316072.23523.1842.camel@pasglop>
	<1267333263.2762.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Mar 2010 21:11:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 10:31:03 +0530
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2010-02-28 at 11:14 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2010-02-26 at 21:00 +0000, Russell King - ARM Linux wrote:
> > > On Fri, Feb 26, 2010 at 04:25:21PM +0000, Catalin Marinas wrote:
> > > > For mmap'ed pages (and present in the page cache), is it guaranteed that
> > > > the HCD driver won't write to it once it has been mapped into user
> > > > space? If that's the case, it may solve the problem by just reversing
> > > > the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> > > > has dirty D-cache by default.
> > > 
> > > I guess we could also set PG_arch_1 in the DMA API as well, to avoid the
> > > unnecessary D cache flushing when clean pages get mapped into userspace.
> > 
> > That's an interesting thought for us too. When doing I$/D$ coherency, we
> > have to fist flush the D$ and then invalidate the I$. If we could keep
> > track of D$ and I$ separately, we could avoid the first step in many
> > cases, including the DMA API trick you mentioned.
> > 
> > I wonder if it's time to get a PG_arch_2 :-)
> 
> Sorry to be a bit late to the party (on holiday), but I/D coherency is
> supposed to be taken care of using flush_cache_page in the memory
> mapping routines.

powerpc does that? To be exact, powerpc doesn't need
flush_cache_page() and handles I/D coherency in the pte modification
code. powerpc uses PG_arch_1 to avoid unnecessarily handling I/D
coherency. Seems that IA64 does the same trick with PG_arch_1.


> But the point of all of this is that I cache invalidation doesn't appear
> anywhere in the I/O path ... so  if we're getting I/D incoherency,
> there's some problem in the mm code (or there's a missing arch
> assumption ... like I cache gets moved in more aggressively than we
> expect).  Parisc is very sensitive to I/D incoherency, so we'd notice if
> there were a serious generic problem here.

I'm not sure that there are some problems in the mm or common code. Is
this ARM's implementation issue? (Of course, the usb stack and the
driver's misuse of the DMA API needs to be fixed too).
