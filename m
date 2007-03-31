Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXCaCQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXCaCQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXCaCQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:16:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3981 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933317AbXCaCQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:16:11 -0400
Date: Sat, 31 Mar 2007 12:14:37 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [patch 32/37] CRYPTO: api: scatterwalk_copychunks() fails to advance through scatterlist
Message-ID: <20070331021437.GA31298@gondor.apana.org.au>
References: <20070330205938.984247529@mini.kroah.org> <20070330210651.GI29450@kroah.com> <460DBC4C.1060602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460DBC4C.1060602@trash.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 03:41:32AM +0200, Patrick McHardy wrote:
>
> > [CRYPTO] api: scatterwalk_copychunks() fails to advance through scatterlist
> 
> This patch seems to cause some problems, I get reproducable freezes
> on the receiving system with net-2.6.22 when sending IPsec packets
> larger than the mtu (reproduced about 10 times). Reverting this
> patch seems to fix it. In a few cases the oops also occured on the
> sending system.
> 
> Backtrace from UML (sending system):
> 
> uml:~# ping 10.0.0.1 -s 20000
> PING 10.0.0.1 (10.0.0.1) 20000(20028) bytes of data.
> BUG: soft lockup detected on CPU#0!
> Call Trace:

Indeed.  That patch was buggy.  Sorry for not catching this earlier.

This should fix the problem.

[CRYPTO] api: Use the right value when advancing scatterwalk_copychunks

In the scatterwalk_copychunks loop, We should be advancing by
len_this_page and not nbytes.  The latter is the total length.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index a664231..0f76175 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -91,7 +91,7 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		memcpy_dir(buf, vaddr, len_this_page, out);
 		scatterwalk_unmap(vaddr, out);
 
-		scatterwalk_advance(walk, nbytes);
+		scatterwalk_advance(walk, len_this_page);
 
 		if (nbytes == len_this_page)
 			break;
