Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab0BDRZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:25:08 -0500
Received: from kroah.org ([198.145.64.141]:34971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933378Ab0BDRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:31 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:27 2010
Message-Id: <20100204171527.161359062@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julia Lawall <julia@diku.dk>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, Steve Dickson <steved@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [69/74] kernel/cred.c: use kmem_cache_free
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit b8a1d37c5f981cdd2e83c9fd98198832324cd57a upstream.

Free memory allocated using kmem_cache_zalloc using kmem_cache_free rather
than kfree.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E,c;
@@

 x = \(kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache_alloc_node\)(c,...)
 ... when != x = E
     when != &x
?-kfree(x)
+kmem_cache_free(c,x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Steve Dickson <steved@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cred.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -224,7 +224,7 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_KEYS
 	new->tgcred = kzalloc(sizeof(*new->tgcred), GFP_KERNEL);
 	if (!new->tgcred) {
-		kfree(new);
+		kmem_cache_free(cred_jar, new);
 		return NULL;
 	}
 	atomic_set(&new->tgcred->usage, 1);


