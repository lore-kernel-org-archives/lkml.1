Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0BYP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:56:12 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:49876 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314Ab0BYP4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:56:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19334.40337.651079.440912@pilspetsen.it.uu.se>
Date: Thu, 25 Feb 2010 16:56:01 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Mikael Pettersson <mikpe@it.uu.se>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in sha1_update()
In-Reply-To: <4B8692E3.9030509@gmail.com>
References: <4B8692E3.9030509@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin writes:
 > Due to optimization A call to memset() may be removed as a dead store when
 > the buffer is not used after its value is overwritten.
 > 
 > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
 > ---
 > see http://cwe.mitre.org/data/slices/2000.html#14
 > 
 > checkpatch.pl, compile and sparse tested. Comments?
 > 
 > diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
 > index 0416091..86de0da 100644
 > --- a/crypto/sha1_generic.c
 > +++ b/crypto/sha1_generic.c
 > @@ -49,8 +49,8 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 >  	src = data;
 >  
 >  	if ((partial + len) > 63) {
 > -		u32 temp[SHA_WORKSPACE_WORDS];
 > -
 > +		u32 *temp = kzalloc(SHA_WORKSPACE_WORDS * sizeof(u32),
 > +				GFP_KERNEL);
 >  		if (partial) {
 >  			done = -partial;
 >  			memcpy(sctx->buffer + partial, data, done + 64);
 > @@ -64,6 +64,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 >  		} while (done + 63 < len);
 >  
 >  		memset(temp, 0, sizeof(temp));
 > +		kfree(temp);
 >  		partial = 0;
 >  	}
 >  	memcpy(sctx->buffer + partial, src, len - done);

At best this might solve the issue right now, but it's not
future-proof by any margin.

One problem is that just like the lifetimes of auto variables are
known to the compiler, allowing dead store elimination (DSE) on them,
there is development going on to make malloc() and free() known to
the compiler. I don't think it's complete yet, but once free() is
known, the sequence "memset(p, 0, n); free(p);" will obviously be
DSE:d just like in the current case with the auto variable.

And as soon as gcc can optimize malloc() and free(), you can be sure that
some eager kernel hacker will mark the kernel's allocators accordingly,
and then we're back to square one.

I fear that the only portable (across compiler versions) and safe
solution is to invoke an assembly-coded dummy function with prototype

	void use(void *p);

and rewrite the code above as

	{
		u32 temp[...];
		...
		memset(temp, 0, sizeof temp);
		use(temp);
	}

This forces the compiler to consider the buffer live after the
memset, so the memset cannot be eliminated.

The reason the use() function needs to be in assembly code is that
with link-time optimizations soon commonplace (LTO in gcc-4.5),
a compiler can possibly discover that even an out-of-line function

	void use(void *p) { }

doesn't in fact use *p, which then enables (in theory) the
preceeding memset() to be DSE:d.
