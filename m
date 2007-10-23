Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXJWAP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXJWAP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXJWAPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:15:20 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48599 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbXJWAPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:15:18 -0400
Subject: Re: Interaction between Xen and XFS: stray RW mappings
From: Zachary Amsden <zach@vmware.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
In-Reply-To: <20071022233514.GA9057@one.firstfloor.org>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>
	 <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au>
	 <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org>
	 <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de>
	 <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org>
	 <20071022223224.GC995458@sgi.com>
	 <20071022233514.GA9057@one.firstfloor.org>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 17:16:03 -0700
Message-Id: <1193098563.7278.40.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 01:35 +0200, Andi Kleen wrote:
> On Tue, Oct 23, 2007 at 08:32:25AM +1000, David Chinner wrote:
> > On Mon, Oct 22, 2007 at 09:07:40PM +0200, Andi Kleen wrote:
> > > On Mon, Oct 22, 2007 at 11:40:52AM -0700, Jeremy Fitzhardinge wrote:
> > > > Andi Kleen wrote:
> > > > > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > > > >   
> > > > >> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
> > > > >> stray mappings, which upsets Xen.
> > > > >>     
> > > > >
> > > > > Again it not just upsets Xen, keeping mappings to freed pages is wrong generally 
> > > > > and violates the x86 (and likely others like PPC) architecture because it can 
> > > > > cause illegal caching attribute aliases.

It is a serious offense to leave stray mappings for memory which can get
re-mapped to I/O devices... especially with PCI and other device
hotplug.  I have to back up Andi on this one unconditionally.

On architectures where you have multibyte, non-wordsize updates to
hardware page tables, you even have races here when setting, updating
and clearing PTEs that must be done in a sequence where no aliasing of
mappings to partially written PTEs can result in I/O memory getting
mapped in a cacheable state.  The window here is only one instruction,
and yes, it is possible for a window this small to create a problem.  A
large (or permanently lazy) window is extremely frightening.

These things do cause bugs.  The bugs take a very long time to show up
and are very difficult to track down, since they can basically cause
random behavior, such as hanging the machine or losing orbit and
crashing into the moon.

Zach

