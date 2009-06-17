Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbZFQBFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbZFQBFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZFQBE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:04:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbZFQBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:04:59 -0400
Date: Tue, 16 Jun 2009 18:04:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <alpine.LFD.2.01.0906161717220.16802@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906161804030.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>  <1245192703.8234.226.camel@bluto.andrew>  <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain> <1245195498.8234.236.camel@bluto.andrew>
 <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain> <alpine.LFD.2.01.0906161717220.16802@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Linus Torvalds wrote:
> 
> Can you try this patch?

Oops. As Jesse pointed out, there was no patch.

_This_ time.

		Linus

---
 kernel/resource.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index ac5f3a3..d9d7ede 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -140,6 +140,13 @@ __initcall(ioresources_init);
 
 #endif /* CONFIG_PROC_FS */
 
+#define set_parent(x,p) __set_parent(__FUNCTION__, x, p)
+static void __set_parent(const char *fn, struct resource *x, struct resource *parent)
+{
+	WARN("%s: parent of '%s' is '%s'\n", fn, x->name, parent ? parent->name : "none");
+	x->parent = parent;
+}
+
 /* Return the conflict entry if you can't request it */
 static struct resource * __request_resource(struct resource *root, struct resource *new)
 {
@@ -159,7 +166,7 @@ static struct resource * __request_resource(struct resource *root, struct resour
 		if (!tmp || tmp->start > end) {
 			new->sibling = tmp;
 			*p = new;
-			new->parent = root;
+			set_parent(new, root);
 			return NULL;
 		}
 		p = &tmp->sibling;
@@ -395,13 +402,13 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 			break;
 	}
 
-	new->parent = parent;
+	set_parent(new, parent);
 	new->sibling = next->sibling;
 	new->child = first;
 
 	next->sibling = NULL;
 	for (next = first; next; next = next->sibling)
-		next->parent = new;
+		set_parent(next, new);
 
 	if (parent->child == first) {
 		parent->child = new;
