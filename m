Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZIXIak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZIXIak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZIXIai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:30:38 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:65301
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZIXIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:30:37 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 04:30:36 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMvIukrLO0En/2dsb2JhbADWL4QbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="468142520"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 00/11] autofs4 - update autofs4 to deal with VFS locking
	change
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:21:18 +0800
Message-ID: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A change to the VFS path walk locking is needed to resolve an issue
identified by Sage Weil. This locking change requires significant
changes to the autofs4 module to allow it to callback to userspace
without introducing a deadlock.

To cope with the change the autofs4 module needs to redirect mount
requests from ->d_revalidate() to ->lookup() if the directory
inode mutex is held when a callback needs to be done. Note that we
cannot redirect these requests when the mutex is not held because,
to function correctly, the mutex must be held over both revalidate
and lookup.

Of the patches in the series most are cleanups and refactoring done
to keep the real change in "autofs4 - always use lookup for lookup"
as clean as possible. Unfortuneately, there is still quite a bit
left in it.

Also, I need confirmation that the patch that changes the VFS path
walk locking is in fact correct, or at least like for like to what
will be submitted. I had some difficulty with the original patches
that were paosted. The patch in question below is "vfs: make
real_lookup do dentry revalidation with i_mutex held".

I've done quite a bit of fairly heavy stress testing of the patch
series and they (finally) hold up to it. Although I have also
managed to uncover a locking bug in the user space daemon as a
result, ;)

---

Ian Kent (10):
      autofs4 - always use lookup for lookup
      autofs4 - rename dentry to expiring in autofs4_lookup_expiring()
      autofs4 - rename dentry to active in autofs4_lookup_active()
      autofs4 - eliminate d_unhashed in path walk checks
      autofs4 - cleanup active and expire lookup
      autofs4 - renamer unhashed to active in autofs4_lookup()
      autofs4 - use autofs_info for pending flag
      autofs4 - use macro for need mount check
      autofs4 - use macros for expiring list
      autofs4 - use macros for active list handling

Sage Weil (1):
      Subject: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex held


 fs/autofs4/autofs_i.h |   38 +++
 fs/autofs4/expire.c   |    8 -
 fs/autofs4/inode.c    |    2 
 fs/autofs4/root.c     |  616 ++++++++++++++++++++++++++++++++-----------------
 fs/namei.c            |   58 ++---
 5 files changed, 480 insertions(+), 242 deletions(-)

-- 
Ian
