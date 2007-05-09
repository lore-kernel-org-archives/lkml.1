Return-Path: <linux-kernel-owner+w=401wt.eu-S1033369AbXEIDDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033369AbXEIDDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033315AbXEIDDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:03:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4321 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1033225AbXEIDDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:03:10 -0400
Date: Wed, 9 May 2007 13:02:57 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070509030257.GA31876@gondor.apana.org.au>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <4640FE35.2070605@gmail.com> <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com> <464108CC.3060604@gmail.com> <Pine.LNX.4.64.0705081639570.16372@schroedinger.engr.sgi.com> <46411CA1.8060506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46411CA1.8060506@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 09:58:09PM -0300, Kevin Winchester wrote:
>
> Not having any idea what I'm doing, I looked at cryptomgr_probe and 
> cryptomgr_notify, and can't seem to see much, except for the following 
> odd lines.
> 
> From cryptomgr_schedule_probe, which is almost certainly inlined into 
> crypto_notify:

Thanks for reporting this.  This patch should fix the problem.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff -puN crypto/cryptomgr.c~crypto-fix crypto/cryptomgr.c
--- a/crypto/cryptomgr.c~crypto-fix
+++ a/crypto/cryptomgr.c
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
@@ -130,8 +129,8 @@ static int cryptomgr_schedule_probe(stru
 
 	memcpy(param->larval.name, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
-	param->thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
-	if (IS_ERR(param->thread))
+	thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
+	if (IS_ERR(thread))
 		goto err_free_param;
 
 	return NOTIFY_STOP;
_
