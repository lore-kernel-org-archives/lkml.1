Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXLQRse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXLQRse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbXLQRsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:48:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33958 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbXLQRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:48:20 -0500
Date: Mon, 17 Dec 2007 17:48:06 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       John Reiser <jreiser@BitWagon.com>,
       Andrew Morton <akpm@linux-foundation.org>, security@kernel.org,
       tytso@mit.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, linux-sparse@vger.kernel.org
Subject: Re: Signed divides vs shifts (Re: [Security] /dev/urandom uses uninit bytes, leaks user data)
Message-ID: <20071217174806.GC8181@ftp.linux.org.uk>
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au> <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 09:28:57AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 15 Dec 2007, Herbert Xu wrote:
> > 
> > There ought to be a warning about this sort of thing.
> 
> We could add it to sparse. The appended (untested) patch seems to say 
> there's a lot of those signed divides-by-power-of-twos.

I'm not sure that you are warning about the right things.  If you want
a real nightmare scenario in that area, consider this:

	int x[20];

	int *p = x + n;
	int *q = x + m;

	p - q
	((char *)p - (char *)q)/4
	((char *)p - (char *)q)/sizeof(int)

The first two are equivalent on all targets we care about.  However, an
attempt to make the second one "more portable" silently creates the
code that'll do something entirely different as soon as we get m > n...
