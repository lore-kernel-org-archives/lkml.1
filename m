Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXK2KET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXK2KET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbXK2KEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:04:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:5998 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847AbXK2KEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CuFM7DKa+wrmzlGa1tyUg5k+VIMeQLsnUZcVCZuC8btM7V6VrqpWH+wa3WUIBWv1zKKJR4Cq8p7rU+kytC9VCYL4AYV6841YtxzZQE1V9E2LpFc8UDYBW9d4jqHriAVG+tme6JFO6QDb9jEoZntVv8JxzO6vn4tuAqZ6zIupIW8=
Message-ID: <19f34abd0711290204m6d23957o9b31b1d527c07694@mail.gmail.com>
Date: Thu, 29 Nov 2007 11:04:04 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711291127470.26543@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474C34CC.6060509@gmail.com>
	 <84144f020711290002p290e91a4ubc40f1efbc877f75@mail.gmail.com>
	 <19f34abd0711290110n501ddb43wf3ab69b526acef95@mail.gmail.com>
	 <Pine.LNX.4.64.0711291127470.26543@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 10:39 AM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Hi,
>
> On Nov 29, 2007 9:02 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > Is it really necessary to track every memory address? Tracking slab
> > > objects would require far less memory. You might also want to make
> > > kzalloc() and GFP_ZERO mark the memory area as initialized to avoid
> > > some page faults.
>
> On Thu, 29 Nov 2007, Vegard Nossum wrote:
> > Yes, we are in fact only tracking the memory within SLUB allocations
> > (minus what SLUB itself needs for bookkeeping -- like the caches).
>
> Yeah but you didn't answer my question: why do we track every memory
> address instead of slab objects? What's the benefit? Like I already said,
> tracking slab objects would require much less memory which makes the
> thing more practical. It also reduces the number of false positives (the
> CONFIG_OPTIMIZE_FOR_SIZE problem). And we already have slab poisoning to
> cover the cases we would not catch with this scheme.

If I understand you correctly, you only want to be notified if any
memory within an allocation is used before any memory within the
allocation has been initialized. I think that this would be quite
useless compared to tracking all the bytes of an allocation. I am not
truly concerned about the memory usage; this kind of error detection
is by definition slow and memory intense. I think that slab poisoning
is in a way more subtle, since it does not immediately produce a
warning on its own; what it does is really to invoke *other* error
catching mechanisms. Slab poisoning works best with pointers since
pointers will be dereferenced. What about other kinds of data? The
kernel will not complain (loudly enough, anyway) if your bit-field
contains some arbitrary unexpected value. Kmemcheck will immediately
print a message to the log in this case.

> On Thu, 29 Nov 2007, Vegard Nossum wrote:
> > As for the kzalloc() and GFP_ZERO, I believe these will write zeros to
> > the data in question before the memory is returned to the caller. In
> > that case, the area will be "automatically" set to initialized since
> > these writes are also intercepted by kmemcheck.
>
> Yes, and what I proposed is as a potential optimization. Debugging aids
> need to be fast enough to be practical.

Yep, I didn't realize. Thanks. :-)

>
>                         Pekka
>

Vegard
