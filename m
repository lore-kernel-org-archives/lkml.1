Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbXCESzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbXCESzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbXCESzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:55:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:33118 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbXCESzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:55:38 -0500
From: Olaf Kirch <olaf.kirch@oracle.com>
To: nfs@lists.sourceforge.net
Subject: Re: [NFS] [PATCH 001 of 3] knfsd: Use recv_msg to get peer address for NFSD instead of code-copying
Date: Mon, 5 Mar 2007 19:53:23 +0100
User-Agent: KMail/1.9.1
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070302151748.5226.patches@notabene> <1070302042825.5760@suse.de>
In-Reply-To: <1070302042825.5760@suse.de>
Organization: Oracle
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051953.24900.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 05:28, NeilBrown wrote:
> The sunrpc server code needs to know the source and destination address
> for UDP packets so it can reply properly.
> It currently copies code out of the network stack to pick the pieces out
> of the skb.
> This is ugly and causes compile problems with the IPv6 stuff.

... and this IPv6 code could never have worked anyway:


>  	case AF_INET6: {
...
> -			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
... this should have been sizeof(sockaddr_in6)...

> -			/* Remember which interface received this request */
> -			ipv6_addr_copy(&rqstp->rq_daddr.addr6,
> -							&skb->nh.ipv6h->saddr);
.... and this should have copied from daddr, not saddr.

But I find using recvmsg just for getting at the addresses
a little awkward too. And I think to be on the safe side, you
should check that you're really looking at a PKTINFO cmsg
rather than something else.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
