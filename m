Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbYDQL2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbYDQL2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYDQL2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:28:11 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38730 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752531AbYDQL2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:28:09 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: CRYPTO xcbc: Fix crash when ipsec uses xcbc-mac with big data chunk
Date: Thu, 17 Apr 2008 14:26:12 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Joy Latten <latten@austin.ibm.com>
References: <20080417010122.148289106@sous-sol.org> <20080417010337.793546930@sous-sol.org>
In-Reply-To: <20080417010337.793546930@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804171426.15334.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

17 Nis 2008 Per tarihinde, Chris Wright şunları yazmıştı: 
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Joy Latten <latten@austin.ibm.com>
> 
> upstream commit: 1edcf2e1ee2babb011cfca80ad9d202e9c491669
> 
> The kernel crashes when ipsec passes a udp packet of about 14XX bytes
> of data to aes-xcbc-mac.
> 
> It seems the first xxxx bytes of the data are in first sg entry,
> and remaining xx bytes are in next sg entry. But we don't
> check next sg entry to see if we need to go look the page up.
> 
> I noticed in hmac.c, we do a scatterwalk_sg_next(), to do this check
> and possible lookup, thus xcbc.c needs to use this routine too.
> 
> A 15-hour run of an ipsec stress test sending streams of tcp and
> udp packets of various sizes,  using this patch and
> aes-xcbc-mac completed successfully, so hopefully this fixes the
> problem.
> 
> Signed-off-by: Joy Latten <latten@austin.ibm.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  crypto/xcbc.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> --- a/crypto/xcbc.c
> +++ b/crypto/xcbc.c
> @@ -116,13 +116,11 @@ static int crypto_xcbc_digest_update2(st
>  	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
>  	struct crypto_cipher *tfm = ctx->child;
>  	int bs = crypto_hash_blocksize(parent);
> -	unsigned int i = 0;
>  
> -	do {
> -
> -		struct page *pg = sg_page(&sg[i]);
> -		unsigned int offset = sg[i].offset;
> -		unsigned int slen = sg[i].length;
> +	for (;;) {
> +		struct page *pg = sg_page(sg);
> +		unsigned int offset = sg->offset;
> +		unsigned int slen = sg->length;
>  
>  		if (unlikely(slen > nbytes))
>  			slen = nbytes;
> @@ -182,8 +180,11 @@ static int crypto_xcbc_digest_update2(st
>  			offset = 0;
>  			pg++;
>  		}
> -		i++;
> -	} while (nbytes>0);
> +
> +		if (!nbytes)
> +			break;
> +		sg = scatterwalk_sg_next(sg);
> +	}
>  
>  	return 0;
>  }
> 

zangetsu linux-2.6.24 # make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  LD      crypto/built-in.o
  CC [M]  crypto/xcbc.o
crypto/xcbc.c: In function `crypto_xcbc_digest_update2':
crypto/xcbc.c:186: error: implicit declaration of function `scatterwalk_sg_next'
crypto/xcbc.c:186: warning: assignment makes pointer from integer without a cast
make[1]: *** [crypto/xcbc.o] Hata 1
make: *** [crypto] Hata 2

Cheeers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
