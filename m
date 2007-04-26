Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXDZRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXDZRAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXDZRAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:00:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39549 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbXDZQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:58 -0400
Date: Thu, 26 Apr 2007 09:56:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Olaf Kirch <olaf.kirch@oracle.com>, Samuel Ortiz <samuel@sortiz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/33] Fix IRDA oopser
Message-ID: <20070426165614.GQ1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-irda-oops-er.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Olaf Kirch <olaf.kirch@oracle.com>

This fixes and OOPS due to incorrect socket orpahning in the
IRDA stack.

[IrDA]: Correctly handling socket error

This patch fixes an oops first reported in mid 2006 - see
http://lkml.org/lkml/2006/8/29/358 The cause of this bug report is that
when an error is signalled on the socket, irda_recvmsg_stream returns
without removing a local wait_queue variable from the socket's sk_sleep
queue. This causes havoc further down the road.

In response to this problem, a patch was made that invoked sock_orphan on
the socket when receiving a disconnect indication. This is not a good fix,
as this sets sk_sleep to NULL, causing applications sleeping in recvmsg
(and other places) to oops.

This is against the latest net-2.6 and should be considered for -stable
inclusion.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/af_irda.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -138,7 +138,6 @@ static void irda_disconnect_indication(v
 		sk->sk_shutdown |= SEND_SHUTDOWN;
 
 		sk->sk_state_change(sk);
-                sock_orphan(sk);
 		release_sock(sk);
 
 		/* Close our TSAP.
@@ -1446,7 +1445,7 @@ static int irda_recvmsg_stream(struct ki
 			 */
 			ret = sock_error(sk);
 			if (ret)
-				break;
+				;
 			else if (sk->sk_shutdown & RCV_SHUTDOWN)
 				;
 			else if (noblock)

-- 
