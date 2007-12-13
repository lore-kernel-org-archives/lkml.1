Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbXLMGmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbXLMGmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbXLMGhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56330 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015AbXLMGh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:29 -0500
Date: Wed, 12 Dec 2007 22:34:45 -0800
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
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 16/36] TCP: Problem bug with sysctl_tcp_congestion_control
	function
Message-ID: <20071213063445.GQ25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-problem-bug-with-sysctl_tcp_congestion_control-function.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------


From: Sam Jansen <sjansen@google.com>

[TCP]: Problem bug with sysctl_tcp_congestion_control function

[ Upstream commit: 5487796f0c9475586277a0a7a91211ce5746fa6a ]

sysctl_tcp_congestion_control seems to have a bug that prevents it
from actually calling the tcp_set_default_congestion_control
function. This is not so apparent because it does not return an error
and generally the /proc interface is used to configure the default TCP
congestion control algorithm.  This is present in 2.6.18 onwards and
probably earlier, though I have not inspected 2.6.15--2.6.17.

sysctl_tcp_congestion_control calls sysctl_string and expects a successful
return code of 0. In such a case it actually sets the congestion control
algorithm with tcp_set_default_congestion_control. Otherwise, it returns the
value returned by sysctl_string. This was correct in 2.6.14, as sysctl_string
returned 0 on success. However, sysctl_string was updated to return 1 on
success around about 2.6.15 and sysctl_tcp_congestion_control was not updated.
Even though sysctl_tcp_congestion_control returns 1, do_sysctl_strategy
converts this return code to '0', so the caller never notices the error.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/sysctl_net_ipv4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -121,7 +121,7 @@ static int sysctl_tcp_congestion_control
 
 	tcp_get_default_congestion_control(val);
 	ret = sysctl_string(&tbl, name, nlen, oldval, oldlenp, newval, newlen);
-	if (ret == 0 && newval && newlen)
+	if (ret == 1 && newval && newlen)
 		ret = tcp_set_default_congestion_control(val);
 	return ret;
 }

-- 
