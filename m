Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYETG5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYETG5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbYETG51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:57:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45939 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbYETG50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:57:26 -0400
Date: Tue, 20 May 2008 16:02:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: Possible partial miss in pages needed for zone's memory map?
Message-Id: <20080520160242.9533c2ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080519231937.5fee7cf7.akpm@linux-foundation.org>
References: <87y769f7i4.fsf@saeurebad.de>
	<20080519231937.5fee7cf7.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 23:19:37 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 17 May 2008 14:19:15 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
> 
> > Hi,
> > 
> > I stumbled over the following in the zone initialization code.  Please
> > let me know if I overlooked something here.
> > 
> 
> hm, no takers.  Let's add linux-mm.
> 
> > 
> > From: Johannes Weiner <hannes@saeurebad.de>
> > Subject: [PATCH] Don't drop a partial page in a zone's memory map size
> > 
> > In a zone's present pages number, account for all pages occupied by the
> > memory map, including a partial.
> > 
> > Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> > ---
> > 
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3378,7 +3378,8 @@ static void __paginginit free_area_init_
> >  		 * is used by this zone for memmap. This affects the watermark
> >  		 * and per-cpu initialisations
> >  		 */
> > -		memmap_pages = (size * sizeof(struct page)) >> PAGE_SHIFT;
> > +		memmap_pages =
> > +			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
> >  		if (realsize >= memmap_pages) {
> >  			realsize -= memmap_pages;
> >  			printk(KERN_DEBUG
> 
> I looked in there for 30 seconds and collapsed in confusion over which
> variables are in which units.
> 
Hmm, size * sizeof(struct page) is  multiple of PAGE_SIZE in many case.
Becasue "size" is always alinged to (1 << MAX_ORDER -1) (I believe...).

ex.) In x86 case,
   (1 << (MAX_ORDER(11) - 1)) * 4 (sizeof(long)) = (1 << 12) = PAGE_SIZE.

But not sure on other archs with various params.
I think above fix is correct.

Thanks,
-Kame

