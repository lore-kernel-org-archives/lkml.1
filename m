Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbXLIHMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbXLIHMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLIHMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:12:41 -0500
Received: from waste.org ([66.93.16.53]:58864 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbXLIHMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:12:41 -0500
Date: Sun, 9 Dec 2007 01:12:26 -0600
From: Matt Mackall <mpm@selenic.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] random: do extraction before mixing
Message-ID: <20071209071226.GW19691@waste.org>
References: <2.753618428@selenic.com> <4.753618428@selenic.com> <20071209003554.GT17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209003554.GT17037@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 07:35:54PM -0500, Theodore Tso wrote:
> On Sat, Dec 08, 2007 at 05:20:17PM -0600, Matt Mackall wrote:
> > random: do extraction before mixing
> > 
> > If an attacker manages to capture the current pool state, she can
> > determine the last 10 bytes extracted from the pool. 
> 
> That's not true; we aren't just extracting data in the
> __add_entropy_words() call.  In fact, above that, the bulk of the
> extraction comes form when we hash the entire pool, feeding back a
> portion of the hash into the pool here:
> 
> 	for (i = 0; i < r->poolinfo->poolwords; i += 16) {
> 		/* hash blocks of 16 words = 512 bits */
> 		sha_transform(buf, (__u8 *)(r->pool + i), buf + 5);
> 		/* feed back portion of the resulting hash */
> 		add_entropy_words(r, &buf[i % 5], 1);
> 	}

Ok, yes, I'd forgotten we were chaining in the final sha_transform. I
plead too many bufs and buf+5s, which I fix up in 6/6. Funny thing is
that I'd convinced myself that this attack didn't work (correct) last
year when I read the paper I mentioned earlier. But yesterday and
today I couldn't spot the problem with it. So again, I'll add an
explicit comment for future hackers and researchers.

-- 
Mathematics is the supreme nostalgia of our time.
