Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZC1A66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZC1A66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZC1A6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:58:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:43414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZC1A6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:58:49 -0400
Subject: Re: DRM lock ordering fix series
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Anholt <eric@anholt.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1238184629.625.44.camel@gaiman.anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
	 <1238171805.8275.2434.camel@gaiman.anholt.net>
	 <20090327181018.GC11935@one.firstfloor.org>
	 <1238184629.625.44.camel@gaiman.anholt.net>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 01:58:42 +0100
Message-Id: <1238201922.4039.403.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 13:10 -0700, Eric Anholt wrote:
> On Fri, 2009-03-27 at 19:10 +0100, Andi Kleen wrote:
> > On Fri, Mar 27, 2009 at 09:36:45AM -0700, Eric Anholt wrote:
> > > > > You are aware that there is a fast path now (get_user_pages_fast) which
> > > > > is significantly faster? (but has some limitations)
> > > > 
> > > > In the code I have, get_user_pages_fast is just a wrapper that calls the
> > > > get_user_pages in the way that I'm calling it from the DRM.
> > > 
> > > Ah, I see: that's a weak stub, and there is a real implementation.  I
> > > didn't know we could do weak stubs.
> > 
> > The main limitation is that it only works for your current process,
> > not another one. For more details you can check the git changelog
> > that added it (8174c430e445a93016ef18f717fe570214fa38bf)
> > 
> > And yes it's only faster for architectures that support it, that's
> > currently x86 and ppc.
> 
> OK.  I'm not too excited here -- 10% of 2% of the CPU time doesn't get
> me to the 10% loss that the slow path added up to.  Most of the cost is
> in k{un,}map_atomic of the returned pages.  

Also note that doing large gup() with gup_fast() will be undesirable due
to it disabling IRQs. So iterating say several MB worth of pages will
hurt like crazy. Currently all gup_fast() users do a single page lookup.


