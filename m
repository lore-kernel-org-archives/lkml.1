Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbXEWHQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbXEWHQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbXEWHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:16:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:7331 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbXEWHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CIX2gbQWvS6uG0Z+4U95xvuTbCpIEqGFkKninq73jcoutmOgUupFszGm+70oH6GwouGsR6BweiNffLHGTztz15IeoQei1G6Y/FtAfn48TYkIkJ2fWezxyfh7v3Y6pWqJHn91qJljFACsbs/0OvSpzMGvDGI7Fh9Vs9jilhXPmIM=
Message-ID: <a8e1da0705230016t163f7296v2dbff1de958264a@mail.gmail.com>
Date: Wed, 23 May 2007 07:16:42 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc1-mm1 cifs_mount oops
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Steven French" <sfrench@us.ibm.com>
In-Reply-To: <20070522202133.552d1a94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705221750y6f4fb251m53f3efab1f017f4@mail.gmail.com>
	 <20070522192231.6d1a94df.akpm@linux-foundation.org>
	 <a8e1da0705221959i7b01deb7vdd641ef0ed31e63e@mail.gmail.com>
	 <20070522202133.552d1a94.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Yeah, that's racy: once we've sent the signal, the kernel thread can write
> NULL to srvTcp->tsk at any time.

Yes, here is another patch :

diff -ur linux/fs/cifs/connect.c linux.new/fs/cifs/connect.c
--- linux/fs/cifs/connect.c     2007-05-23 10:59:13.000000000 +0000
+++ linux.new/fs/cifs/connect.c 2007-05-23 15:16:11.000000000 +0000
@@ -650,6 +650,7 @@

        spin_lock(&GlobalMid_Lock);
        server->tcpStatus = CifsExiting;
+       kthread_stop(server->tsk);
        server->tsk = NULL;
        /* check if we have blocked requests that need to free */
        /* Note that cifs_max_pending is normally 50, but
@@ -2070,7 +2071,6 @@
                        spin_unlock(&GlobalMid_Lock);
                        if (srvTcp->tsk) {
                                send_sig(SIGKILL,srvTcp->tsk,1);
-                               kthread_stop(srvTcp->tsk);
                        }
                }
                 /* If find_unc succeeded then rc == 0 so we can not end */

Regards
dave
