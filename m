Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYESRBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYESRBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYESRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:00:54 -0400
Received: from khc.piap.pl ([195.187.100.11]:35892 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbYESRAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:00:53 -0400
To: jeff@garzik.org
Cc: alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       paulkf@microgate.com, jchapman@katalix.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] WAN: protect HDLC proto list while insmod/rmmod
References: <20080424.065555.30390704.davem@davemloft.net>
	<m3ve27nfpx.fsf@maximus.localdomain>
	<20080424214457.1d5a1655@the-village.bc.nu>
	<20080512.033244.153113922.davem@davemloft.net>
	<m3lk2djbq3.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 19 May 2008 19:00:51 +0200
In-Reply-To: <m3lk2djbq3.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Wed\, 14 May 2008 14\:45\:24 +0200")
Message-ID: <m3ve1agrek.fsf_-_@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WAN: protect protocol list in hdlc.c with RTNL.
    
Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -42,8 +42,7 @@ static const char* version = "HDLC support module revision 1.22";
 
 #undef DEBUG_LINK
 
-static struct hdlc_proto *first_proto = NULL;
-
+static struct hdlc_proto *first_proto;
 
 static int hdlc_change_mtu(struct net_device *dev, int new_mtu)
 {
@@ -313,21 +312,25 @@ void detach_hdlc_protocol(struct net_device *dev)
 
 void register_hdlc_protocol(struct hdlc_proto *proto)
 {
+	rtnl_lock();
 	proto->next = first_proto;
 	first_proto = proto;
+	rtnl_unlock();
 }
 
 
 void unregister_hdlc_protocol(struct hdlc_proto *proto)
 {
-	struct hdlc_proto **p = &first_proto;
-	while (*p) {
-		if (*p == proto) {
-			*p = proto->next;
-			return;
-		}
+	struct hdlc_proto **p;
+
+	rtnl_lock();
+	p = &first_proto;
+	while (*p != proto) {
+		BUG_ON(!*p);
 		p = &((*p)->next);
 	}
+	*p = proto->next;
+	rtnl_unlock();
 }
 
 
