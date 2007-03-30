Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbXC3VVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbXC3VVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXC3VUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:20:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58287 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXC3VKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:32 -0400
Date: Fri, 30 Mar 2007 14:04:42 -0700
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
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/37] DCCP: Fix exploitable hole in DCCP socket options
Message-ID: <20070330210442.GP29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dccp-fix-exploitable-hole-in-dccp-socket-options.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

[DCCP] getsockopt: Fix DCCP_SOCKOPT_[SEND,RECV]_CSCOV

We were only checking if there was enough space to put the int, but
left len as specified by the (malicious) user, sigh, fix it by setting
len to sizeof(val) and transfering just one int worth of data, the one
asked for.

Also check for negative len values.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/dccp/proto.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -575,7 +575,7 @@ static int do_dccp_getsockopt(struct soc
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	if (len < sizeof(int))
+	if (len < (int)sizeof(int))
 		return -EINVAL;
 
 	dp = dccp_sk(sk);
@@ -589,9 +589,11 @@ static int do_dccp_getsockopt(struct soc
 					       (__be32 __user *)optval, optlen);
 	case DCCP_SOCKOPT_SEND_CSCOV:
 		val = dp->dccps_pcslen;
+		len = sizeof(val);
 		break;
 	case DCCP_SOCKOPT_RECV_CSCOV:
 		val = dp->dccps_pcrlen;
+		len = sizeof(val);
 		break;
 	case 128 ... 191:
 		return ccid_hc_rx_getsockopt(dp->dccps_hc_rx_ccid, sk, optname,

-- 
