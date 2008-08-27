Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYH0VnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYH0VnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYH0VnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:43:09 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:11044 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYH0VnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:43:08 -0400
X-IronPort-AV: E=Sophos;i="4.32,282,1217808000"; 
   d="scan'208";a="78736968"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org
Subject: C language lawyers needed
X-Message-Flag: Warning: May contain useful information
Date: Wed, 27 Aug 2008 14:43:05 -0700
Message-ID: <adaod3ef82e.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Aug 2008 21:43:06.0096 (UTC) FILETIME=[E3BC7700:01C9088D]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone explain why building the current kernel gives

    drivers/net/mlx4/mcg.c: In function 'mlx4_multicast_attach':
    drivers/net/mlx4/mcg.c:217: warning: integer overflow in expression

(with gcc (Ubuntu 4.3.1-9ubuntu1) 4.3.1 on x86-64), while the patch
below gets rid of the warning?  I can't see what is overflowing in the
expression that is warned out.

MGM_BLCK_LB_BIT is 30, and 1 << 30 is not negative or close to
overflowing.  And MGM_QPN_MASK is 0x00FFFFFF, which is also nowhere near
to integer overflow.

A fairly small test case that I don't understand either is:

unsigned foo(int x)
{
	return (((x & 0xffffff) | (1 << 30)) & 0xff000000) >> 24;
}

just running "gcc -c" (ie no extra warnings enabled) on that produces
the same:

    b.c: In function 'foo':
    b.c:3: warning: integer overflow in expression

I'm sure there's some promotion rule or something that makes sense of
this, but it's a mystery to me...

Thanks,
  Roland

diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index c83f88c..6af5c6d 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	if (block_mcast_loopback)
 		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
-						       (1 << MGM_BLCK_LB_BIT));
+						       (1u << MGM_BLCK_LB_BIT));
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 
