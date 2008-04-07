Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYDGSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYDGSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYDGSZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:25:20 -0400
Received: from outbound-mail-148.bluehost.com ([67.222.38.38]:44914 "HELO
	outbound-mail-148.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751966AbYDGSZT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:25:19 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Date: Mon, 7 Apr 2008 11:23:27 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <47F391BD.1060306@linux.intel.com> <47F3C90E.2020208@tungstengraphics.com>
In-Reply-To: <47F3C90E.2020208@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804071123.27411.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 02, 2008 10:57 am Thomas Hellström wrote:
> Arjan van de Ven wrote:
> > Thomas Hellström wrote:
> > > to fix the long standing uc/wc aliasing issue, provided we
> >
> > I'm not opposed to a real fix. I am opposed to a bad hack.
>
> Great. So a real clean fix involves setting all "default" kernel
> mappings either to WC (which will require PAT) or
> Unmapped, for a pool of pages used in the graphics tables.
>
> To reduce the number of attribute changes for mappings that are
> frequently switched, and also to reduce the number of clflushes, and to
> avoid waiting for upcoming wc versions of set_memory_xx, I have a strong
> preference for unmapping the pages.

Hopefully the WC stuff will be upstream right after 2.6.25 comes out.  Any 
reason why we shouldn't keep the pages mapped in the kernel as WC assuming 
the interface is there?

And we really should be keeping pools of pages around with the right type--we 
don't want to change attributes any more than absolutely necessary (the ia64 
uncached allocator does this right already, and in the DRM we actually keep 
the mappings around right now afaict).  We can allocate & free large chunks 
at a time to deal with memory pressure one way or another...

> 3) Have code in x86/pageattr.c decide which "default" mappings are
> present on the given pages and set them all as non-present.
> In fact, there is already such a function in pageattr.c:
>
> kernel_map_pages(struct page *pages, int numpages, bool enable);
>
> But it's for debugging purposes only, could we use and export a variant
> of this?
>
> I guess I need a hint as to what's considered allowable here, to avoid
> spending a lot of time on something that will in the end get rejected
> anyway.

I think we do want an interface like this, even if only for graphics memory 
(though I suspect some other device might like it as well).  We'll also want 
to do it at runtime periodically to allocate new hunks of memory for graphics 
use, so a boot-time only thing won't work.

Also, to make the API readable, we'd probably want to split the function into 
kernel_map_pages(..., enum memory_type type) and kernel_unmap_pages(...) 
(though like I said I think we really should be mapping them WC not umapping 
them altogether, since we do want to hit the ring buffer from the kernel with 
the WC type for example).

Question is, will kernel_map_pages catch all the various kernel mappings 
(regular identity map, large page text map,e tc.), perform the proper 
flushing, and generally make sure we don't machine check on all platforms?

Jesse
