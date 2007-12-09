Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbXLIAgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbXLIAgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXLIAgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:36:07 -0500
Received: from THUNK.ORG ([69.25.196.29]:46150 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbXLIAgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:36:06 -0500
Date: Sat, 8 Dec 2007 19:35:54 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] random: do extraction before mixing
Message-ID: <20071209003554.GT17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <4.753618428@selenic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4.753618428@selenic.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 05:20:17PM -0600, Matt Mackall wrote:
> random: do extraction before mixing
> 
> If an attacker manages to capture the current pool state, she can
> determine the last 10 bytes extracted from the pool. 

That's not true; we aren't just extracting data in the
__add_entropy_words() call.  In fact, above that, the bulk of the
extraction comes form when we hash the entire pool, feeding back a
portion of the hash into the pool here:

	for (i = 0; i < r->poolinfo->poolwords; i += 16) {
		/* hash blocks of 16 words = 512 bits */
		sha_transform(buf, (__u8 *)(r->pool + i), buf + 5);
		/* feed back portion of the resulting hash */
		add_entropy_words(r, &buf[i % 5], 1);
	}

So the buf[0..5] contains a hash of the entire pool, and every 16
words, we're already mixing 32 bits into the pool.  So even if the
attacker captures the current pool state, she's not going to be able
to undo the intermediate SHA values that had been mixed into the pool.

> By mixing after
> the extraction, this is made substantially harder.

Not that much harder; as I mentioned as comments in my last patch, we
are doing a linear polynomial mixing for speed purposes, so relying on
the mixing to obscure the extraction isn't going to help much.

But that's OK, we don't need to depend on that.  Note the amount of
feedback that we do in the above loop.

					- Ted
