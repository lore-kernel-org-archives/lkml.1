Return-Path: <linux-kernel-owner+w=401wt.eu-S1030745AbXCMPl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030745AbXCMPl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030733AbXCMPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:41:29 -0400
Received: from stinky.trash.net ([213.144.137.162]:49549 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030745AbXCMPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:41:27 -0400
Message-ID: <45F6C716.4070104@trash.net>
Date: Tue, 13 Mar 2007 16:45:26 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       netfilter-devel@lists.netfilter.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, davem@davemloft.net,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 12/20] nfnetlink_log: fix reference counting
References: <20070310061234.465093436@mini.kroah.org> <20070310061803.GM31412@kroah.com> <20070310091445.GA26611@kroah.com>
In-Reply-To: <20070310091445.GA26611@kroah.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: multipart/mixed;
 boundary="------------020703000004020609000908"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020703000004020609000908
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Greg KH wrote:
>>[NETFILTER]: nfnetlink_log: fix reference counting
>>
> As this patch does nothing, it's now dropped.  It was my fault as the
> original patch didn't apply and I messed up using quilt here.

Sorry, I must have messed up something. I've fixed up the original
patch, this one should apply on top of the stable queue with the
broken patch removed.


--------------020703000004020609000908
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nfnetlink_log: fix reference counting

Fix reference counting (memory leak) problem in __nfulnl_send() and callers
related to packet queueing.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3ed110cfb9e71fa5f6c44720f20a8e705e9bad0c
tree 607c19476244b034aaf8c0da12f04349cd48bf90
parent 43ff9c5b97da4d085ddf5e37a12a25ed74c14d5a
author Michal Miroslaw <mirq-linux@rere.qmqm.pl> Tue, 13 Mar 2007 16:41:58 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 13 Mar 2007 16:41:58 +0100

 net/netfilter/nfnetlink_log.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 690b173..f7eafd8 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -218,10 +218,8 @@ _instance_destroy2(struct nfulnl_instanc
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
 		/* timer "holds" one reference (we have one more) */
-		if (timer_pending(&inst->timer)) {
-			del_timer(&inst->timer);
+		if (del_timer(&inst->timer))
 			instance_put(inst);
-		}
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -695,10 +693,8 @@ #endif
 		UDEBUG("flushing old skb\n");
 
 		/* timer "holds" one reference (we have another one) */
-		if (timer_pending(&inst->timer)) {
-			del_timer(&inst->timer);
+		if (del_timer(&inst->timer))
 			instance_put(inst);
-		}
 		__nfulnl_send(inst);
 
 		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {

--------------020703000004020609000908--
