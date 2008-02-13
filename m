Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbYBMShx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbYBMShx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764471AbYBMShg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:37:36 -0500
Received: from hu-out-0506.google.com ([72.14.214.239]:56123 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762782AbYBMShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UH/8SaNoV3JJW5kS7hHpgDM1KLcHzY5hv1Dmatp45bRLBWnFksr+Q29VaprqJOAdai+m2XUmyXMXIqZWvzulE0JwGUL/Xul0dWSpn8PTFj+lb64JPwbGWstqwppxu3Oq8QTSmL9UkG52PpiVZApKz/8Mhczd8wl0LANW/ZN5dgA=
Date: Wed, 13 Feb 2008 19:36:49 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: be*_add_cpu conversion
Message-ID: <20080213183628.GB6150@joi>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-2-git-send-email-marcin.slusarz@gmail.com> <47B2A98B.4050408@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2A98B.4050408@tiscali.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:25:47AM +0100, Roel Kluin wrote:
> marcin.slusarz@gmail.com wrote:
> > From: Marcin Slusarz <marcin.slusarz@gmail.com>
> > 
> > replace all:
> > big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
> > 					expression_in_cpu_byteorder);
> > with:
> > 	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
> > generated with semantic patch
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > ---
> >  crypto/lrw.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/crypto/lrw.c b/crypto/lrw.c
> > index 9d52e58..4d93928 100644
> > --- a/crypto/lrw.c
> > +++ b/crypto/lrw.c
> > @@ -92,7 +92,7 @@ struct sinfo {
> >  static inline void inc(be128 *iv)
> >  {
> >  	if (!(iv->b = cpu_to_be64(be64_to_cpu(iv->b) + 1)))
> 
> maybe you also want instead of the line above:
> 
> 	be64_add_cpu(&iv->b, 1);
> 	if (!iv->b)
> 
> > -		iv->a = cpu_to_be64(be64_to_cpu(iv->a) + 1);
> > +		be64_add_cpu(&iv->a, 1);
> >  }
> >  
> >  static inline void lrw_round(struct sinfo *s, void *dst, const void *src)
> 
I'm a bit ashamed... but here is updated patch:
---
crypto: replace all adds to big endians variables with be*_add_cpu

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Roel Kluin <12o3l@tiscali.nl>
---
 crypto/lrw.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 9d52e58..8ef664e 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -91,8 +91,9 @@ struct sinfo {
 
 static inline void inc(be128 *iv)
 {
-	if (!(iv->b = cpu_to_be64(be64_to_cpu(iv->b) + 1)))
-		iv->a = cpu_to_be64(be64_to_cpu(iv->a) + 1);
+	be64_add_cpu(&iv->b, 1);
+	if (!iv->b)
+		be64_add_cpu(&iv->a, 1);
 }
 
 static inline void lrw_round(struct sinfo *s, void *dst, const void *src)
-- 
1.5.3.7

