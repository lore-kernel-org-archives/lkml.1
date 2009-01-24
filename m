Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZAXMcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZAXMcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 07:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZAXMch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 07:32:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:55629 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751757AbZAXMch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 07:32:37 -0500
Cc: peterz@infradead.org, dwmw2@infradead.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 24 Jan 2009 13:32:34 +0100
From: "Wolfram Strepp" <wstrepp@gmx.de>
In-Reply-To: <1232786621.4859.35.camel@laptop>
Message-ID: <20090124123234.119090@gmx.net>
MIME-Version: 1.0
References: <20090120215556.74580@gmx.net> <1232786621.4859.35.camel@laptop>
Subject: [PATCH] Optimization of function rb_erase() in lib/rbtree.c
To: linux-kernel@vger.kernel.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX198WJYFKXd8CM8v6no3y5s+MKB1gbWCXD9OT5UWwR
 Hi4zwIy+Rq50JdhWCNIwwpimQCbBZt+YiXlA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: A2MOerEbODB6fdo5kmRMolU9Ji9SWlLx
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the patch below, 4 redundant if-conditions in function __rb_erase_color() in lib/rbtree.c are removed.  
Here an explanation for it. In pseudo-source-code, the
structure of the code is as follows: 
 

if ((!A || B) && (!C || D)) {
	.
	.
	.
} else {
	if (!C || D) {//if this is true, it implies: (A == true) && (B == false)
		if (A) {//hence this always evaluates to 'true'...
			.
		}
		.
		//at this point, C always becomes true, because of:
		__rb_rotate_right/left();
		//and:
		other = parent->rb_right/left;
	}
	.
	.
	if (C) {//...and this too !
		.
	}
}

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

================================================
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -163,17 +163,14 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			{
 				if (!other->rb_right || rb_is_black(other->rb_right))
 				{
-					struct rb_node *o_left;
-					if ((o_left = other->rb_left))
-						rb_set_black(o_left);
+					rb_set_black(other->rb_left);
 					rb_set_red(other);
 					__rb_rotate_right(other, root);
 					other = parent->rb_right;
 				}
 				rb_set_color(other, rb_color(parent));
 				rb_set_black(parent);
-				if (other->rb_right)
-					rb_set_black(other->rb_right);
+				rb_set_black(other->rb_right);
 				__rb_rotate_left(parent, root);
 				node = root->rb_node;
 				break;
@@ -200,17 +197,14 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			{
 				if (!other->rb_left || rb_is_black(other->rb_left))
 				{
-					register struct rb_node *o_right;
-					if ((o_right = other->rb_right))
-						rb_set_black(o_right);
+					rb_set_black(other->rb_right);
 					rb_set_red(other);
 					__rb_rotate_left(other, root);
 					other = parent->rb_left;
 				}
 				rb_set_color(other, rb_color(parent));
 				rb_set_black(parent);
-				if (other->rb_left)
-					rb_set_black(other->rb_left);
+				rb_set_black(other->rb_left);
 				__rb_rotate_right(parent, root);
 				node = root->rb_node;
 				break;


-- 
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a
