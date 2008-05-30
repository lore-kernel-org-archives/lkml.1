Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbYE3Js0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbYE3Js0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYE3JsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:48:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41821 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752432AbYE3JsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:48:16 -0400
Message-ID: <483FCD5C.208@sgi.com>
Date: Fri, 30 May 2008 11:48:12 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Roland Dreier <rdreier@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com, linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, Jeremy Higdon <jeremy@sgi.com>
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>	 <20080526.184047.88207142.davem@davemloft.net>	 <1211854540.3286.42.camel@pasglop>	 <20080526.192812.184590464.davem@davemloft.net>	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>	 <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop>	 <adaiqwzsa83.fsf@cisco.com>  <yq0iqwxrwuh.fsf@jaguar.mkp.net> <1212097223.8888.55.camel@pasglop>
In-Reply-To: <1212097223.8888.55.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2008-05-29 at 10:47 -0400, Jes Sorensen wrote:
>> The only way to guarantee ordering in the above setup, is to either
>> make writel() fully ordered or adding the mmiowb()'s inbetween the two
>> writel's. On Altix you have to go and read from the PCI brige to
>> ensure all writes to it have been flushed, which is also what mmiowb()
>> is doing. If writel() was to guarantee this ordering, it would make
>> every writel() call extremely expensive :-(
> 
> Interesting. I've always been taught by ia64 people that mmiowb() was
> intended to be used solely between writel() and spin_unlock().
> 
> I think in the above case, you really should make writel() ordered.
> Anything else is asking for trouble, for the exact same reasons that I
> made it fully ordered on powerpc at least vs. previous stores. I only
> kept it relaxed vs. subsequent cacheable stores (ie, spin_unlock), for
> which I use the trick mentioned before.

Hmmm I hope I didn't mess up the description of this and added to the
confusion.

The net result of that would be to kill performance completely, I really
don't like that idea.... Having each writel() go out and poll the PCI
bridge is going to make every driver used on Altix slow as a dog.

In addition it's still not going to solve the problem for userland
mapped stuff such as infinibug.

> Yes, this has some cost (can be fairly significant on powerpc too) but
> I think it's a very basic assumption from drivers that consecutive
> writel's, especially issued by the same CPU, will get to the device
> in order.

In this case the cost is more than just significant, it's pretty
crippling.

> If this is a performance problem, then provide relaxed variants and
> use them in selected drivers.

We'd have to make major changes to drivers like e1000, tg3, mptsas, the
qla2/3/4xxx and a bunch of others to get performance back. I really
think the code maintenance issue there will get far worse than what we
have today :(

Cheers,
Jes
