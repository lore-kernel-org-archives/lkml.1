Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbYBUV4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbYBUV4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbYBUVzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:55:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbYBUVzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:55:50 -0500
Date: Thu, 21 Feb 2008 15:54:56 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fixes for 2.6.25-rc2
Message-ID: <20080221215456.GC11511@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

One fixes a regression from the previous patch set, the other updates
MAINTAINERS for the dlm.  Thanks

 MAINTAINERS   |    3 +--
 fs/dlm/rcom.c |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)


commit d7c2feaf88df39124e278b9e775b245b057ac99e
Author: David Teigland <teigland@redhat.com>
Date:   Thu Feb 21 15:27:09 2008 -0600

    dlm: update git tree in MAINTAINERS
    
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 082d1ee..fd81e06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1324,8 +1324,7 @@ P:	David Teigland
 M:	teigland@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER

commit 599e0f584de8ff16b1428e2e16118757619f1d1b
Author: David Teigland <teigland@redhat.com>
Date:   Thu Feb 21 13:39:57 2008 -0600

    dlm: fix rcom_names message to self
    
    The recent patch to validate data lengths in rcom_names messages
    failed to account for fake messages a node directs to itself before
    ever sending it.  In this case we need to fill in the message length
    in the header for the validation code to use.
    
    Signed-off-by: David Teigland <teigland@redhat.com>

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 035e6f9..67522c2 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -215,6 +215,8 @@ int dlm_rcom_names(struct dlm_ls *ls, int nodeid, char *last_name, int last_len)
 	ls->ls_recover_nodeid = nodeid;
 
 	if (nodeid == dlm_our_nodeid()) {
+		ls->ls_recover_buf->rc_header.h_length =
+			dlm_config.ci_buffer_size;
 		dlm_copy_master_names(ls, last_name, last_len,
 		                      ls->ls_recover_buf->rc_buf,
 		                      max_size, nodeid);
