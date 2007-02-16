Return-Path: <linux-kernel-owner+w=401wt.eu-S1946315AbXBPXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946315AbXBPXjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946306AbXBPXji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946303AbXBPXjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Martin Stoilov <mstoilov@odesys.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/10] kobject: kobj->k_name verification fix
Date: Fri, 16 Feb 2007 15:37:30 -0800
Message-Id: <11716690662679-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <11716690633694-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Stoilov <mstoilov@odesys.com>

The function 'kobject_add' tries to verify the name of
a new kobject instance is properly set before continuing.
    if (!kobj->k_name)
        kobj->k_name = kobj->name;
    if (!kobj->k_name) {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }
The statement:
    if (!kobj->k_name) {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }
is useless the way it is right now, because it can never be true. I
think the
code was intended to be:
    if (!kobj->k_name)
        kobj->k_name = kobj->name;
    if (!*kobj->k_name) {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }
because this would make sure the kobj->name buffer has something in it.
So the missing '*' is just a typo. Although, I would much prefer
expression like:
    if (*kobj->k_name == '\0') {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }

because this would've made the intention clear, in this patch I just restore
the missing '*' without changing the coding style of the function.

Signed-off-by: Martin Stoilov <mstoilov@odesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 2782f49..93685f4 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -171,7 +171,7 @@ int kobject_shadow_add(struct kobject * kobj, struct dentry *shadow_parent)
 		return -ENOENT;
 	if (!kobj->k_name)
 		kobj->k_name = kobj->name;
-	if (!kobj->k_name) {
+	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
 		return -EINVAL;
-- 
1.5.0

