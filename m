Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYBEBS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYBEBS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbYBEBSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:18:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:45068 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764AbYBEBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version:content-type;
        b=jX0PxRPFtXw1QnlW1urzDI2PfMwBcl+EjS6zw13OlayYR0D8cs6KiyIyZmP8I94AmWTpfKpIK+6xRE2wuSgWkD9vZOiZxx4Hm1RERN2Z2gfDIEzz/9Otxvfs4FxoC+P6PC3gzZiHkZxK0ClFf+47q/oUKLf8dtxJK5lOlmuyGqE=
Date: Tue, 5 Feb 2008 09:17:57 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
cc: Patrick McHardy <kaber@trash.net>, lkml <linux-kernel@vger.kernel.org>,
       Krzysztof Piotr Oledzki <ole@ans.pl>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: cups slow on linux-2.6.24
Message-ID: <Pine.LNX.4.64.0802050913560.6704@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Feb 5, 2008 4:17 AM, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

> Actively closed connections are not handled properly, i.e. the initiator 
> of the active close should not be taken into account. So could you give 
> a try to the patch below? Does it just suppress the 'invalid packed 
> ignored' and all other kernel messages or both suppresses them and 
> produces normal printing speed?

Jozsef,

Amazing! You fixed it. No more 'invalid packed ignored', and speed back to 
normal (continues after approx. 20 seconds of pausing after 503 prints).

I used the latest git, and have to modify your patch slightly to make it 
work (changing "conntrack" to "ct").


Thank you for fixing this.

Jeff


Here's your patch modified so it'll apply to the latest git.

--- a/net/netfilter/nf_conntrack_proto_tcp.c.org	2008-02-05 08:29:39 +0800
+++ a/net/netfilter/nf_conntrack_proto_tcp.c	2008-02-05 08:28:05 +0800
@@ -125,7 +125,7 @@
   * CLOSE_WAIT:	ACK seen (after FIN)
   * LAST_ACK:	FIN seen (after FIN)
   * TIME_WAIT:	last ACK seen
- * CLOSE:	closed connection
+ * CLOSE:	closed connection (RST)
   *
   * LISTEN state is not used.
   *
@@ -824,9 +824,23 @@
  	case TCP_CONNTRACK_SYN_SENT:
  		if (old_state < TCP_CONNTRACK_TIME_WAIT)
  			break;
-		if ((ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_CLOSE_INIT)
-		    || (ct->proto.tcp.last_dir == dir
-		        && ct->proto.tcp.last_index == TCP_RST_SET)) {
+		/* RFC 1122: "When a connection is closed actively,
+		 * it MUST linger in TIME-WAIT state for a time 2xMSL
+		 * (Maximum Segment Lifetime). However, it MAY accept
+		 * a new SYN from the remote TCP to reopen the connection
+		 * directly from TIME-WAIT state, if..."
+		 * We ignore the conditions because we are in the
+		 * TIME-WAIT state anyway.
+		 *
+		 * Handle aborted connections: we and the server
+		 * think there is an existing connection but the client
+		 * aborts it and starts a new one.
+		 */
+		if (((ct->proto.tcp.seen[dir].flags
+		      | ct->proto.tcp.seen[!dir].flags)
+		     & IP_CT_TCP_FLAG_CLOSE_INIT)
+ 		    || (ct->proto.tcp.last_dir == dir
+ 		        && ct->proto.tcp.last_index == TCP_RST_SET)) {
  			/* Attempt to reopen a closed/aborted connection.
  			 * Delete this connection and look up again. */
  			write_unlock_bh(&tcp_lock);
@@ -838,15 +852,23 @@
  	case TCP_CONNTRACK_IGNORE:
  		/* Ignored packets:
  		 *
+		 * Our connection entry may be out of sync, so ignore
+		 * packets which may signal the real connection between
+		 * the client and the server.
+		 *
  		 * a) SYN in ORIGINAL
  		 * b) SYN/ACK in REPLY
  		 * c) ACK in reply direction after initial SYN in original.
+		 *
+		 * If the ignored packet is invalid, the receiver will send 
+		 * a RST we'll catch below.
  		 */
  		if (index == TCP_SYNACK_SET
  		    && ct->proto.tcp.last_index == TCP_SYN_SET
  		    && ct->proto.tcp.last_dir != dir
  		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
  			/* This SYN/ACK acknowledges a SYN that we earlier
+			/* b) This SYN/ACK acknowledges a SYN that we earlier
  			 * ignored as invalid. This means that the client and
  			 * the server are both in sync, while the firewall is
  			 * not. We kill this session and block the SYN/ACK so
@@ -924,8 +946,7 @@

  	ct->proto.tcp.state = new_state;
  	if (old_state != new_state
-	    && (new_state == TCP_CONNTRACK_FIN_WAIT
-		|| new_state == TCP_CONNTRACK_CLOSE))
+	    && new_state == TCP_CONNTRACK_FIN_WAIT)
  		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
  	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
  		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
