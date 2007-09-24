Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXIXQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXIXQig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbXIXQ1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58014 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760831AbXIXQ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:30 -0400
Date: Mon, 24 Sep 2007 09:22:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [36/50] Fix device address listing for ipv4.
Message-ID: <20070924162203.GK13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-device-address-listing-for-ipv4.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephen Hemminger <shemminger@linux-foundation.org>

commit 596e41509550447b030f7b16adaeb0138ab585a8 in mainline

Bug: http://bugzilla.kernel.org/show_bug.cgi?id=8876

Not all ips are shown by "ip addr show" command when IPs number assigned to an
interface is more than 60-80 (in fact it depends on broadcast/label etc
presence on each address).

Steps to reproduce:
It's terribly simple to reproduce:

# for i in $(seq 1 100); do ip ad add 10.0.$i.1/24 dev eth10 ; done
# ip addr show

this will _not_ show all IPs.
Looks like the problem is in netlink/ipv4 message processing.

This is fix from bug submitter, it looks correct.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/devinet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1194,7 +1194,7 @@ static int inet_dump_ifaddr(struct sk_bu
 		for (ifa = in_dev->ifa_list, ip_idx = 0; ifa;
 		     ifa = ifa->ifa_next, ip_idx++) {
 			if (ip_idx < s_ip_idx)
-				goto cont;
+				continue;
 			if (inet_fill_ifaddr(skb, ifa, NETLINK_CB(cb->skb).pid,
 					     cb->nlh->nlmsg_seq,
 					     RTM_NEWADDR, NLM_F_MULTI) <= 0)

-- 
