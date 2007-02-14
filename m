Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbXBNIgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbXBNIgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 03:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbXBNIgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 03:36:47 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:53131
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146AbXBNIgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 03:36:46 -0500
Message-Id: <45D2D856.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 08:37:26 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <virtualization@lists.osdl.org>, <xen-devel@lists.xensource.com>,
       "Andi Kleen" <ak@muc.de>, "Andrew Morton" <akpm@osdl.org>,
       "Chris Wright" <chrisw@sous-sol.org>, <linux-kernel@vger.kernel.org>,
       "Dan Hecht" <dhecht@vmware.com>
Subject: [Xen-devel] Re: [patch 05/21] Xen-paravirt: paravirt_ops:
	allocate a fixmap slot
References: <20070213221729.772002682@goop.org>
 <20070213221829.845132535@goop.org> <45D2649D.4080508@vmware.com>
 <45D26797.5090600@goop.org>
In-Reply-To: <45D26797.5090600@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.02.07 02:36 >>>
>Dan Hecht wrote:
>> Why doesn't Xen allocate the shared_info page from the pseudo-physical
>> space?  Doesn't it already have to steal pages from the
>> pseudo-physical space for e.g. initial page tables, console, etc?  Why
>> not do the same for shared_info, and then you don't need a reserve the
>> fixmap slot.
>
>Unlike the pagetable pages or the console page, the shared info page
>doesn't have a pseudo-physical address, so in order to map it we need to
>directly construct a pte containing the mfn for that page.  Inserting
>this mapping into the fixmap space seems like the easiest way to do
>this.  It's not like a fixmap slot costs anything.

Otoh there are many fixmap slots not used under Xen, perhaps it would
be possible to use one of those... One slot certainly doesn't cost a lot,
but many (like the IO-APIC group) may already matter, especially on
PAE systems with lots of memory). Consequently, if these can't be
squeezed out as needed, re-using would seem more appropriate than
adding.
(I would certainly favor [conditionally] removing them, but can't easily
see how to do this under CONFIG_PARAVIRT. Background being that
we've already been hit by those [namely the LAPIC one] remaining
present, hence the build not being able to detect that accesses to the
LAPIC page can't work. While no such access was ever left in the base
kernel, modules are more susceptible to this, and in our case it was
the [native, i.e. pre-xenoprof] oprofile driver that had been forgotten
to be disabled.)

Jan
