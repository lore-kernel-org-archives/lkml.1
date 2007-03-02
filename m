Return-Path: <linux-kernel-owner+w=401wt.eu-S1422860AbXCBEaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422860AbXCBEaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422869AbXCBEaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:30:03 -0500
Received: from ns1.suse.de ([195.135.220.2]:43132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854AbXCBE3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:29:36 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 2 Mar 2007 15:28:30 +1100
Message-Id: <1070302042830.5777@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH 002 of 3] knfsd: Avoid checksum checks when collecting metadata for a UDP packet.
References: <20070302151748.5226.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When recv_msg is called with a size of 0 and MSG_PEEK (and
sunrpc/svcsock.c does), it is clear that we only interested in
metadata (from/to addresses) and not the data, so don't do any
checksum checking at this point.  Leave that until the data is
requested.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/ipv4/udp.c |    3 +++
 ./net/ipv6/udp.c |    4 ++++
 2 files changed, 7 insertions(+)

diff .prev/net/ipv4/udp.c ./net/ipv4/udp.c
--- .prev/net/ipv4/udp.c	2007-03-02 14:20:13.000000000 +1100
+++ ./net/ipv4/udp.c	2007-03-02 15:13:50.000000000 +1100
@@ -846,6 +846,9 @@ try_again:
 			goto csum_copy_err;
 		copy_only = 1;
 	}
+	if (len == 0 &&  (flags & MSG_PEEK))
+		/* avoid checksum concerns when just getting metadata */
+		copy_only = 1;
 
 	if (copy_only)
 		err = skb_copy_datagram_iovec(skb, sizeof(struct udphdr),

diff .prev/net/ipv6/udp.c ./net/ipv6/udp.c
--- .prev/net/ipv6/udp.c	2007-03-02 14:20:13.000000000 +1100
+++ ./net/ipv6/udp.c	2007-03-02 15:13:50.000000000 +1100
@@ -151,6 +151,10 @@ try_again:
 		copy_only = 1;
 	}
 
+	if (len == 0 &&  (flags & MSG_PEEK))
+		/* avoid checksum concerns when just getting metadata */
+		copy_only = 1;
+
 	if (copy_only)
 		err = skb_copy_datagram_iovec(skb, sizeof(struct udphdr),
 					      msg->msg_iov, copied       );
