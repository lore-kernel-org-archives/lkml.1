Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbXC3VTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbXC3VTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXC3VLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:11:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51440 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXC3VKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:50 -0400
Date: Fri, 30 Mar 2007 14:04:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Alexey Dobriyan <adobriyan@sw.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 16/37] NET: Fix sock_attach_fd() failure in sys_accept()
Message-ID: <20070330210455.GS29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-sock_attach_fd-failure-in-sys_accept.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@sw.ru>

[NET]: Correct accept(2) recovery after sock_attach_fd()

* d_alloc() in sock_attach_fd() fails leaving ->f_dentry of new file NULL
* bail out to out_fd label, doing fput()/__fput() on new file
* but __fput() assumes valid ->f_dentry and dereferences it

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1368,7 +1368,7 @@ asmlinkage long sys_accept(int fd, struc
 
 	err = sock_attach_fd(newsock, newfile);
 	if (err < 0)
-		goto out_fd;
+		goto out_fd_simple;
 
 	err = security_socket_accept(sock, newsock);
 	if (err)
@@ -1401,6 +1401,11 @@ out_put:
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
+out_fd_simple:
+	sock_release(newsock);
+	put_filp(newfile);
+	put_unused_fd(newfd);
+	goto out_put;
 out_fd:
 	fput(newfile);
 	put_unused_fd(newfd);

-- 
