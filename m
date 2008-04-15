Return-Path: <linux-kernel-owner+w=401wt.eu-S1762937AbYDOMhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762937AbYDOMhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbYDOMhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:37:38 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:41898 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758240AbYDOMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:37:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAEo+BEhMQWoK/2dsb2JhbACBXqsl
Date: Tue, 15 Apr 2008 08:32:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415123233.GA19797@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1208260942.6395.6.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:10:41 up 46 days,  8:21,  4 users,  load average: 0.11, 0.20,
	0.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> 
> > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > +			"abs_time:%p bitset:%d",
> > +			uaddr, fshared, val, abs_time, bitset);
> 
> This is some seriuosly ugly looking gunk, why would we want stuff like
> that scattered across the code?
> 

I don't really see how it differs so much from printks, which kernel
developers are already familiar with.

> What is wrong with a few simple hooks like:
> 
>   trace_futex_wait(uaddr, fshares, val, abs_time, bitset);
> 
> and then deal with that.
> 

If any of your variable type changes, then you are exporting an unknown
data structure to user-space. _That_ would break a userspace tracer
whenever you change any of these kernel variables and you don't want
that.

Exporting the field names and variable types helps to identify the
variables by their given names rather than their respective order.
Having the field type insures binary compatibility.

Clearly we can turn your trace_futex_wait(uaddr, fshares, val, abs_time,
bitset); into a trace_mark() with a simple define, and I don't see any
problem with that. I just want to make sure the event name, field names
and field types are exported, and this is done by markers. However, I
wonder why none of the kernel printk() are turned into specialized
defines to make the code "cleaner".. maybe it's because it is useful to
have everything declared in one spot after all.

> Also, you seem to expose way too much futex internals; do you really
> need that? People will go use this marker crap like ABI and further
> restrain us from changing the code.
> 

Because we extract the field names and types, we can create tracer
plugins that would hook on field names rather than expect a specific
number of fields and fixed field types. It makes it possible to tolerate
missing fields pretty easily. But yes, tracer tools might have to be
adapted to internal kernel changes, since they must follow kernel
structure changes. However, staying as close as possible to a canonical
representation of event fields, staying far from the specific
implemetation, would help to lessen the inter-dependency. On the other
hand, it would probably hurt trace compactness and efficiency.

Mathieu

> /me unhappy.
> 
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
