Return-Path: <linux-kernel-owner+w=401wt.eu-S934951AbXEHJxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951AbXEHJxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934938AbXEHJxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:53:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2657 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934924AbXEHJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:53:10 -0400
Date: Tue, 8 May 2007 19:52:56 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1+hotfix -- Slab corruption -- Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
Message-ID: <20070508095255.GA20522@gondor.apana.org.au>
References: <a44ae5cd0705071157m241ec3c1k8c60aaf213a28166@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0705071157m241ec3c1k8c60aaf213a28166@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 11:57:28AM -0700, Miles Lane wrote:
> [  118.442018] ieee80211_crypt: registered algorithm 'WEP'
> [  118.514572] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [  118.514664] Slab corruption: size-256 start=c6aabe98, len=256
> [  118.514672] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> [  118.514676] Last user: [<c01b0cfa>](cryptomgr_probe+0x6c/0x9a)
> [  118.514692] 000: 10 55 ac c6 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> [  118.514715] Prev obj: start=c6aabd80, len=256
> [  118.514721] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> [  118.514725] Last user: [<c01afd85>](crypto_alloc_instance+0x1d/0xc0)
> [  118.514734] 000: e0 71 39 c0 80 6e 39 c0 88 bd aa c6 88 bd aa c6
> [  118.514753] 010: 04 00 00 00 01 00 00 00 04 00 00 00 00 00 00 00

Oops.  Does this patch fix the problem for you?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/cryptomgr.c b/crypto/cryptomgr.c
index 6958ea8..e5fb7cc 100644
--- a/crypto/cryptomgr.c
+++ b/crypto/cryptomgr.c
@@ -24,8 +24,6 @@
 #include "internal.h"
 
 struct cryptomgr_param {
-	struct task_struct *thread;
-
 	struct rtattr *tb[CRYPTOA_MAX];
 
 	struct {
@@ -81,6 +79,7 @@ err:
 
 static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 {
+	struct task_struct *thread;
 	struct cryptomgr_param *param;
 	const char *name = larval->alg.cra_name;
 	const char *p;
@@ -130,8 +129,8 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
-	param->thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
-	if (IS_ERR(param->thread))
+	thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
+	if (IS_ERR(thread))
 		goto err_free_param;
 
 	return NOTIFY_STOP;
