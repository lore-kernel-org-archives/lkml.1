Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbZCXRP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbZCXRP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763006AbZCXROl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:14:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:51696 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763134AbZCXROh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:14:37 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+uihttNxuuuu3hCbIvq3glLfEohnCaMrbksYk7Gt
	jq46Fafh606tEj
From: sinter <sinter.salt@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: BUG in 2.6.29 final: broken network connection
Date: Tue, 24 Mar 2009 18:12:14 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29; KDE/4.2.1; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241812.14577.sinter.salt@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

ftp, ping, IP forwarding, IP masquerading etc., in short: everything having to 
do with networking is broken using kernel 2.6.29.

My thousand thanks for that again go to Mr. David S. Miller, kernel 
contributor of the netdev section, who again and again is adding his SOB under 
untested crap code that itself breaks networking hardware by reaching the 
kernel mainline via git patches.

In the past exactly that happened again and again, and it is particularly Mr. 
David S. Miller himself who, proven by facts, is not willing to learn to stay 
away from sending in malicious code via the git path.
I am really wondering why Linus Torvalds is still trusting him, as it is a 
fact that not everybody can send in code just like that, i. e. without 
restrictions.

It cost me almost 1 complete day (and again I do state that this is not the 
first time that some unqualified hacker operating with the responsibility of Mr. 
David S. Miller deeply sucks and steals my nerves and wastes my time) to find 
out that the following patch needs to be reverted to make networking services 
in 2.6.29 final available again for everybody.

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2588,9 +2588,9 @@ static int process_backlog(struct napi_struct *napi, int 
quota)
                local_irq_disable();
                skb = __skb_dequeue(&queue->input_pkt_queue);
                if (!skb) {
-                       __napi_complete(napi);
                        local_irq_enable();
-                       break;
+                       napi_complete(napi);
+                       goto out;
                }
                local_irq_enable();
 
@@ -2599,6 +2599,7 @@ static int process_backlog(struct napi_struct *napi, int 
quota)
 
        napi_gro_flush(napi);
 
+out:
        return work;
 }
 
@@ -2671,7 +2672,7 @@ void netif_napi_del(struct napi_struct *napi)
        struct sk_buff *skb, *next;
 
        list_del_init(&napi->dev_list);
-       kfree(napi->skb);
+       kfree_skb(napi->skb);
 
        for (skb = napi->gro_list; skb; skb = next) {
                next = skb->next;

Best wishes

Uwe

