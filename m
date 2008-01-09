Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYAIDGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYAIDGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYAIDGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:06:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbYAIDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:06:45 -0500
Date: Tue, 8 Jan 2008 19:06:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, hch@lst.de, ak@suse.de, pq@iki.fi,
       jbeulich@novell.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "x86: optimize page faults like all other achitectures and kill notifier cruft"
Message-Id: <20080108190611.3b9c0760.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 02:34:46 +0000 (GMT) Dave Airlie <airlied@linux.ie> wrote:

> 
> [This an initial RFC but I'd like to have this patch in before 2.6.24 goes 
> final as it really breaks this useful feature]
> 
> mmiotrace the MMIO access tracer used to reverse engineer binary blobs
> used this notifier interface and is planned on being pushed upstream.
> 
> Having users able to just use the tracer module without having to rebuild 
> their kernel to add in a page fault handler hack means we get a lot 
> greater coverage for reverse engineering efforts.

Sorry, but that's a really really small benefit.  This very small number of
fairly (or very) technical users will be able to work out a way of getting
this to work in 2.6.24.  And in 2.6.25 with a merged mmiotrace we can do
something different.

It's a modest convenience to a very small number of people.  And the cost? 
Multiple functions calls and multiple cachelines hit for every pagefault
on, what?  Tens of millions of machines?

Plus the code which is getting restored isn't even very good.  For every
pagefault it populates a struct on the stack, passes that around for a
while, does a bit of RCU stuff only to find that there was nothing to do. 
Surely we should at least be doing something along the lines of

	if (unlikely(notify_page_fault_chain.notifier_call != NULL)) {
		all that crap
	}


But that's all speculation.  Has anyone actually measured the pagefault
latency impact of this change?

> +/*
> + * These are only here because kprobes.c wants them to implement a
> + * blatant layering violation.  Will hopefully go away soon once all
> + * architectures are updated.
> + */
> +static inline int register_page_fault_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
> +static inline int unregister_page_fault_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
> +

And this doesn't look very good either.  For how long did this fixme remain
unfixed?


So I'd suggest that we leave things as they are for 2.6.24 - mmiotrace
people will work something out, I'm sure.  For 2.6.25 if we merge mmiotrace
we can look at doing something which is vaguely efficient and tasteful.

