Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbXIKAE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbXIKAE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 20:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXIKAEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 20:04:47 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:20531 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXIKAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 20:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:sender;
        b=bJaHOeHCm0uEQwfrtL5nU81nS4k+FH9gHsNf6mP/NyEEkZxGlMHma4nl/+h8k/pQ6fX5H/2UPXmgulfHNeLA61aRt9agLvCxfnzC10Z2XdevYaQTielLEsEb2jlp5u8xUy0dQaqkbujkQb+CYXozRwwJHco+vtfs2hC6q40+1b0=
Subject: Re: 2.6.23-rc5: possible irq lock inversion dependency detected
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070910130024.GA27939@gondor.apana.org.au>
References: <alpine.DEB.0.999.0709021455510.7103@sheep.housecafe.de>
	 <20070910130024.GA27939@gondor.apana.org.au>
Content-Type: multipart/mixed; boundary="=-AXrL5eGz+7zP0sPzLQwn"
Date: Mon, 10 Sep 2007 20:04:41 -0400
Message-Id: <1189469081.14002.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AXrL5eGz+7zP0sPzLQwn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-10-09 at 21:00 +0800, Herbert Xu wrote:


> The minimal fix would be to make sure that we disable BH on
> the first CPU. 

disabling BH would make it more symmetric to the way we handle
egress. I couldnt reproduce the issue, but this should hopefully resolve
it.
Christian, can you test with this patch?

cheers,
jamal





--=-AXrL5eGz+7zP0sPzLQwn
Content-Disposition: attachment; filename=ing1
Content-Type: text/plain; name=ing1; charset=us-ascii
Content-Transfer-Encoding: 7bit

[NET_SCHED] make ingress qlock symmetric to egress

Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

--- a/net/sched/sch_generic.c	2007/09/10 23:19:45	1.1
+++ b/net/sched/sch_generic.c	2007/09/10 23:52:45
@@ -42,12 +42,12 @@
 void qdisc_lock_tree(struct net_device *dev)
 {
 	spin_lock_bh(&dev->queue_lock);
-	spin_lock(&dev->ingress_lock);
+	spin_lock_bh(&dev->ingress_lock);
 }
 
 void qdisc_unlock_tree(struct net_device *dev)
 {
-	spin_unlock(&dev->ingress_lock);
+	spin_unlock_bh(&dev->ingress_lock);
 	spin_unlock_bh(&dev->queue_lock);
 }
 

--=-AXrL5eGz+7zP0sPzLQwn--

