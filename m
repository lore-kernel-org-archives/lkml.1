Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXDZRAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXDZRAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXDZRAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:00:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39533 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbXDZQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:51 -0400
Date: Thu, 26 Apr 2007 09:56:04 -0700
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
       "Aubrey.Li" <aubreylee@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/33] Fix netpoll UDP input path
Message-ID: <20070426165604.GP1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-netpoll-udp-input-path.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Aubrey.Li <aubreylee@gmail.com>

Netpoll UDP input handler needs to pull up the UDP headers
and handle receive checksum offloading properly just like
the normal UDP input path does else we get corrupted
checksums.

[NET]: Fix UDP checksum issue in net poll mode.

In net poll mode, the current checksum function doesn't consider the
kind of packet which is padded to reach a specific minimum length. I
believe that's the problem causing my test case failed. The following
patch fixed this issue.

Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/netpoll.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -471,6 +471,13 @@ int __netpoll_rx(struct sk_buff *skb)
 	if (skb->len < len || len < iph->ihl*4)
 		goto out;
 
+	/*
+	 * Our transport medium may have padded the buffer out.
+	 * Now We trim to the true length of the frame.
+	 */
+	if (pskb_trim_rcsum(skb, len))
+		goto out;
+
 	if (iph->protocol != IPPROTO_UDP)
 		goto out;
 

-- 
