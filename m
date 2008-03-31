Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYCaJPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYCaJPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbYCaJOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:14:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33212 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbYCaJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:14:48 -0400
Date: Mon, 31 Mar 2008 11:18:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Message-ID: <20080331091829.GD29105@one.firstfloor.org>
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F0A988.7010707@tungstengraphics.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 11:06:16AM +0200, Thomas Hellström wrote:
> Andi Kleen wrote:
> >>Also I think we need to clarify the semantics of the c_p_a 
> >>functionality. Right now both AGP and DRM relies on c_p_a  doing an 
> >>explicit cache flush. Otherwise the data won't appear on the device side 
> >>of the aperture.
> >>    
> >
> >But surely not in cpa I hope ? Or are you saying you first write data
> >and then do cpa? If true that would be quite an abuse of CPA 
> >I would say and you should fix it ASAP.
> >
> >  
> As AGP buffers are moved in- and out of AGP, the caching policy changes, 
> so yes, there may be writes to cache coherent memory that needs to be 
> flushed at some point. Since CPA has been doing that up to now, and the 
> codepaths involved are quite time-critical, a double cache-flush is a 

That doesn't make sense. You shouldn't be using CPA in any 
time critical code path. It will always be slow. 

For anything time critical you should keep a pool of uncached pages 
once set up using CPA and reuse them.

CPA really should only be used on initialization or for
larger setup changes which are ok to go somewhat slower.

> no-no, so if this is left to the caller, we must be able to tell CPA 
> that any needed cache-flush has already been performed.

Sounds like a bad design.

> >>If we use self-snoop, the AGP and DRM drivers can't rely on this flush 
> >>being performed, and they have to do the flush themselves, and for 
> >>    
> >
> >They definitely should flush themselves if they want data to reach
> >the device. That is obviously required any time they reuse a page
> >too.
> >  
> Understood,
> but then we *must* really find a way to say "don't flush the cache 
> again", perhaps part of Dave's array function?

The cache must be flushed in CPA, there is no way around it.

If you write data into the buffers before you do CPA on them
you could avoid it, but I don't think you should do that anywhere
near time critical code, so it actually shouldn't matter.

-Andi

