Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbXINO5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbXINO5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXINO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:57:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:24888 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXINO5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:57:45 -0400
Date: Fri, 14 Sep 2007 18:57:30 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] Fix UTS corruption during clone(CLONE_NEWUTS)
Message-ID: <20070914145730.GB27986@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct utsname is copied from master one without any exclusion.

Here is sample output from one proggie doing

	sethostname("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
	sethostname("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");

and another

	clone(,, CLONE_NEWUTS, ...)
	uname()


	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaabbbbb'
	hostname = 'bbbaaaaaaaaaaaaaaaaaaaaaaaaaaa'
	hostname = 'aaaaaaaabbbbbbbbbbbbbbbbbbbbbb'
	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaaabbbb'
	hostname = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaabb'
	hostname = 'aaabbbbbbbbbbbbbbbbbbbbbbbbbbb'
	hostname = 'bbbbbbbbbbbbbbbbaaaaaaaaaaaaaa'

Hostname is sometimes corrupted.

Yes, even _the_ simplest namespace activity had bug in it. :-(

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/utsname.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -28,7 +28,9 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
 	if (!ns)
 		return ERR_PTR(-ENOMEM);
 
+	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
+	up_read(&uts_sem);
 	kref_init(&ns->kref);
 	return ns;
 }

