Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbZIDT10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbZIDT10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933888AbZIDT1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:27:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46074 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbZIDT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:27:22 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] proc: Clean up mmaps when a proc file is removed.
References: <m1fxb2wm0z.fsf@fess.ebiederm.org>
	<m1bplqwlzr.fsf@fess.ebiederm.org>
	<m17hwewlxr.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 Sep 2009 12:27:21 -0700
In-Reply-To: <m17hwewlxr.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Fri\, 04 Sep 2009 12\:26\:40 -0700")
Message-ID: <m13a72wlwm.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, tj@kernel.org, gregkh@suse.de, adobriyan@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a file such as /proc/bus/pci/*/* is mmaped and the underlying device
is hotunplugedd we can potentially run into all kinds of ugly things.

So implement unmap on remove by calling revoke_file_mappings.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/proc/generic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index fa678ab..42ce941 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -20,6 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
+#include <linux/mm.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -833,6 +834,7 @@ continue_removing:
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		list_del(&pdeo->lh);
 		spin_unlock(&de->pde_unload_lock);
+		revoke_file_mappings(pdeo->file);
 		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
 		spin_lock(&de->pde_unload_lock);
-- 
1.6.2.5

