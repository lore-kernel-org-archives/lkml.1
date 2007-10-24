Return-Path: <linux-kernel-owner+w=401wt.eu-S1764710AbXJXQ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764710AbXJXQ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764237AbXJXQo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:44:56 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:59003 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764235AbXJXQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JzNZjRwLDpmeBSYl40JhruS/I259DfoYzpPM1rsm003ahaHw5/a8nMa9tQlBgWR+XJLwwoFC60635XPkNicUudkWVneH6Bjw2Scw8f2Mi0a6R8mypuhSclHNY8V+W8nwhjcszzd12+WSoyRqjHaacNeZRL1lRHrEIamgF9hSTrc=
Date: Wed, 24 Oct 2007 12:44:46 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
Message-ID: <20071024164445.GA6452@nineveh.local>
Mail-Followup-To: Romano Giannetti <romanol@upcomillas.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <1193232344.32208.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193232344.32208.0.camel@localhost>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 03:25:44PM +0200, Romano Giannetti wrote:
>
> Hi,
>
> 2.6.23-rc1 fails for me. I have the sensation it is network-related, but
> I am not sure, so I send this message just to the list.
> This same failure was present in git-5734-gd85714d, I sent
> a message to the list but it seems it never arrived. I hope this will
> pass through. My system is a toshiba satellite A305-S5077, dual core pentium.
>
> The symptoms are quite strange. At boot, NetworkManager fails to activate
> my eth0 (r8169). Just stopping/restarting NM will make it works.


Denis V. Lunev wrote a patch for the NetworkManager thing a day or two
ago (which DaveM has queued).

Since netlink is involved in the traces you sent, this might do something
for the other too.

The patch I recieved follows:


> Revert to original netlink behavior. Do not reply with ACK if the
> netlink dump has bees successfully started.

> libnl has been broken by the cd40b7d3983c708aabe3d3008ec64ffce56d33b0
> The following command reproduce the problem:
>    /nl-route-get 192.168.1.1

> Signed-off-by: Denis V. Lunev <den@openvz.org>



diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 98e313e..44a8b41 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1565,7 +1565,10 @@ int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 
 	netlink_dump(sk);
 	sock_put(sk);
-	return 0;
+
+	/* We successfully started a dump, by returning -EINTR we
+	 * signal not to send ACK even if it was requested */
+	return -EINTR;
 }
 
 void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err)
@@ -1619,17 +1622,21 @@ int netlink_rcv_skb(struct sk_buff *skb, int (*cb)(struct sk_buff *,
 
 		/* Only requests are handled by the kernel */
 		if (!(nlh->nlmsg_flags & NLM_F_REQUEST))
-			goto skip;
+			goto ack;
 
 		/* Skip control messages */
 		if (nlh->nlmsg_type < NLMSG_MIN_TYPE)
-			goto skip;
+			goto ack;
 
 		err = cb(skb, nlh);
-skip:
+		if (err == -EINTR)
+			goto skip;
+
+ack:
 		if (nlh->nlmsg_flags & NLM_F_ACK || err)
 			netlink_ack(skb, nlh, err);
 
+skip:
 	        msglen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (msglen > skb->len)
 			msglen = skb->len;





--
Joseph Fannin
jfannin@gmail.com
