Return-Path: <linux-kernel-owner+w=401wt.eu-S934115AbZKYBPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115AbZKYBPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934067AbZKYBPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:15:37 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:62619 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891AbZKYBPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=HtvV1/dzzERhJH6NoZmebwnq3C1Gs4dDOEpdJoDXMaP+PISpJK1uNLzOWE2H6X+fIt
         iN/yAMbp+CFR3qRy18jQlr5yFe7X0LiIyKgYtm5/Bnf7HEjmL4jzg8HMvMyq28iPdIsz
         HZ8PiEHDauyht/ff5NI7GYVD/icDsxqv6aJ4c=
MIME-Version: 1.0
Date: Wed, 25 Nov 2009 12:15:42 +1100
Message-ID: <d45a3acc0911241715k6882aa3el64a50b3d68d12167@mail.gmail.com>
Subject: [PATCH 2/3] X25: Check for errors in x25_init
From: andrew hendry <andrew.hendry@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-x25@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds error checking to x25_init.

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

diff -uprN -X a/Documentation/dontdiff a/net/x25/af_x25.c b/net/x25/af_x25.c
--- a/net/x25/af_x25.c  2009-11-25 10:21:17.000000000 +1100
+++ b/net/x25/af_x25.c  2009-11-25 10:22:06.000000000 +1100
@@ -1659,18 +1659,31 @@ static int __init x25_init(void)
 	if (rc != 0)
 		goto out;

-	sock_register(&x25_family_ops);
+	rc = sock_register(&x25_family_ops);
+	if (rc != 0)
+		goto out_proto;

 	dev_add_pack(&x25_packet_type);

-	register_netdevice_notifier(&x25_dev_notifier);
+	rc = register_netdevice_notifier(&x25_dev_notifier);
+	if (rc != 0)
+		goto out_sock;

 	printk(KERN_INFO "X.25 for Linux Version 0.2\n");

 	x25_register_sysctl();
-	x25_proc_init();
+	rc = x25_proc_init();
+	if (rc != 0)
+		goto out_dev;
 out:
 	return rc;
+out_dev:
+	unregister_netdevice_notifier(&x25_dev_notifier);
+out_sock:
+	sock_unregister(AF_X25);
+out_proto:
+	proto_unregister(&x25_proto);
+	goto out;
 }
 module_init(x25_init);
