Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZLWPYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZLWPYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZLWPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:24:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:39858 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682AbZLWPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:24:05 -0500
Date: Wed, 23 Dec 2009 23:23:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <error27@gmail.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: double unlock in rng_dev_read()
Message-ID: <20091223152355.GA31379@gondor.apana.org.au>
References: <20091223131552.GA17923@bicker> <20091223143658.GA30992@gondor.apana.org.au> <20091223145336.GB23721@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223145336.GB23721@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 04:53:36PM +0200, Dan Carpenter wrote:
>
> No no.  I mean when size hits zero we are rng_mutex is unlocked.

Good catch! I'll add this patch to the tree.  Please take a look
at it.  Thanks!

commit f5908267b67917b8cbd98b27fd2be9b5f62ec76f
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Dec 23 23:22:34 2009 +0800

    hwrng: core - Fix double unlock in rng_dev_read
    
    When the loop terminates with size == 0 in rng_dev_read we will
    unlock the rng mutex twice.
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e989f67..3d9c61e 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -158,10 +158,11 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out;
 		}
 	}
-out_unlock:
-	mutex_unlock(&rng_mutex);
 out:
 	return ret ? : err;
+out_unlock:
+	mutex_unlock(&rng_mutex);
+	goto out;
 }
 
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
