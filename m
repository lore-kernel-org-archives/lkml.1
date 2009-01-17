Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZAQCeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZAQCeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbZAQCac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:30:32 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbZAQCaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:30:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=YFEIXejlzSTfNDP2gcVZ78JP/Iz5BPR5ZXQ+EXnUEg3YrcmK68PSIV2hOo2JcND6v
	Glq/0Kgz3ETwGzNkbgWLg==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 8/8] Make the sync path drain dentries and inodes
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:30:17 -0800
Message-ID: <20090117023017.20425.3486.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.93
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling sync(2), we should be flushing any pending dputs and iputs so that
any pending deletes are finalized and the metadata updated.

This patch requires more work as it's unclear whether any iput()s in this path
need to be flushed (synchronously?) or not.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/sync.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index ac02b56..5a595ad 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -23,6 +23,11 @@
  */
 static void do_sync(unsigned long wait)
 {
+	/*
+	 * Begin by making sure that we've flushed out any pending dput()s and
+	 * iput()s.
+	 */
+	dput_drain_all();
 	wakeup_pdflush(0);
 	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
 	DQUOT_SYNC(NULL);

