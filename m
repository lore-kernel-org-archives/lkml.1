Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbYAJTZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbYAJTZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760878AbYAJTZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:25:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45983 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890AbYAJTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:25:31 -0500
Date: Thu, 10 Jan 2008 20:28:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.co,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080110192808.GF747@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:17:07AM -0800, Pallipadi, Venkatesh wrote:
> >I don't think that is needed or makes sense for reserved/ACPI * etc. 
> >Only e820 holes should be truly unmapped because only those should
> >contain mmio.
> 
> Do you mean just the regions that are not listed in e820 at all? We
> should also not map anything marked "RESERVED" in e820. Right?

RESERVED is usually memory used by the BIOS. Properly MMIO areas
should be in holes.

Of course there might be buggy BIOS who violate that but the
only way to find out is to check for the case in ioremap and warn. I would
be still optimistic of it being correct.

Another way would be to double check against the MTRRs - if it's UC then
it should be unmapped. Maybe that would be a good idea. That should
catch all true mmio holes unless a BIOS maps them cached but if it does
that it's already beyond help.

> 
> >> All reserved memory maps to a
> >> zero page. 
> >
> >Why zero page?  Why not unmap.
> 
> I had it unmapped first. Then thought of zero mapping for dd of devmem
> to continue working. May be there are apps that depend on that?
> Also, dd of devmem seems to be already broken with big memory without
> any of these changes.

Exactly it's already broken.

Anyways if someone accesses mmio through /dev/mem I think they definitely
want the real mappings, not a zero page.  And dev/mem should provide.
The trick is just to do it without caching attribute violations, 
but with mattr it is possible.

>  
> >Anyways you could make that a zillion times more simple by 
> >just rounding
> >the e820 areas to 2MB -- for the holes only that should be ok I think; 
> >i would expect them to be near always already suitably aligned.
> >
> >In short this can be all done much simpler.
> 
> On systems I tested, ACPI regions are typically not 2MB aligned. And on

ACPI regions don't need to be unmapped.

> some systems there are few 4k pages of reserved holes just before

reserved shouldn't be unmapped, just holes. Do they have holes
there or reserved areas?

I still hope 2MB alignment will work out.

-Andi

