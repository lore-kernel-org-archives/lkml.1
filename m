Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZBQUc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZBQUc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZBQUcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:32:18 -0500
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:42344 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZBQUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:32:17 -0500
Message-ID: <499B1ECF.2020809@numericable.fr>
Date: Tue, 17 Feb 2009 21:32:15 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH] SMACK smacklabel : apply &MASK to IP inserted in /smack/netlabel
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <fa.c87eBVWyCqqi9h1c54QlwKDAIbg@ifi.uio.no> <fa.f7jv/+EnhNJziduAqQS3XHiU6/A@ifi.uio.no> <fa.1A5YyyPb1uCn//vnk7baNJGI0IM@ifi.uio.no> <fa.HFpMNTzIQ1+pODZB3+XkfnipCfo@ifi.uio.no> <fa.3IBoeBnwT1eZcqeO6DAE1tHBYc4@ifi.uio.no> <499B178B.9090601@numericable.fr>
In-Reply-To: <499B178B.9090601@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

with current code it is possible to insert inconsistent IP/mask in /smack/netlabel

before patch :
==============

root@etienne-desktop:/home/etienne/linux-2.6# cat /smack/netlabel
12.67.3.2/15 @
12.67.3.1/15 @
12.67.2.1/15 @
12.67.2.1/16 @
12.67.1.1/16 @
0.0.0.0/0 @

the solution is to apply the mask to the IP inserted in /smack/netlabel

after the patch:
================
root@etienne-desktop:/home/etienne/linux-2.6# echo 12.67.3.2/15 @ > /smack/netlabel           
root@etienne-desktop:/home/etienne/linux-2.6# cat /smack/netlabel                             
12.67.0.0/15 @                                                                                
root@etienne-desktop:/home/etienne/linux-2.6# echo 12.67.3.1/15 @ > /smack/netlabel                             
root@etienne-desktop:/home/etienne/linux-2.6# cat /smack/netlabel                             
12.67.0.0/15 @                                                                                
root@etienne-desktop:/home/etienne/linux-2.6# echo 12.67.3.3/15 @ > /smack/netlabel                             
root@etienne-desktop:/home/etienne/linux-2.6# cat /smack/netlabel                             
12.67.0.0/15 @                                                  

regards,
Etienne

Signed-off-by: <etienen.basset@numericable.fr>
----
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 8e42800..5717150 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -765,6 +765,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
                mask.s_addr |= bebits;
                bebits <<= 1;
        }
+       newname.sin_addr.s_addr &= mask.s_addr;
        /*
         * Only allow one writer at a time. Writes should be
         * quite rare and small in any case.


