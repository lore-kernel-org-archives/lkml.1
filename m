Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbXEITeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbXEITeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbXEITen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:34:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:47363 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXEITem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dIltfhHhX8u9MP1wZPxOz1bLjKKuuOOKv1fuPR6MUkh6S2lZCivMMDk5vh+ulm2GDthEKGJ/UHKbbI87vSpzBkcoOGgW1q2JuKFKXvnMywfzuHf0q4UmFK4W9CJlaBOEQ0Zdjrnpz1g73jPGE3NQvKLqj+QwS6NGCtotrGqy2o8=
Message-ID: <a781481a0705091234w613f7e59ud3968a7143ed62ac@mail.gmail.com>
Date: Thu, 10 May 2007 01:04:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Johannes Stezenbach" <js@linuxtv.org>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
Cc: "Jonathan Corbet" <corbet@lwn.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Paul Sokolovsky" <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070509094305.GC28774@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070508121404.17bd97a6.randy.dunlap@oracle.com>
	 <16987.1178675251@lwn.net> <20070509094305.GC28774@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Johannes Stezenbach <js@linuxtv.org> wrote:
> On Tue, May 08, 2007, Jonathan Corbet wrote:
> >
> > I just took a shot at turning this into something more like a normal
> > document:
> >
> >       http://lwn.net/Articles/233479/
>
> I think the "jiffies variable is special" part misses the
> "for stupid legacy reasons" explanation.
>
> According to the other volatile rules one should use
> something like that:
>
> extern unsigned long __jiffies;
> static inline unsigned long read_ulong(unsigned long *addr)
> {
>         return *(volatile unsigned long *)addr;
> }
> static inline unsigned long get_jiffies(void)
> {
>         return read_ulong(&__jiffies);
> }
>
> But of course changing all references to jiffies in the kernel would
> be insane, thus jiffies is special "for stupid legacy reasons".
>
> Right?

Right. jiffies comes with no locking protection by default (and adding
one today in a patch that is not invasive / disruptive could be
difficult). If it had a spinlock or something for itself then the
above discussion would have been void, everybody would've just grabbed
the lock before accessing jiffies, and the spinlock implementation
would have done the Right Thing by itself (using barriers, obviously,
and so "volatile" would've been unnecessary even then).

Anyway, as things stand, jiffies comes without locks for itself. But
using a volatile "access cast" to read jiffies whenever you might need
it is _still_ not what I would personally prefer. IMO, it's *much*
better to use something like barrier() if / where you're sitting in a
tight loop comparing jiffies to whatever (a timeout expiry for
example).

So, if you _really_ need / want to do something of this sort, I'd much
rather see:

while (time_before(jiffies, expiry))
	barrier();

in code instead of:

while (time_before((*(volatile unsigned long *)&jiffies), expiry))
	;

But of course,

while (time_before(jiffies, expiry))
	cpu_relax();

would be better still.

A last word from Linus himself here would be obviously best, but I'm
not so sure it makes sense to allow the "volatile" type qualifier
_even_ for the jiffies case.
