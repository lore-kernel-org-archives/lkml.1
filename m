Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYATWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYATWSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 17:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbYATWSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 17:18:10 -0500
Received: from ozlabs.org ([203.10.76.45]:39908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbYATWSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 17:18:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
Date: Mon, 21 Jan 2008 09:17:30 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
References: <200801202046.14746.rusty@rustcorp.com.au> <4793450F.40902@gmail.com> <47934604.6080505@gmail.com>
In-Reply-To: <47934604.6080505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210917.30977.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008 00:00:52 Tejun Heo wrote:
> What should be do are
>
> * Check that the threadfn's argument fits into void *.

For everything but timer, you'll get a warning if the data isn't assignable to 
a void *, so you get a warning if you use a non-pointer already.

But it would be cool to allow functions which take an unsigned long.  To do 
this, I think that would need to be a special case for the data arg (which 
we'd really want to wrap in a macro), like:

	/* If fn expects an unsigned long, cast the data.  If not, we'll
	 * get a warning if data is not void * compatible. */
	__builtin_choose_expr(__builtin_compatible_p(typeof(1?(threadfn):NULL),
			      int (*)(unsigned long)),
			      (void *)(unsigned long)(data), (data))

> * Trigger overflow in implicit constant conversion warning if the
> specified data is too large for the argument type.

Hmm, u64 on 32-bit platforms?  I think that will fail the above test: the type 
of the function ptr will be "int (*)(u64)" and so you'll end up passing data 
(a u64) to a void * argument, which will elicit a warning...

I'll test this out and see what I can make...

Thanks!
Rusty.
