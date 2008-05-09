Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYEIGqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYEIGqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYEIGp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:45:59 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:48758 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYEIGp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:45:58 -0400
Date: Fri, 9 May 2008 08:45:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memory_hotplug: always initialize pageblock bitmap.
Message-ID: <20080509064512.GD9840@osiris.boeblingen.de.ibm.com>
References: <20080509060609.GB9840@osiris.boeblingen.de.ibm.com> <20080509153910.6b074a30.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509153910.6b074a30.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 03:39:10PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 9 May 2008 08:06:09 +0200
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > Trying to online a new memory section that was added via memory hotplug
> > sometimes results in crashes when the new pages are added via
> > __free_page. Reason for that is that the pageblock bitmap isn't
> > initialized and hence contains random stuff.
> 
> Hmm, curious. In my understanding, memmap_init_zone() initializes it.
> 
>  __add_pages()
> 	-> __add_section()
> 		-> sparse-add_one_section() // allocate usemap
> 		-> __add_zone()
> 			-> memmap_init_zone() // reset pageblock's bitmap 
> 
> Can't memmap_init_zone() does proper initialization ?

Well, it just _sets_ some bits. But nobody has initialized the bitmap
before to zero. It doesn't reset the pageblock's bitmap as your
comment would indicate.

> ........................
> Ah, ok. I see. grow_zone_span() is not called at __add_zone(), then,
> memmap_init_zone() doesn't initialize usemap because memmap is not in zone's
> range.
> 
> Recently, I added a check "zone's start_pfn < pfn < zone's end"
> to memmap_init_zone()'s usemap initialization for !SPARSEMEM case bug FIX.
> (and I think the fix itself is sane.)
> 
> How about calling grow_pgdat_span()/grow_zone_span() from __add_zone() ?

Dunno.. just fixed a few bugs to get it working.. somehow.. ;)
