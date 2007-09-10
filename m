Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXIJK46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXIJK46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXIJK4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:56:49 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:2937 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXIJK4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Kanj2O398TPgm0naMcEYRuszK9bpDR8+9CdChTqC6Cbez2mRt32y4hV/T6d5MwvTF9L4pim962AsuA2bOSTIBMs5y4DQzX1k2WUv0pOsPLOSOXjUzciVELI+Wkxt3U6OJQE+d3N2FeGLFdi0QZTH3g1Gw+ud/hgX1ziyFHxx+5c=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Mon, 10 Sep 2007 11:56:29 +0100
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <200709091902.55388.vda.linux@googlemail.com> <20070909191839.1fa10e88@laptopd505.fenrus.org>
In-Reply-To: <20070909191839.1fa10e88@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709101156.30010.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2007 19:18, Arjan van de Ven wrote:
> On Sun, 9 Sep 2007 19:02:54 +0100
> Denys Vlasenko <vda.linux@googlemail.com> wrote:
> 
> > Why is all this fixation on "volatile"? I don't think
> > people want "volatile" keyword per se, they want atomic_read(&x) to
> > _always_ compile into an memory-accessing instruction, not register
> > access.
> 
> and ... why is that?
> is there any valid, non-buggy code sequence that makes that a
> reasonable requirement?

Well, if you insist on having it again:

Waiting for atomic value to be zero:

        while (atomic_read(&x))
                continue;

gcc may happily convert it into:

        reg = atomic_read(&x);
        while (reg)
                continue;

Expecting every driver writer to remember that atomic_read is not in fact
a "read from memory" is naive. That won't happen. Face it, majority of
driver authors are a bit less talented than Ingo Molnar or Arjan van de Ven ;)
The name of the macro is saying that it's a read.
We are confusing users here.

It's doubly confusing that cpy_relax(), which says _nothing_ about barriers
in its name, is actually a barrier you need to insert here.
--
vda
