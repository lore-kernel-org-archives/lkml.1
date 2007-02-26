Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbXBZQYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbXBZQYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030312AbXBZQYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:24:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbXBZQY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:24:28 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0702252009110.12485@woody.linux-foundation.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
	 <1172452660.3971.33.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702251940500.12485@woody.linux-foundation.org>
	 <1172462466.3971.46.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0702252009110.12485@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 11:24:57 -0500
Message-Id: <1172507097.3971.62.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 20:13 -0800, Linus Torvalds wrote:
> 
> On Sun, 25 Feb 2007, David Woodhouse wrote:
> >
> > > Can you try adding something like
> > > 
> > >         memset(start, 0xf0, end - start);
> > 
> > Yeah, I did that before giving up on it for the day and going in search
> > of dinner. It changes the failure mode to a BUG() in
> > cache_free_debugcheck(), at line 2876 of mm/slab.c
>
> Ok, that's just strange. 

In this case I hadn't left the 'return' in free_initrd_mem(). I was
poisoning the pages and then returning them to the pool as usual.

If I poison the pages and _don't_ return them to the pool, it boots
fine. PageReserved is set on every page in the initrd region; total
page_count() is equal to the number of pages (which doesn't
_necessarily_ mean that page_count() for every page is equal to 1 but
it's a strong hint that that's the case).

Looking in /dev/mem after it boots, I see that my poison is still
present throughout the whole region.

> One obvious thing to do would be to remove all the "__initdata" entries in 
> mm/slab.c..

This is biting us long before we call free_initmem().

>  But I'd also like to see the full backtrace for the  BUG_ON(), 
> in case that gives any clues at all.

I'll see if I can find a camera. 

> > It smells like the pages weren't actually reserved in the first place
> > and we were blithely allocating them. The only problem with that theory
> > is that the initrd doesn't seem to be getting corrupted -- and if we
> > were handing out its pages like that then surely _something_ would have
> > scribbled on it before we tried to read it.
> 
> Yeah, I don't think it's necessarily initrd itself, I'd be more inclined 
> to think that the reason you see this change with the initrd unpacking is 
> simply that it does a lot of allocations for the initrd files, so I think 
> it is only indirectly involved - just because it ends up being a slab 
> user.

Whatever happens, initrd as a 'slab user' is fine. The crashes happen
_later_, when someone else is using the memory which used to belong to
the initrd. In that 'BUG at slab.c:2876' I mentioned above, r3 was
within the initrd region. As I said, I'll try to find a camera.

-- 
dwmw2

