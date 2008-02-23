Return-Path: <linux-kernel-owner+w=401wt.eu-S935239AbYBWAgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935239AbYBWAgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764889AbYBWAdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:33:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764301AbYBWAda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:33:30 -0500
Date: Fri, 22 Feb 2008 16:29:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
       chris@sous-sol.org, Dave Chinner <dgc@sgi.com>,
       Lachlan McIlroy <lachlan@sgi.com>
Subject: [patch 07/38] XFS: Fix oops in xfs_file_readdir()
Message-ID: <20080223002956.GH7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfs-fix-oops-in-xfs_file_readdir.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
 
 From: David Chinner <dgc@sgi.com>

patch 450790a2c51e6d9d47ed30dbdcf486656b8e186f in mainline.

Several occurrences of oops in xfs_file_readdir() on ia32 have been
reported since 2.6.24 was released. This is a regression introduced
in 2.6.24 and is relatively easy to hit. The patch below fixes the
problem.


Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -350,8 +350,8 @@ xfs_file_readdir(
 
 		size = buf.used;
 		de = (struct hack_dirent *)buf.dirent;
-		curr_offset = de->offset /* & 0x7fffffff */;
 		while (size > 0) {
+			curr_offset = de->offset /* & 0x7fffffff */;
 			if (filldir(dirent, de->name, de->namlen,
 					curr_offset & 0x7fffffff,
 					de->ino, de->d_type)) {
@@ -362,7 +362,6 @@ xfs_file_readdir(
 				       sizeof(u64));
 			size -= reclen;
 			de = (struct hack_dirent *)((char *)de + reclen);
-			curr_offset = de->offset /* & 0x7fffffff */;
 		}
 	}
 

-- 
