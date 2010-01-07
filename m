Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047Ab0AGRQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab0AGRQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207Ab0AGRQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:16:28 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41275 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0AGRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:16:27 -0500
Date: Thu, 7 Jan 2010 11:15:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 2/4] Replace local_t use in trace
 subsystem
In-Reply-To: <20100105225710.GC32584@Krystal>
Message-ID: <alpine.DEB.2.00.1001071109000.901@router.home>
References: <20100105220417.400092933@quilx.com> <20100105220438.462143211@quilx.com> <20100105225710.GC32584@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:

> >  static void rb_init_page(struct buffer_data_page *bpage)
> >  {
> > -	local_set(&bpage->commit, 0);
> > +	bpage->commit = 0;
>
> This is incorrect. You are turning a "volatile" write into a
> non-volatile write, which can be turned into multiple writes by the
> compiler and therefore expose inconsistent state to interrupt handlers.

The structure is being setup and therefore not reachable by anyone?

Even if that is not the case: The assignment of a scalar is atomic.

> >  static inline unsigned long rb_page_write(struct buffer_page *bpage)
> >  {
> > -	return local_read(&bpage->write) & RB_WRITE_MASK;
> > +	return bpage->write & RB_WRITE_MASK;
>
> Same problem here: missing volatile for read. Same applies thorough the
> patch.

Reading of a scalar is atomic.

> >  	if (tail >= BUF_PAGE_SIZE) {
> > -		local_sub(length, &tail_page->write);
> > +		add_local(&tail_page->write, -length);
>
> [...]
>
> If we can have inc/dec/sub already, that would be good, rather than
> going with add -val. This would ensure that we don't do too much
> ping-pong with the code using these primitives.

ok.

> In the end, the fact that the missing volatile access bug crept up as
> part of this patch makes me think that keeping local_t was doing a fine
> encapsulation job. However, if we really want to go down the path of
> removing this encapsulation, then we should:

I am not sure that there is anything to be won by volatile.

> - make sure that _all_ variable accesses are encapsulated, even
>   read_local and set_local.
> - put all this API into a single header per architecture, easy for
>   people to find and understand, rather than multiple headers sprinkled
>   all over the place.
> - document that accessing the variables without the API violates the
>   consistency guarantees.

Then we better leave things as is. local.h would then become a private
operations set for ringbuffer operations?

I'd like to see local operations that are generically usable also in
other subsystems. Locall operations that work generically on scalars
(pointer, int, long etc) like cmpxchg_local.

The only new operation needed for ringbuffer.c is add_local().
Sugarcoating with inc/dec/sub can be easily added and add_local can be
modified to generate inc/dec if it discovers 1 or -1 being passed to it.



