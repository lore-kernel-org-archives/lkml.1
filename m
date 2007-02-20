Return-Path: <linux-kernel-owner+w=401wt.eu-S964972AbXBTPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbXBTPHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXBTPHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:07:37 -0500
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:17159 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964972AbXBTPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:07:36 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <45DB0EDB.3090803@amd.com>
Date: Tue, 20 Feb 2007 16:08:11 +0100
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia/pccard deadlock fix
X-OriginalArrivalTime: 20 Feb 2007 15:07:12.0907 (UTC)
 FILETIME=[CCE1F5B0:01C75500]
X-WSS-ID: 69C5D13B2MC8681599-01-01
Content-Type: multipart/mixed;
 boundary=------------080305010609040003020609
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080305010609040003020609
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit

following patch prevents a mutex/semaphore deadlock within the pcmcia
framework when ejecting devices multiple times using pccardctl eject.

For some more details see:
http://lkml.org/lkml/2007/2/19/58

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>

-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG


--------------080305010609040003020609
Content-Type: text/plain;
 name=pcmcia-pccard-deadlock-fix.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=pcmcia-pccard-deadlock-fix.diff

index ac00424..c02bf0d 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -856,7 +856,8 @@ int pcmcia_eject_card(struct pcmcia_socket *skt)
     
 	cs_dbg(skt, 1, "user eject request\n");
 
-	mutex_lock(&skt->skt_mutex);
+	if (!mutex_trylock(&skt->skt_mutex)) 
+		return -EAGAIN;
 	do {
 		if (!(skt->state & SOCKET_PRESENT)) {
 			ret = -ENODEV;
index 18e111e..b9d3440 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1100,7 +1100,9 @@ static ssize_t pcmcia_store_allow_func_id_match(struct device *dev,
 	if (!count)
 		return -EINVAL;
 
-	mutex_lock(&p_dev->socket->skt_mutex);
+	if (!mutex_trylock(&p_dev->socket->skt_mutex)) 
+		return -EAGAIN;
+
 	p_dev->allow_func_id_match = 1;
 	mutex_unlock(&p_dev->socket->skt_mutex);
 

--------------080305010609040003020609--


