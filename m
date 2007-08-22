Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXHVIxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXHVIxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbXHVIw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:28 -0400
Received: from 1wt.eu ([62.212.114.60]:1874 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbXHVIw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:26 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083941.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:47 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 03/58] SCTP scope_id handling fix
Content-Disposition: inline; filename=0003-SCTP-scope_id-handling-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SCTP: Add scope_id validation for link-local binds

SCTP currently permits users to bind to link-local addresses,
but doesn't verify that the scope id specified at bind matches
the interface that the address is configured on.  It was report
that this can hang a system.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sctp/ipv6.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ef36be0..c00c73c 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -874,6 +874,10 @@ static int sctp_inet6_send_verify(struct sctp_sock *opt, union sctp_addr *addr)
 			dev = dev_get_by_index(addr->v6.sin6_scope_id);
 			if (!dev)
 				return 0;
+			if (!ipv6_chk_addr(&addr->v6.sin6_addr, dev, 0)) {
+				dev_put(dev);
+				return 0;
+			}
 			dev_put(dev);
 		}
 		af = opt->pf->af;
-- 
1.5.2.5

-- 
