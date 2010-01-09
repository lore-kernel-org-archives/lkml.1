Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630Ab0AIN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0AIN7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986Ab0AIN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:59:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:49188 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0AIN7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:59:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,247,1262592000"; 
   d="scan'208";a="762774616"
Date: Sat, 9 Jan 2010 21:59:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC][PATCH v2] readahead: introduce O_RANDOM_READ for
	POSIX_FADV_RANDOM
Message-ID: <20100109135904.GA23944@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20091231043116.GA19397@localhost> <20100108130828.GA30480@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108130828.GA30480@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 09:08:28PM +0800, Christoph Hellwig wrote:
> Just thinking about this again, why don't you put the flag into
> file->f_mode and the FMODE_* namespace given that we don't want it to be
> settable from open?

Good idea. To do that without race I would like to add ->f_lock to 
f_mode modifications at non-open time, like this. What do you think?

---
vfs: take f_lock on modifying f_mode after open time

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/file_table.c     |    2 ++
 fs/nfsd/nfs4state.c |    2 ++
 2 files changed, 4 insertions(+)

--- linux.orig/fs/file_table.c	2010-01-09 10:50:24.000000000 +0800
+++ linux/fs/file_table.c	2010-01-09 10:51:06.000000000 +0800
@@ -394,7 +394,9 @@ retry:
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
+		spin_lock(&f->f_lock);
 		f->f_mode &= ~FMODE_WRITE;
+		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
 		file_release_write(f);
--- linux.orig/fs/nfsd/nfs4state.c	2010-01-09 10:52:54.000000000 +0800
+++ linux/fs/nfsd/nfs4state.c	2010-01-09 10:52:56.000000000 +0800
@@ -1998,7 +1998,9 @@ nfs4_file_downgrade(struct file *filp, u
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
 		drop_file_write_access(filp);
+		spin_lock(&filp->f_lock);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
+		spin_unlock(&filp->f_lock);
 	}
 }
 
