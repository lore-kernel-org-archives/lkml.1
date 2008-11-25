Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYKYI6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYKYI6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKYI6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:58:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYKYI6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:58:36 -0500
Date: Tue, 25 Nov 2008 09:58:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Message-ID: <20081125085820.GA11401@elte.hu>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081011021357.GB3685@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Noticed the bug below while running our -Werror x86 randconfig build 
tests against tip/master. Please double check my control flow 
analysis.

	Ingo

---------->
>From e5c3b90a18b73d593bba2a3f927a79469b6218d7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Nov 2008 09:47:28 +0100
Subject: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

this warning:

  crypto/testmgr.c: In function ‘test_comp’:
  crypto/testmgr.c:829: warning: ‘ret’ may be used uninitialized in this function

triggers because GCC correctly notices that in the ctcount == 0 &&
dtcount != 0 input condition case this function can return an undefined
value, if the second loop fails.

Remove the shadowed 'ret' variable from the second loop that was probably
unintended.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 crypto/testmgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b828c6c..0cf0ae3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -853,7 +853,7 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 	}
 
 	for (i = 0; i < dtcount; i++) {
-		int ilen, ret, dlen = COMP_BUF_SIZE;
+		int ilen, dlen = COMP_BUF_SIZE;
 
 		memset(result, 0, sizeof (result));
 

