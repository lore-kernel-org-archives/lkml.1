Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYBIQ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYBIQ4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYBIQ4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:56:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:55000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbYBIQ4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:56:11 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [3/5] CPA: Make advised protection check truly advisory
Date: Sat, 9 Feb 2008 17:56:06 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080208536.837219990@suse.de> <20080208163614.DF4FC1B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091602260.3145@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802091602260.3145@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091756.06553.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008 16:38:35 Thomas Gleixner wrote:
> On Fri, 8 Feb 2008, Andi Kleen wrote:
> 
> > 
> > Only force RO in the advisory protection checks when all pages in the 
> > range are RO. Previously it would trigger when any page in the range
> > was ro.
> > 
> > I believe this will make try_preserve_large_page much safer to use.
> 
> It might be quite useful to know it for sure.

I wrote that originally when you still had the bogus "AMD fix" 
in the tree.  I think it was because I hoped it would fix that one,
but I wasn't sure because I couldn't reproduce it. But Hugh's
patch fixed that anyways.

> Thinking about the whole set of changes, you are right, that the
> current check for the first page only is not correct, but I don't see
> how your changes make it more correct.

With my patch at least NX should be always correct and that is 
the more important one because it is default and has to be cleared
and things go horribly wrong when it is incorrect.

RO on the other hand defaults to off and is only sometimes forced.
 
> The correct way to fix this is to check, whether all the small pages,
> which fit in the range of the large page, which we want to preserve,
> have the same resulting pgprot flags.

Ok if you don't like the try_preserve_large_page change
feel free to drop it or implement it differently.

My main goal here was to clean up the 32bit direct mapping
anyways (last patch) and that does just require splitting out the 
NX checks from the RO checks and having a range (first patches)

I think at least the range checks are definitely needed
for correctness though.

If I cared particularly I would probably implement two modi: 
one with DEBUG_RODATA and another without. With DEBUG_RODATA 
advisory protections should be forced (and large pages split),
without not.

-Andi
