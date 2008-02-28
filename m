Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbYB1Rvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbYB1Rvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYB1RvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:51:22 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58205 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761386AbYB1RvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:51:20 -0500
Date: Fri, 29 Feb 2008 01:50:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>,
       Beschorner Daniel <Daniel.Beschorner@facton.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: zlib oops with ipcomp in 2.6.24
Message-ID: <20080228175011.GA17185@gondor.apana.org.au>
References: <3C59DB883F7B0B4D8096010D45ACCD134F210D@exch.facton.local> <20080223000328.3a71e858.akpm@linux-foundation.org> <3C59DB883F7B0B4D8096010D45ACCD134F2112@exch.facton.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C59DB883F7B0B4D8096010D45ACCD134F2112@exch.facton.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 02:22:38PM +0100, Beschorner Daniel wrote:
>
> lookahead = -1 strstart = 185
> ------------[ cut here ]------------
> kernel BUG at lib/zlib_deflate/deflate.c:1255!
> invalid opcode: 0000 [1] SMP
> CPU 0
> Modules linked in:
> Pid: 3978, comm: httpd Not tainted 2.6.24 #10

OK I've finally found the bug which I must've been subconsciously
ignoring :)

[IPCOMP]: Disable BH on output when using shared tfm

Because we use shared tfm objects in order to conserve memory,
(each tfm requires 128K of vmalloc memory), BH needs to be turned
off on output as that can occur in process context.

Previously this was done implicitly by the xfrm output code.
That was lost when it became lockless.  So we need to add the
BH disabling to IPComp directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index ae1f45f..008b41f 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -108,8 +109,11 @@ static int ipcomp_compress(struct xfrm_state *x, struct sk_buff *skb)
 	const int cpu = get_cpu();
 	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
 	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
-	int err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
+	int err;
 
+	local_bh_disable();
+	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
+	local_bh_enable();
 	if (err)
 		goto out;
 
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index b900395..e3dcfa2 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -146,7 +146,9 @@ static int ipcomp6_output(struct xfrm_state *x, struct sk_buff *skb)
 	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
 	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
 
+	local_bh_disable();
 	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
+	local_bh_enable();
 	if (err || (dlen + sizeof(*ipch)) >= plen) {
 		put_cpu();
 		goto out_ok;
