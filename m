Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYGGLTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYGGLTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYGGLTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:19:34 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:32658 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753260AbYGGLTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:19:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hUt5LA04YnB8TAOzDO+Sxq7hMmXn1cAOis/rL9wfYRTXCTDhi4OZsJXmjXONglzOwgl9nkRoU96QFcB8wEHE/otVZb1ep+g8TtIHmDM4+cwkj+uzK3E1P/iNnEv22hReMbNQsg/GKgww4hTiYoEJQM+vBqimlcjGwu3F/x1+Xvc=  ;
X-YMail-OSG: UQf1_N8VM1k_UTLthY1j3KIp15I.gfauclDmN4ddtZ2wf_RIJNLIjKIKEGqYYQredUiR9F8gdraR2trZAnxYPXLtZ7MtFB523pvIrmhqs3UYNTME90_NESh9xVbWDKUh06I-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
Date: Mon, 7 Jul 2008 21:19:10 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Dave Airlie <airlied@gmail.com>,
       Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1214242487.11887.35.camel@koto.keithp.com> <200807071653.55094.nickpiggin@yahoo.com.au> <20080707000528.09518481@infradead.org>
In-Reply-To: <20080707000528.09518481@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072119.10831.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 17:05, Arjan van de Ven wrote:
> On Mon, 7 Jul 2008 16:53:54 +1000

> > One thing I still haven't implemented in that patch are CPU-local
> > mappings (which only require a local flush to flush)... I found that
> > after the improvements I did implement, they didn't help much for
> > my workloads, so I suspect you might find the same thing...
>
> just to complicate things with ioremap() you have to deal with the
> various caching-coherency requirements.. making things lazy and per CPU
> complicates that a ton (and I suspect won't actually make things
> cheaper)

Yeah, my vmap rewrite has a vm_unmap_aliases() call, which the
page attribute code calls.

But these flushes are not really any different between the atomic
kmap area and my vmap lazy flushing: the atomic kmap code still
has to do a broadcast global TLB flush.

The fact is simply that changing cache attributes is always going
to be an expensive operation and lazy mappings are not going to
really change that -- because changing attributes is going to
require a TLB flush on all CPUs _anyway_, which is the expensive
thing. All we really have to do with lazy mappings is tear down
their page tables before CPA's TLB flush -- if there were no lazy
unmappings in that time, then there will be no extra work to do.

... or, it occurs to me that you might have been referring to
something else: the problem of simply changing the cache attributes
on the pages that you wish to ioremap now. That's going to be slow
sure, but these guys don't seem to need such an attribute change
anyway because they are using kmap_atomic_pfn (which doesn't change
attributes)
