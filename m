Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbZBWQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbZBWQll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbZBWQlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:41:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZBWQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:41:19 -0500
Date: Tue, 24 Feb 2009 00:41:12 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: mpatocka@redhat.com
Subject: net: amend the fix for SO_BSDCOMPAT gsopt infoleak
Message-ID: <20090223164112.GA29425@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix for CVE-2009-0676 (upstream commit df0bca04) is incomplete. Note
that the same problem of leaking kernel memory will reappear if someone
on some architecture uses struct timeval with some internal padding (for
example tv_sec 64-bit and tv_usec 32-bit) --- then, you are going to
leak the padded bytes to userspace.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>

diff --git a/net/core/sock.c b/net/core/sock.c
index 6f2e133..913c95f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -696,7 +696,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 	if (len < 0)
 		return -EINVAL;
 
-	v.val = 0;
+	memset(&v, 0, sizeof(v));
 
 	switch(optname) {
 	case SO_DEBUG:
