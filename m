Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZHZS5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZHZS5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZHZS5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:57:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZHZS5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:57:39 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] IMA: iint put in ima_counts_get and put
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, zohar@us.ibm.com
Date: Wed, 26 Aug 2009 14:56:48 -0400
Message-ID: <20090826185648.4146.15888.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_counts_get() calls ima_iint_find_insert_get() which takes a reference
to the iint in question, but does not put that reference at the end of the
function.  This can lead to a nasty memory leak.  Easy enough to reproduce:

#include <sys/mman.h>
#include <stdio.h>

int main (void)
{
	int i;
	void *ptr;

	for (i=0; i < 100000; i++) {
		ptr = mmap(NULL, 4096, PROT_READ|PROT_WRITE,
			   MAP_SHARED|MAP_ANONYMOUS, -1, 0);
		if (ptr == MAP_FAILED)
			return 2;
		munmap(ptr, 4096);
	}

	return 0;
}

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 101c512..4732f5e 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -262,6 +262,8 @@ void ima_counts_put(struct path *path, int mask)
 	else if (mask & (MAY_READ | MAY_EXEC))
 		iint->readcount--;
 	mutex_unlock(&iint->mutex);
+
+	kref_put(&iint->refcount, iint_free);
 }
 
 /*
@@ -291,6 +293,8 @@ void ima_counts_get(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		iint->writecount++;
 	mutex_unlock(&iint->mutex);
+
+	kref_put(&iint->refcount, iint_free);
 }
 EXPORT_SYMBOL_GPL(ima_counts_get);
 

