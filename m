Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYLEEIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYLEEIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYLEEIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:08:44 -0500
Received: from waste.org ([66.93.16.53]:48190 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYLEEIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:08:43 -0500
Subject: Re: [PATCH] Use vprintk rather that vsnprintf where possible
From: Matt Mackall <mpm@selenic.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
References: <1228423309.3255.109.camel@calx>
	 <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 22:08:20 -0600
Message-Id: <1228450100.3255.180.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 04:05 +0100, Kay Sievers wrote:
> On Thu, Dec 4, 2008 at 21:41, Matt Mackall <mpm@selenic.com> wrote:
> > This does away with lots of large static and on-stack buffers as well
> > as a few associated locks.
> 
> > -               len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
> > -
> >                va_start(args, fmt);
> > -               len += vsnprintf(&s[len], (256 - len), fmt, args);
> > +               printk(KERN_DEBUG "%s: ", prefix);
> > +               vprintk(fmt, args);
> 
> If we convert to two printk calls for a single line, does that not
> possibly get mixed up with printks from other locations and lead to
> hardly readable log output?

Once upon a time it was not uncommon to get printks interleaved on a
character by character basis when things went wrong. That was a bit of a
problem but still decipherable with some effort. This shouldn't be much
of a problem at all and indeed there are numerous other places where
printing is done in multiple pieces.

If we want to deal with the interleaving problem, we should do it by
making printk itself smarter rather than having users do bloaty, gross
things. Look at the code that's getting replaced here. Some of these
things use stack space which has much worse potential failure modes.
Others use locking on a static buffer - if that ever hits, we probably
lose a message. And the remainder use a static buffer with no locking:
potential garbage output. And of course, the static buffer is wasting
space when not in use, which is almost all the time.

-- 
Mathematics is the supreme nostalgia of our time.

