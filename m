Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXBLUVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXBLUVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965330AbXBLUVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:21:11 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:49545 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292AbXBLUVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:21:10 -0500
Date: Mon, 12 Feb 2007 21:20:52 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20 +0/14] nfnetlink_log: patch series season 2
Message-ID: <20070212202052.GA28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212003738.GA8262@rere.qmqm.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

As it turned out, not all worms eating nfnetlink_log have been exterminated
by my last patch series. I'll append next four patches to the end of the
series and I hope that it doesn't make your patching scripts unhappy.

Those patches fix two bugs and make two other code beautifications:

  11. procfs file handling - don't pass seq_file when you don't have to
* 12. nfulnl_recv_config() - don't modify what isn't there
* 13. __nfulnl_send() and friends - return your books timely
  14. __nfulnl_send() - don't prove the obvious

There are some other bugs I found that I'm looking for a fix. One of them
is wrong /proc/net/netfilter/nfnetlink_log contents:

natownica:~# cat /proc/net/netfilter/nfnetlink_log
    0  -4100     0 2 65535    100  1
    2  -4099     2 2 65535    100  2
    4  15355     0 2 65535    100  1

Those three entries are created by a single ulogd2 listening in three
packet logging groups. I believe that's some problem with generating
the file contents because after shutting down ulogd all disappear.

The two groups: 2, 4 are stuffed with packets by those iptables rules:

natownica:~# iptables-save |grep NFLOG
-A LOG_and_DROP_fakenet -m hashlimit --hashlimit 1/sec --hashlimit-mode \
	srcip --hashlimit-name fw_fakenet_src -j NFLOG --nflog-prefix \
	"fakenet" --nflog-group 2 --nflog-threshold 30
-A LOG_and_DROP_p2p -m hashlimit --hashlimit 1/sec --hashlimit-mode srcip \
	--hashlimit-name fw_p2p_src -j NFLOG --nflog-prefix "p2p" \
	--nflog-group 2 --nflog-threshold 30
-A invalid -m mark --mark 0x3000/0x3000 -j NFLOG --nflog-prefix \
	"nonregistered" --nflog-group 3
-A invalid -j NFLOG --nflog-prefix "invalid" --nflog-group 2

As you can see, there's no group 4 among the rules - 3 is. This seems to
be xt_NFLOG's fault, but I haven't looked there yet.

Greets,
Michal Miroslaw

