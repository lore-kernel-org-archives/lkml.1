Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab0BYQeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:34:06 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50011 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0BYQeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FQYh3+3dr3BuHwm9dUnaGeq83x3KxQsBaowxnXm8txblcpvxDRu++Fw4jEU2zxgD4t
         U8ulbZpRncbv+7IRp3O9fyrLCeHsyvzqUjMaNB+fSKEoT1/hlsSVtZdQk4Wt5/LeuD4T
         mvxlIHxXcaVKQBzjaAP/NMK2rXmUCnP040t3E=
MIME-Version: 1.0
In-Reply-To: <19334.40337.651079.440912@pilspetsen.it.uu.se>
References: <4B8692E3.9030509@gmail.com>
	 <19334.40337.651079.440912@pilspetsen.it.uu.se>
Date: Thu, 25 Feb 2010 11:33:58 -0500
Message-ID: <73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 
	sha1_update()
From: Brian Gerst <brgerst@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 10:56 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Roel Kluin writes:
>  > Due to optimization A call to memset() may be removed as a dead store when
>  > the buffer is not used after its value is overwritten.
>  >
>  > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>  > ---
>  > see http://cwe.mitre.org/data/slices/2000.html#14
>  >
>  > checkpatch.pl, compile and sparse tested. Comments?
>  >
>  > diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
>  > index 0416091..86de0da 100644
>  > --- a/crypto/sha1_generic.c
>  > +++ b/crypto/sha1_generic.c
>  > @@ -49,8 +49,8 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  >      src = data;
>  >
>  >      if ((partial + len) > 63) {
>  > -            u32 temp[SHA_WORKSPACE_WORDS];
>  > -
>  > +            u32 *temp = kzalloc(SHA_WORKSPACE_WORDS * sizeof(u32),
>  > +                            GFP_KERNEL);
>  >              if (partial) {
>  >                      done = -partial;
>  >                      memcpy(sctx->buffer + partial, data, done + 64);
>  > @@ -64,6 +64,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  >              } while (done + 63 < len);
>  >
>  >              memset(temp, 0, sizeof(temp));
>  > +            kfree(temp);
>  >              partial = 0;
>  >      }
>  >      memcpy(sctx->buffer + partial, src, len - done);
>
> At best this might solve the issue right now, but it's not
> future-proof by any margin.
>
> One problem is that just like the lifetimes of auto variables are
> known to the compiler, allowing dead store elimination (DSE) on them,
> there is development going on to make malloc() and free() known to
> the compiler. I don't think it's complete yet, but once free() is
> known, the sequence "memset(p, 0, n); free(p);" will obviously be
> DSE:d just like in the current case with the auto variable.
>
> And as soon as gcc can optimize malloc() and free(), you can be sure that
> some eager kernel hacker will mark the kernel's allocators accordingly,
> and then we're back to square one.
>
> I fear that the only portable (across compiler versions) and safe
> solution is to invoke an assembly-coded dummy function with prototype
>
>        void use(void *p);
>
> and rewrite the code above as
>
>        {
>                u32 temp[...];
>                ...
>                memset(temp, 0, sizeof temp);
>                use(temp);
>        }
>
> This forces the compiler to consider the buffer live after the
> memset, so the memset cannot be eliminated.
>
> The reason the use() function needs to be in assembly code is that
> with link-time optimizations soon commonplace (LTO in gcc-4.5),
> a compiler can possibly discover that even an out-of-line function
>
>        void use(void *p) { }
>
> doesn't in fact use *p, which then enables (in theory) the
> preceeding memset() to be DSE:d.


Would barrier() (which is a simple memory clobber) after the memset work?

--
Brian Gerst
