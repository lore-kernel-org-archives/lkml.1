Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYJQSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYJQSGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYJQSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:06:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYJQSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:06:08 -0400
Date: Fri, 17 Oct 2008 20:05:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081017180523.GA11590@elte.hu>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ada3aiv9k6j.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

>  > diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
>  > index c83f88c..d1230a8 100644
>  > --- a/drivers/net/mlx4/mcg.c
>  > +++ b/drivers/net/mlx4/mcg.c
>  > @@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
>  >  
>  >  	if (block_mcast_loopback)
>  >  		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
>  > -						       (1 << MGM_BLCK_LB_BIT));
>  > +						       (1U << MGM_BLCK_LB_BIT));
> 
> This is fixing a warning caused by a gcc bug 
> (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37261) which is fixed 
> upstream.  The change is rather inoffensive but on the other hand I'm 
> not sure what our policy for dealing with version-specific warning 
> bugs in gcc should be.

the full commit is below - i researched it when i created it and indeed 
it seemed like an incorrect warning.

OTOH, there should be a well-defined work flow to keep this all 
manageable: once we know why a warning triggers and it has been 
categorized by a human, we should get rid of the warning in some way. 

Applying this patch as-is would be one option. Annotating it with a 
specific gcc version would be overkill i think. Ignoring it would be 
bad, because there's real value in standardizing on a "no warnings" 
build output. Many new warnings get introduced because people do not 
notice new warnings amongst the very high baseline noise of the kernel 
build.

What do you think?

	Ingo

--------->
>From 367bb845bef83d64cfee452a18a84fd65f21d401 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 18 Aug 2008 16:18:34 +0200
Subject: [PATCH] fix warning in drivers/net/mlx4/mcg.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix warning:

  drivers/net/mlx4/mcg.c: In function ‘mlx4_multicast_attach’:
  drivers/net/mlx4/mcg.c:217: warning: integer overflow in expression

there was no real danger of overflow here though.

md5:
   db8eb55620f886c03854a2abb2ce6c3f  mcg.o.before.asm
   db8eb55620f886c03854a2abb2ce6c3f  mcg.o.after.asm

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/mlx4/mcg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index c83f88c..d1230a8 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	if (block_mcast_loopback)
 		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
-						       (1 << MGM_BLCK_LB_BIT));
+						       (1U << MGM_BLCK_LB_BIT));
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 
