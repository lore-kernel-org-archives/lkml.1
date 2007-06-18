Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbXFRK3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbXFRK3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXFRK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:29:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:12405 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbXFRK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B011X5hPQX3JFoxHIP+/ueIBkey31lO1Q/+TctL80HO6bFcn+e55od3XncN1RyLnvgOYiXbrOedD6h19RF7j2w+idUHlhfNB45r6JHOdWOSqhiOYAq6YH63KLzclPdpjlBUgWVG8hMJBNhUdYU8fsESbBEMvSYIXVPKMgMw14SQ=
Message-ID: <a781481a0706180329i688ece9fm4607c273ed3961bc@mail.gmail.com>
Date: Mon, 18 Jun 2007 15:59:42 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] mm: More __meminit annotations.
Cc: "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070618074529.GA21222@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618045229.GA31635@linux-sh.org>
	 <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
	 <20070618074529.GA21222@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/18/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Jun 18, 2007 at 02:49:24PM +0900, Yasunori Goto wrote:
> > >  }
> > >
> > > -static inline unsigned long zone_absent_pages_in_node(int nid,
> > > +static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
> > >                                             unsigned long zone_type,
> > >                                             unsigned long *zholes_size)
> > >  {
> >
> > I thought __meminit is not effective for these static functions,
> > because they are inlined function. So, it depends on caller's
> > defenition. Is it wrong?
>
> As we do not _know_ if a given function is inline or not it definitely
> makes sense to mark them as __meminit.
> If the compiler then decides to inline the function we are all clear and
> no problems. If the compiler decides not to inline the function we will
> properly discard the code after init has completed so again all clear.

The kernel uses always_inline (as of today), so I'd expect we do know
a function explicitly marked such would be inlined. But yes, if that
inline (or kernel's use of always_inline) is dropped from the code in
future, then we would need to add the __init at that time anyway,
so as long as gcc is doing the right thing given both inline and section,
we might introduce the __init now too as you suggest. [Might also help
readability / uniformity as Paul mentioned.]

> And btw. some people (including myself) consider it a bug that gcc inline
> a function that is forced to a specific section into a function that belongs
> to another section. Now gcc people has another view but that may change.
> So again defining a function as __meminit makes sense no matter the
> section marker.

Well, in-kernel, "inline __init" expands to (currently):
inline __attribute__((always_inline)) __attribute__((__section__(".init.text")))
which is weird, if not crazy, to say the least. So I'm not sure we can
find fault with gcc (regardless of what it does) given such usage :-)

On 6/18/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Jun 18, 2007 at 12:58:34PM +0530, Satyam Sharma wrote:
> >
> > Actually, modpost will _not_ complain precisely _because_ kernel
> > uses always_inline so a separate body for the function will never be
> > emitted at all.
> That has been threaten to change many times. Far far far too much
> are marked inline today. There has been several longer threads about it.
>
> Part of it is that some part MUST be inlined to work while other parts
> may be inline but not needed (and often the wrong thing).
>
> So a carefully added inline is good but the other 98% of inline
> markings are just wrong and ougth to go.

Hmm, this is a bit orthogonal, and I have no strong opinion regarding
the kernel's use of always_inline itself. Those who don't like gcc
rewriting their code would want it to stay but forcing it for all cases
(by redefining a keyword as a macro) isn't best either. Perhaps "inline"
could be left alone by removing the always_inline, and "__always_inline"
used explicitly where we _really_ want stuff to be inlined. But then what
might happen is that everybody would think his particular use of inline
is correct and beneficial and all users of inline in kernel would end up
as __always_inline anyway. Given this, the best way to deal with
kernel bloat due to inlining appears to be to remove the inline marker
from stuff that shouldn't/needn't be inline in the first place, instead of
changing the kernel's default use of always_inline, IMO.

Satyam
