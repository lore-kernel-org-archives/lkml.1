Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZBZKd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZBZKd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZBZKdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:33:20 -0500
Received: from sineb-mail-1.sun.com ([192.18.19.6]:60099 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZBZKdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:33:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Date: Thu, 26 Feb 2009 18:33:09 +0800
From: Li Wei <W.Li@Sun.COM>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
In-reply-to: <49A66841.8020301@linux.vnet.ibm.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Message-id: <1235644389.13052.28.camel@localhost>
X-Mailer: Evolution 2.24.3
References: <49883CD7.2060602@linux.vnet.ibm.com>
 <1235616005.7351.8.camel@localhost> <49A66841.8020301@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 11:00 +0100, Peter Oberparleiter wrote:
> Since a few RCs have been released since the last gcov-kernel patch 
> post, I'll do a full re-post with a fix similar to the one you suggested 
> included.

Thanks! It would be great if ".."s in object pathnames could also be
supported in the forth coming re-post.

I have some external modules which link with object files outside their
directories. For example, a source tree looks like

  module0/main.c
  lib0/lib.c

and the Kbuild file has to use

  main-y += ../lib0/lib.o

to link in lib.c. Current gcov-kernel does not support ".." in
pathnames. Could ".."s be handled in add_node?

---
 kernel/gcov/fs.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index aab3be7..2f92955 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -500,6 +500,15 @@ static void add_node(struct gcov_info *info)
 		if (curr == next)
 			continue;
 		*next = 0;
+		if (!strcmp(curr, "."))
+			continue;
+		if (!strcmp(curr, "..")) {
+			if (parent != &root_node) {
+				parent = parent->parent;
+				continue;
+			} else
+				goto out_err;
+		}
 		node = get_child_by_name(parent, curr);
 		if (!node) {
 			node = new_node(parent, NULL, curr);
-- 
1.5.6.3

