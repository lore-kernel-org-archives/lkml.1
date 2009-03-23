Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZCWCpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZCWCpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 22:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbZCWCpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 22:45:20 -0400
Received: from THUNK.ORG ([69.25.196.29]:40354 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbZCWCpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 22:45:18 -0400
Date: Sun, 22 Mar 2009 22:44:04 -0400
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Greg KH <gregkh@suse.de>, mfasheh@suse.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Dan Carpenter <error27@gmail.com>, mfasheh@suse.de,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
Message-ID: <20090323024404.GA14082@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
	Greg KH <gregkh@suse.de>, mfasheh@suse.com,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, Dan Carpenter <error27@gmail.com>,
	mfasheh@suse.de, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com> <20090317205518.GA4442@kroah.com> <49C00FE9.9040407@oracle.com> <20090320221750.GA32416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320221750.GA32416@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 03:17:50PM -0700, Greg KH wrote:
> 
> I tracked this down to commit 54dc90 in the 2.6.28.8 tree.
> 
> I've included it below.  Jan and Ted, any ideas on how to fix this
> error?

2.6.29 dropped the CONFIG_OCFS2_COMPAT_JBD option; if you enable it,
causes a compile failure in 2.6.28.8.  This should fix it...

diff --git a/fs/ocfs2/ocfs2_jbd_compat.h b/fs/ocfs2/ocfs2_jbd_compat.h
index b91c78f..268949b 100644
--- a/fs/ocfs2/ocfs2_jbd_compat.h
+++ b/fs/ocfs2/ocfs2_jbd_compat.h
@@ -60,7 +60,8 @@ static inline int jbd2_journal_file_inode(handle_t *handle,
 	return 0;
 }
 
-static inline int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode,
+static inline int jbd2_journal_begin_ordered_truncate(journal_t *journal,
+						      struct jbd2_inode *inode,
 						      loff_t new_size)
 {
 	return 0;

> Should I just revert this from the 2.6.28 tree?  Or does no one really
> care about ocfs2 in the stable tree?

I'm not sure how much people will care about CONFIG_OCFS2_COMPAT_JBD,
given that it disappears in 2.6.29, but the above patch should fix
things.

						- Ted
