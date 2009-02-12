Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZBLMgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZBLMgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZBLMgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:36:08 -0500
Received: from netasq.netasq.com ([213.30.137.178]:33473 "EHLO
	netasq.netasq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbZBLMgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:36:07 -0500
Date: Thu, 12 Feb 2009 13:35:45 +0100
From: Clement LECIGNE <clement.lecigne@netasq.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt try
	#2
Message-ID: <20090212123545.GA46788@clem1.netasq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In function sock_getsockopt() located in net/core/sock.c, optval v.val
is not correctly initialized and directly returned in userland in case
we have SO_BSDCOMPAT option set.

This dummy code should trigger the bug:

int main(void)
{
	unsigned char buf[4] = { 0, 0, 0, 0 };
	int len;
	int sock;
	sock = socket(33, 2, 2);
	getsockopt(sock, 1, SO_BSDCOMPAT, &buf, &len);
	printf("%x%x%x%x\n", buf[0], buf[1], buf[2], buf[3]);
	close(sock);
}

Here is a patch that fix this bug by initalizing v.val just after its declaration.

--- linux/net/core/sock.c.orig	2008-12-12 12:27:46.000000000 -0800
+++ linux/net/core/sock.c	2008-12-12 12:27:50.000000000 -0800
@@ -695,6 +695,8 @@ int sock_getsockopt(struct socket *sock,
 	if (len < 0)
 		return -EINVAL;
 
+	v.val = 0;
+
 	switch(optname) {
 	case SO_DEBUG:
 		v.val = sock_flag(sk, SOCK_DBG);

Signed-off-by: Clément Lecigne <clement.lecigne@netasq.com>

-- 
Clément LECIGNE,
"In Python, how do you create a string of random characters?" -- "Read a Perl file!"
