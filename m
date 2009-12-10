Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZLJG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZLJG7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZLJG7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:59:13 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:59227 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZLJG7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:59:11 -0500
Date: Thu, 10 Dec 2009 07:59:15 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH 2/2] net: use compat helper functions in compat_sys_recvmmsg
Message-ID: <20091210065914.GB4144@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Use (get|put)_compat_timespec helper functions to simplify the code.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 net/compat.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/net/compat.c
===================================================================
--- linux-2.6.orig/net/compat.c
+++ linux-2.6/net/compat.c
@@ -763,15 +763,12 @@ asmlinkage long compat_sys_recvmmsg(int 
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
 
-	if (get_user(ktspec.tv_sec, &timeout->tv_sec) ||
-	    get_user(ktspec.tv_nsec, &timeout->tv_nsec))
+	if (get_compat_timespec(&ktspec, timeout))
 		return -EFAULT;
 
 	datagrams = __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				   flags | MSG_CMSG_COMPAT, &ktspec);
-	if (datagrams > 0 &&
-	    (put_user(ktspec.tv_sec, &timeout->tv_sec) ||
-	     put_user(ktspec.tv_nsec, &timeout->tv_nsec)))
+	if (datagrams > 0 && put_compat_timespec(&ktspec, timeout))
 		datagrams = -EFAULT;
 
 	return datagrams;
