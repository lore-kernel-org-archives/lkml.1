Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYC1Bg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYC1Bg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYC1Bgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:36:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44865 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYC1Bgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:36:45 -0400
Date: Fri, 28 Mar 2008 10:34:51 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned memory is bad
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
References: <e0b16cc8349b38a5f3f9.1206664118@localhost> <20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 27 Mar 2008 17:28:38 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -784,6 +784,9 @@
> >  #define PAGES_PER_SECTION       (1UL << PFN_SECTION_SHIFT)
> >  #define PAGE_SECTION_MASK	(~(PAGES_PER_SECTION-1))
> >  
> > +#define SECTION_SIZE		(1UL << SECTION_SIZE_BITS)
> > +#define SECTION_SIZE_MASK	(SECTION_SIZE - 1)
> > +
> >  #define SECTION_BLOCKFLAGS_BITS \
> >  	((1UL << (PFN_SECTION_SHIFT - pageblock_order)) * NR_PAGEBLOCK_BITS)
> >  
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -300,6 +300,11 @@
> >  	int ret;
> >  	u64 start = res->start;
> >  	u64 size = res->end - res->start + 1;
> > +
> > +	/* Adding non-section-aligned memory will give unexpected
> > +	   and unintuitive results. */
> > +	WARN_ON((start & SECTION_SIZE_MASK) != 0);
> > +	WARN_ON((size & SECTION_SIZE_MASK) != 0);
> >  
> Why just WARNING ? not BUG_ON?

Both Nack.

Because, firmware may occupy some area in the section.
Firmware must exclude those area to notify kernel. So, E820, EFI,
or _CRS of ACPI may return not aligned address and size.
register_memory_resource() and walk_memory_resource() are to skip
them silently. This is intended.

Bye.

-- 
Yasunori Goto 


