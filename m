Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbZD3V0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbZD3V0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757711AbZD3V0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:26:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36414 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbZD3V0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:26:10 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: print self-test pass notices in fips mode
Date: Thu, 30 Apr 2009 17:25:05 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-102.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
References: <200904282121.35300.jarod@redhat.com> <200904290921.54483.jarod@redhat.com> <200904290924.11005.jarod@redhat.com>
In-Reply-To: <200904290924.11005.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301725.06671.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009 09:24:10 Jarod Wilson wrote:
> On Wednesday 29 April 2009 09:21:53 Jarod Wilson wrote:
> > On Wednesday 29 April 2009 09:18:17 Herbert Xu wrote:
> > > On Tue, Apr 28, 2009 at 09:21:35PM -0400, Jarod Wilson wrote:
> > > >
> > > > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > > > index 39ffa69..d0cc85c 100644
> > > > --- a/crypto/testmgr.c
> > > > +++ b/crypto/testmgr.c
> > > > @@ -2149,6 +2149,10 @@ notest:
> > > >  test_done:
> > > >  	if (fips_enabled && rc)
> > > >  		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
> > > > +	/* fips mode requires we print out self-test success notices */
> > > > +	if (fips_enabled && !rc && strncmp(alg, "ctr(aes", 7))
> > > > +		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
> > > > +		       driver, alg);
> > > 
> > > What is this strncmp crap for?
> > 
> > To avoid claiming we successfully self-tested ctr(aes) when its
> > not actually directly testable. Was intended to go sort of hand
> > in hand with the other patch to suppress 'no self test' messages
> > for ctr(aes) when in fips mode. Of course, since at this point,
> > we've run ecb(aes), and that's what's suggested as the way to
> > test ctr(aes)[*], perhaps we don't need to
> > suppress it.
> > 
> > [*] well, along with the sign-off from the lab that the counter
> > code is acceptable
> 
> So this might actually be another argument in favor of adding a "this
> algo isn't really testable" flag as Neil suggested...

According to our FIPS CAVS testing lab guru, when we're in fips mode,
we must print out notices of successful self-test completion for
every alg to be compliant.

New and improved v2, without strncmp crap. Doesn't need to touch a flag
though, due to not moving the notest label around anymore.

Applies atop '[PATCH v2] crypto: catch base cipher self-test failures
in fips mode'.

Personally, I wouldn't mind seeing this info printed out regardless of
whether or not we're in fips mode, I think its useful info, but will
stick with only in fips mode for now.

---
 crypto/testmgr.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d410fad..b3ec7b9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2245,6 +2245,10 @@ test_done:
 	if (fips_enabled && rc)
 		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
 
+	if (fips_enabled && !rc)
+		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
+		       driver, alg);
+
 	return rc;
 
 notest:


-- 
Jarod Wilson
jarod@redhat.com
