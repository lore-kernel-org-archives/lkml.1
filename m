Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbZCRBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbZCRBTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZCRBTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:19:01 -0400
Received: from mail-ew0-f168.google.com ([209.85.219.168]:62419 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbZCRBTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gl7c1RVyxj5sBsA0gp9ph0QOIA5GPB4E+6rjHh4ncgUoDUF+sAm+MmDRn6mv7taJru
         ulfNmfBWd5YHK+gW1Bq/rgyt3uVBJvKx/SE8FiLAVMvf1fFP/TE6BV+SZA2OmumoeiL9
         4LE98ahbg7dBWAuki/+ulxLeyR0oNSU3CT6IQ=
Date: Wed, 18 Mar 2009 02:18:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH 0/4] tracing: event filtering
Message-ID: <20090318011854.GA9345@nowhere>
References: <1237271002.8033.148.camel@charm-linux> <20090317085713.GA16952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317085713.GA16952@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 09:57:13AM +0100, Ingo Molnar wrote:
> 
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Hi,
> > 
> > This patchset is a first attempt at adding filtering to the 
> > event-tracing infrastructure.
> 
> Really cool!
> 
> > The filtering itself seems to work ok, as far as I've been 
> > able to test it, but I'm still battling with getting the 
> > ring-buffer to do what I want (discarding events, see patch 2) 
> > so am hoping someone more familiar with the ring buffer can 
> > point me in the right direction before I do any more work on 
> > it.
> 
> Seems to be a weakness in our current event abstraction itself - 
> by the time we get to filtering we already have the record in 
> the ring buffer - and have to work hard to pull it out of there. 
> It would be better to allow tracing filters to operate on a 
> private copy of the data, before it's inserted into the 
> ringbuffer.
> 
> As an intermediate solution (until the rb details get sorted 
> out), i think your hack could be used - it essentially marks the 
> entry as discarded, so that the output stage ignores it, right?
> 
> If the patch is brought into a more palatable state (no crashes, 
> no C99 comments) i'd argue we apply this almost as-is, so that 
> the filtering details can advance independently of the 
> ring-buffer management details. Steve, do you agree?
> 
> > Another specific thing it would be good to get comments on 
> > would be how to allow the user to unambiguously specify a 
> > field name in a filter when there are duplicate field names 
> > for an event, as mentioned in patch 1.
> 
> A short-term fix would be to name the common fields common_pid 
> or so, to reduce the chance of collision. (and show that in the 
> format output too)
> 
> Plus we should add a debug check as well when an event is 
> registered: all fields in a format should be uniquely 
> accessible.
> 
> > Of course, any comments about the rest of the interface and 
> > code are also welcome...
> 
> You wanted to keep the filter expression parser simple, and i 
> agree with that in general.
> 
> I'd expect the filter to be popular with kernel developers who 
> do ad-hoc tracing - so making it as compatible with typical 
> syntax variations as possible would still be nice. The parser 
> will be larger but that's OK.
> 
>  - it would be nice to extend the range of operators to all the
>    typical C syntax comparison expressions: <= < >= > != ==. Some 
>    of these are supported but not all.
> 
>  - there should be '||' and '&&' aliases for the 'or' / 'and' 
>    tokens.
> 
>  - parantheses could be supported too perhaps instead of the 
>    current 'echo separately to build up complex expressions', up
>    to the expression-length limit.


Indeed, it would be much more intuitive.
Only one level of parenthesis with two operands and one operator inside
each groups. So that the expression parsing can stay about simple and
anyway people will not need more.

Frederic.

 
>  - bitwise operators might be useful too: 'mask & 0xff'.
> 
> We really want this to be a popular built-in facility that can 
> be used intuitively by anyone who knows C expressions, and 
> limitations in the expression parser are counter-productive to 
> that aim.
> 
> 	Ingo

