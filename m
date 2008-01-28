Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYA1WmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYA1WmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYA1WmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:42:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:50835 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYA1Wl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:41:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version:content-type;
        b=MxrJcjFOwGVXZV8cdFIxLh7UbQuhz7cGiyuT4ghkToh9b+jqb/7OiOHvysgxrKJfdFByGBBiBUwUhFfyvgrwMWj/Ca02nGNWDi7+Nyn+fuj7EAh7fFxPALAS+2uaLhJdpioA4yEmCwJWUFU6HJET3IYVNouus/GORRGY7zQGSsA=
Date: Tue, 29 Jan 2008 06:41:06 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: lkml <linux-kernel@vger.kernel.org>, cups-bugs <cups-bugs@easysw.com>,
       Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
       Krzysztof Piotr Oledzki <ole@ans.pl>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, cups-bugs@easysw.com
Subject: Re: cups slow on linux-2.6.24
Message-ID: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Jan 28, 2008 7:18 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> I'm sending printing jobs to a network printer (it's actually printing
> to the localhost simply creating a file), and running this on
> Linux-2.6.24 will cause the printing to slow down to 1 print every 3
> seconds after printing 500 times.

I bisected the kernel since the last known good 2.6.23 and zeroed in to 
this commit.

commit 17311393f969090ab060540bd9dbe7dc885a76d5
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Thu Oct 11 14:35:52 2007 -0700

     [NETFILTER]: nf_conntrack_tcp: fix connection reopening


Reverting this commit solves the problem.

Version              1000 jobs
2.6.23                 90 sec
2.6.24              1,492 sec  <== with commit
2.6.24(patch)          90 sec  <== reverted the commit


Since the code has changed an can't simply revert the commit for the 
latest linux git download, I made a patch to revert the above commit. I've 
tested and it's working, but don't know if it breaks other things. Please 
review.

Thanks,
Jeff.


--- net/netfilter/nf_conntrack_proto_tcp.c.org	2008-01-29 03:34:43 +0800
+++ net/netfilter/nf_conntrack_proto_tcp.c	2008-01-29 03:36:26 +0800
@@ -836,8 +836,8 @@
  			break;
  		if ((conntrack->proto.tcp.seen[!dir].flags &
  			IP_CT_TCP_FLAG_CLOSE_INIT)
-		    || (conntrack->proto.tcp.last_dir == dir
-		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
+		    || after(ntohl(th->seq),
+		        conntrack->proto.tcp.seen[dir].td_end)) {
  			/* Attempt to reopen a closed/aborted connection.
  			 * Delete this connection and look up again. */
  			write_unlock_bh(&tcp_lock);
@@ -845,6 +845,12 @@
  				conntrack->timeout.function((unsigned long)
  							    conntrack);
  			return -NF_REPEAT;
+		} else {
+			write_unlock_bh(&tcp_lock);
+			if (LOG_INVALID(IPPROTO_TCP))
+				nf_log_packet(pf, 0, skb, NULL, NULL,
+					NULL, "nf_ct_tcp: invalid SYN");
+			return -NF_ACCEPT;
  		}
  		/* Fall through */
  	case TCP_CONNTRACK_IGNORE:


