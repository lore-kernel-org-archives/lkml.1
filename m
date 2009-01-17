Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbZAQCeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbZAQCeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbZAQCaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:30:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20138 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935372AbZAQCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:30:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=PiNxSIv0AG4ZyT9wCJAPISDxAa9WEeGvKRdIdCez8GrerPLYIJa9uTS/oaMTjNE+V
	SmUHZkIhV8PQtfPOwRmTg==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 7/8] Make drop_caches flush pending dput()s and iput()s
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:30:12 -0800
Message-ID: <20090117023012.20425.49587.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing echo 3 > /proc/sys/vm/drop_caches, we wish to free up as much inode
and dentry slab as possible.  This path is updated to flush any pending iputs
and dputs once the shrinkers are called.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/drop_caches.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 3e5637f..1e47470 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -60,6 +60,7 @@ static void drop_slab(void)
 	do {
 		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
 	} while (nr_objects > 10);
+	dput_drain_all();
 }
 
 int drop_caches_sysctl_handler(ctl_table *table, int write,

