Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXKSSY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXKSSY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXKSSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:21:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49161 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXKSSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:21:55 -0500
Date: Mon, 19 Nov 2007 10:18:54 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/26] Fix error returns in sys_socketpair()
Message-ID: <20071119181854.GK15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-error-returns-in-sys_socketpair.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Miller <davem@davemloft.net>

patch bf3c23d171e35e6e168074a1514b0acd59cfd81a in mainline.

[NET]: Fix error reporting in sys_socketpair().

If either of the two sock_alloc_fd() calls fail, we
forget to update 'err' and thus we'll erroneously
return zero in these cases.

Based upon a report and patch from Rich Paul, and
commentary from Chuck Ebbert.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1246,11 +1246,14 @@ asmlinkage long sys_socketpair(int famil
 		goto out_release_both;
 
 	fd1 = sock_alloc_fd(&newfile1);
-	if (unlikely(fd1 < 0))
+	if (unlikely(fd1 < 0)) {
+		err = fd1;
 		goto out_release_both;
+	}
 
 	fd2 = sock_alloc_fd(&newfile2);
 	if (unlikely(fd2 < 0)) {
+		err = fd2;
 		put_filp(newfile1);
 		put_unused_fd(fd1);
 		goto out_release_both;

-- 
