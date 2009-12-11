Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbZLKEuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbZLKEuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZLKEgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:15 -0500
Received: from kroah.org ([198.145.64.141]:52850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbZLKEff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:35 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:26 2009
Message-Id: <20091211042725.802559277@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [03/90] jbd2: Fail to load a journal if it is too short
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0003-jbd2-Fail-to-load-a-journal-if-it-is-too-short.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit f6f50e28f0cb8d7bcdfaacc83129f005dede11b1)

Due to on disk corruption, it can happen that journal is too short. Fail
to load it in such case so that we don't oops somewhere later.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd2/journal.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1187,6 +1187,12 @@ static int journal_reset(journal_t *jour
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
+	if (first + JBD2_MIN_JOURNAL_BLOCKS > last + 1) {
+		printk(KERN_ERR "JBD: Journal too short (blocks %llu-%llu).\n",
+		       first, last);
+		journal_fail_superblock(journal);
+		return -EINVAL;
+	}
 
 	journal->j_first = first;
 	journal->j_last = last;


