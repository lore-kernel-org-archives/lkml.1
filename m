Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZCRGaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZCRGaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZCRG3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:29:54 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:62926 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbZCRG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZMc7c46R/DXe8InA/qc5d8PP55sPuaGd6/A7mxqLs7Ti6R40h5Lz++3sgsaBQFPvEl
         Exht8rROXbZxHVGxy0FKTlywY7/39uWWTgtrHYCLHykaaC2odpUF1w8EsU47LmfG4ecN
         vDw7efLEtDn8aYesAIOOuv3/L3JjNxqwIBKUg=
Subject: Re: [RFC][PATCH 0/4] tracing: event filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090317085713.GA16952@elte.hu>
References: <1237271002.8033.148.camel@charm-linux>
	 <20090317085713.GA16952@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 01:29:49 -0500
Message-Id: <1237357789.7922.35.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-03-17 at 09:57 +0100, Ingo Molnar wrote:
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

Yeah, that's the idea, which Steve's patch now does correctly.

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

I was trying to avoid using shell meta-characters to avoid the need for
any escaping, thus the 'and' and 'or', but can easily change it to use
this syntax instead if it's more intuitive.

> 
>  - parantheses could be supported too perhaps instead of the 
>    current 'echo separately to build up complex expressions', up
>    to the expression-length limit.
> 
>  - bitwise operators might be useful too: 'mask & 0xff'.
> 
> We really want this to be a popular built-in facility that can 
> be used intuitively by anyone who knows C expressions, and 
> limitations in the expression parser are counter-productive to 
> that aim.

I agree - the current parser is pretty silly anyway, so replacing it
with a more capable parser makes sense.  I'll do that in the next
iteration...

Tom

> 
> 	Ingo

