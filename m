Return-Path: <linux-kernel-owner+w=401wt.eu-S1422858AbXCBE30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858AbXCBE30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422854AbXCBE30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:29:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:58927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422853AbXCBE3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:29:25 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 Mar 2007 15:28:19 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH 000 of 3] knfsd: Resolve IPv6 related link error
Message-ID: <20070302151748.5226.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current mainline has a compile linkage problem if both
  CONFIG_IPV6=m
  CONFIG_SUNRPC=y

because net/sunrpc/svcsock.c conditionally used a function defined in the IPv6 module.

These three patches resolve the issue.

The problem is caused because svcsock needs to get the source and
destination address for a udp packet, but doesn't want to just use
sock_recvmsg like userspace would as it wants to be able to use the
data directly out of the skbuff rather than copying it (when practical).

Currently it copies code from udp.c (both ipv4/ and ipv6/) and this
causes the problem.

This patch changes it to use kernel_recvmsg with a length of 0 and
flags of MSG_PEEK to get the addresses but leave the data untouched.

A small problem here is that kernel_recvmsg always checks the
checksum, so in the case of a large packet we will check the checksum
at a different time to when we copy it out into a buffer, which is not ideal.

So the second patch of this series avoids the check when recv_msg is
called with size==0 and flags==MSG_PEEK.  This change should be acked
by someone on netdev before going upsteam!!!  The rest of the series
is still appropriate without the patch, it is just a small
optimisation.

Finally the last patch removes all the
  #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
from sunrpc as it really isn't needed and just hides this sort of problem.

Patches 1 and 3 are suitable for 2.6.21.  Patch 2 needs confirmation.

Thanks,
NeilBrown

 [PATCH 001 of 3] knfsd: Use recv_msg to get peer address for NFSD instead of code-copying
 [PATCH 002 of 3] knfsd: Avoid checksum checks when collecting metadata for a UDP packet.
 [PATCH 003 of 3] knfsd: Remove CONFIG_IPV6 ifdefs from sunrpc server code.
