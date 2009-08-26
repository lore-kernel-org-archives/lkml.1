Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbZHZLfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbZHZLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZHZLfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:35:23 -0400
Received: from netasq.netasq.com ([213.30.137.178]:22914 "EHLO
	netasq.netasq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZHZLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:35:23 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 07:35:22 EDT
Date: Wed, 26 Aug 2009 13:12:47 +0200
From: Clement LECIGNE <clement.lecigne@netasq.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] 8 bytes kernel memory disclosure in AppleTalk getsockname.
Message-ID: <20090826111247.GA79673@clem1.netasq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In function atalk_getname(), sockaddr_at is returned in userland without
zero'ing the "char sat_zero[8]" field. This bug allows user to display 8
bytes leaked from the kernel stack.

Here is a patch that zero the whole sockaddr_at structure before
processing it. It should fix this bug.

Signed-off-by: Clément Lecigne <clement.lecigne@netasq.com>
--- linux/net/appletalk/ddp.c	2009-08-26 11:35:59.000000000 +0200
+++ linux/net/appletalk/ddp.c	2009-08-26 11:36:30.000000000 +0200
@@ -1241,6 +1241,8 @@ static int atalk_getname(struct socket *
 		if (atalk_autobind(sk) < 0)
 			return -ENOBUFS;
 
+	memset(&sat, 0, sizeof(struct sockaddr_at));
+
 	*uaddr_len = sizeof(struct sockaddr_at);
 
 	if (peer) {

-- 
Clément LECIGNE,
-Only one remote hole in the default install, in more than 10 years!<br>
+Only two remote holes in the default install, in more than 10 years!<br>

