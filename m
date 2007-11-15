Return-Path: <linux-kernel-owner+w=401wt.eu-S1765730AbXKOG1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765730AbXKOG1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764613AbXKOGWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45935 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763515AbXKOGWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:03 -0500
Date: Wed, 14 Nov 2007 22:20:32 -0800
From: Greg KH <gregkh@suse.de>
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
Subject: [patch 09/23] Fix error returns in sys_socketpair()
Message-ID: <20071115062032.GJ8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-error-returns-in-sys_socketpair.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1245,11 +1245,14 @@ asmlinkage long sys_socketpair(int famil
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
