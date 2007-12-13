Return-Path: <linux-kernel-owner+w=401wt.eu-S1761255AbXLMHSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbXLMHSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762426AbXLMG63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55689 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781AbXLMG62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:28 -0500
Date: Wed, 12 Dec 2007 22:53:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 53/60] TCP: illinois: Incorrect beta usage
Message-ID: <20071213065332.GC6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-illinois-incorrect-beta-usage.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

[TCP] illinois: Incorrect beta usage

[ Upstream commit: a357dde9df33f28611e6a3d4f88265e39bcc8880 ]

Lachlan Andrew observed that my TCP-Illinois implementation uses the
beta value incorrectly:
The parameter  beta  in the paper specifies the amount to decrease
*by*:  that is, on loss,
 W <-  W -  beta*W
but in   tcp_illinois_ssthresh() uses  beta  as the amount
to decrease  *to*: W <- beta*W

This bug makes the Linux TCP-Illinois get less-aggressive on uncongested network,
hurting performance. Note: since the base beta value is .5, it has no
impact on a congested network.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_illinois.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -298,7 +298,7 @@ static u32 tcp_illinois_ssthresh(struct 
 	struct illinois *ca = inet_csk_ca(sk);
 
 	/* Multiplicative decrease */
-	return max((tp->snd_cwnd * ca->beta) >> BETA_SHIFT, 2U);
+	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->beta) >> BETA_SHIFT), 2U);
 }
 
 

-- 
