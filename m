Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYH2Pbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYH2Pbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYH2Pbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:31:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYH2Pbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:31:36 -0400
Date: Fri, 29 Aug 2008 08:31:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
In-Reply-To: <20080829065812.GA28777@elte.hu>
Message-ID: <alpine.LFD.1.10.0808290827110.3300@nehalem.linux-foundation.org>
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com> <20080829063012.GA19459@elte.hu> <86802c440808282347n66a6dfb7r2bebd9f65918614a@mail.gmail.com> <20080829065812.GA28777@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Ingo Molnar wrote:
> > 
> > you will get
> > fec00000 - ffffffff reserved
> >    fed0000 - fed003ff hpet
> >      fed0000 - fed003ff 0000:00:14.0
> 
> ok - because it's fully contained insert_resource() will succeed?

Correct.

> I thought it would only succeed if the new resource was smaller than (a 
> subset of) the existing resource.

No, that's "request_resource()".

Yeah, I know, the resource code is complicated, and I wish it wasn't, but 
the whole issue with nesting resources correctly simply _is_ fairly 
complex.

So "insert_resource()" literally tries to fit a resource into an existing 
tree, at the right level, whatever level that is.

In contrast, "request_resource()" is about exclusivity, and tries to 
request a "leaf" resource - and it refuses to work if there are resources 
it clashes with that cover the same range.

> In the other direction, when a newly inserted resource is a superset of 
> the existing resource, i thought we'd fail.

For request_resource, yes.

> hypothetical scenario, what if we had neither a superset nor a subset 
> scenario, but a partial overlap, between:
> 
> > >  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> 
> and:
> 
> > >   pci 0000:00:14.0: BAR has HPET at feb0f000-fec01000

Now THAT is somethign that the resource structs simply cannot handle. At 
that point you'd get a failure even from insert_resource(), because it no 
longer nests in the tree. You would have to split the range in order for 
it to nest properly.

			Linus
