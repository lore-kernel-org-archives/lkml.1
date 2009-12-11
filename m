Return-Path: <linux-kernel-owner+w=401wt.eu-S1762285AbZLKEgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762285AbZLKEgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762177AbZLKEge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:34 -0500
Received: from kroah.org ([198.145.64.141]:36750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759524AbZLKEfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:51 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:41 2009
Message-Id: <20091211042740.547415555@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [22/90] ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0022-ext4-Use-bforget-in-no-journal-mode-for-ext4_journal.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit c7acb4c16646943180bd221c167a077e0a084f9c)

When ext4 is using a journal, a metadata block which is deallocated
must be passed into the journal layer so it can be dropped from the
current transaction and/or revoked.  This is done by calling the
functions ext4_journal_forget() and ext4_journal_revoke(), which call
jbd2_journal_forget(), and jbd2_journal_revoke(), respectively.

Since the jbd2_journal_forget() and jbd2_journal_revoke() call
bforget(), if ext4 is not using a journal, ext4_journal_forget() and
ext4_journal_revoke() must call bforget() to avoid a dirty metadata
block overwriting a block after it has been reallocated and reused for
another inode's data block.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4_jbd2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -44,7 +44,7 @@ int __ext4_journal_forget(const char *wh
 						  handle, err);
 	}
 	else
-		brelse(bh);
+		bforget(bh);
 	return err;
 }
 
@@ -60,7 +60,7 @@ int __ext4_journal_revoke(const char *wh
 						  handle, err);
 	}
 	else
-		brelse(bh);
+		bforget(bh);
 	return err;
 }
 


