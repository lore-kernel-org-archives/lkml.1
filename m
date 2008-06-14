Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYFNANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYFNANt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbYFNAMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:51643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759991AbYFNAMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:32 -0400
Date: Fri, 13 Jun 2008 17:10:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sami Liedes <sliedes@cc.hut.fi>,
       Al Viro <viro@zeniv.linux.org.uk>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 05/47] double-free of inode on alloc_file() failure exit in
	create_write_pipe()
Message-ID: <20080614001026.GE24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="double-free-of-inode-on-alloc_file-failure-exit-in-create_write_pipe.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Al Viro <viro@zeniv.linux.org.uk>

upstream commit: ed1524371716466e9c762808b02601d0d0276a92

Duh...  Fortunately, the bug is quite recent (post-2.6.25) and, embarrassingly,
mine ;-/

http://bugzilla.kernel.org/show_bug.cgi?id=10878

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/pipe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -988,7 +988,10 @@ struct file *create_write_pipe(void)
 	return f;
 
  err_dentry:
+	free_pipe_info(inode);
 	dput(dentry);
+	return ERR_PTR(err);
+
  err_inode:
 	free_pipe_info(inode);
 	iput(inode);

-- 
