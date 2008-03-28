Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYC1SRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYC1SRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYC1SRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:17:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:47101 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYC1SRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bh2TwAD6ttO8lEDY69JwVtqwwLPy5q+stHD4kVhN4bLfIR9YnNiYtgXapCKXaTFULW4fdYah/F7fkz+JPihXRP3pYePL10OkcSENbQrt+Ig2Gf/S0lsvUchgidxtSgnAxf1d6l6cqtxEuh4DKblmEz8b7WDALhxvMRHXPl15KhM=
Message-ID: <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com>
Date: Fri, 28 Mar 2008 20:08:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Cc: "Christoph Lameter" <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pawel Staszewski" <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803272353.51901.rjw@sisk.pl>
	 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
	 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
	 <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
X-Google-Sender-Auth: a4e6d5971e532799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, 28 Mar 2008, Pekka Enberg wrote:
> > We clear GFP_ZERO in new_slab() so the normal kmalloc()/kzalloc() path
> > should be fine but don't do it for kmalloc_large() nor
> > kmalloc_large_node(). Is that the bug here?

On Fri, Mar 28, 2008 at 7:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  Dammit, NO.
>
>  The bug was that the commit I made (which was correct and robust) was then
>  partially reverted by Christoph for no good reason. At that point,
>  kmalloc_large() didn't even exist, so at that point the change was
>  "technically correct" (since the only user of gfpflags really did end up
>  clearing it somewhere deep in its callchain).

I was not implying that we should clear GFP_ZERO in kmalloc_large()
but that we can hit the page allocator with GFP_ZERO via kmalloc() and
kzalloc() for size > PAGE_SIZE allocations. And asking Christoph if
that's the bug we're seeing here.

On Fri, Mar 28, 2008 at 7:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  So the *last* thing we want to do is to clear GFP_ZERO in multiple subtle
>  places based on new random code being added. We want to clear it at the
>  top level, so that no other code never ever even has to _think_ about it!

We are clearing it in one place, just before calling alloc_pages.
[Yes, it's hard to spot, it's in new_slab() where we call
allocate_slab().] I'm okay with moving it to top level but I don't see
how that fixes any of the bugs mentioned here.

                        Pekka
