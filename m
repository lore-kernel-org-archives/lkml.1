Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZCSE50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZCSE50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZCSE5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:57:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:48891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZCSE5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:57:16 -0400
Date: Wed, 18 Mar 2009 21:58:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, dipankar@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Question about usage of RCU in the input layer
Message-ID: <20090318215812.15496a86@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the input layer does a "synchronize_rcu()" after a list_add_tail_rcu(), which
is costing me 1 second of boot time.....
And based on my understanding of the RCU concept, you only need to synchronize on delete,
not on addition... so I think the synchronize is entirely redundant here...

Can I have my second of boot time back please ? 



diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1730d73..d69ec56 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1544,7 +1544,6 @@ int input_register_handle(struct input_handle *handle)
 		return error;
 	list_add_tail_rcu(&handle->d_node, &dev->h_list);
 	mutex_unlock(&dev->mutex);
-	synchronize_rcu();
 
 	/*
 	 * Since we are supposed to be called from ->connect()

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
