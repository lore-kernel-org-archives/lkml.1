Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbZATV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbZATV4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZATVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:55:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:48288 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755233AbZATVz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:55:58 -0500
Cc: dwmw2@infradead.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 20 Jan 2009 22:55:56 +0100
From: "Wolfram Strepp" <wstrepp@gmx.de>
Message-ID: <20090120215556.74580@gmx.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] Optimization of function rb_erase() in lib/rbtree.c
To: linux-kernel@vger.kernel.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18Smfpyhu8SUQBLXYSL5jLJ9WPg6DcxRKmEvoz8UE
 QJf9AimLaGn5PBOBSoFUOsp2t/jPnsCWNGjg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: CiweBBl8bHIhQMJg2DQ0yDEiJihyapC8
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

i have reviewed the code of the rb-tree implementation
in the kernel, and distilled two small patches for file lib/rbtree.c,
which optimize and cleanup the code of functions rb_erase() and __rb_erase_color().
In summary, there are 5 if()-conditions which can be eliminated.
The patches reduce the code size (normal kernel build on x86)
of this functions by 23 bytes, or 4.5 %.

So although this is not a dramatic change, i think its worth it,
given the many places in the kernel where it is used
(and given the fact that processors dont like if-conditions).

The patches are tested on x86.

------------------------------------------

The first patch was already posted some years ago, see:
http://lkml.org/lkml/2002/11/22/146
and:
http://lkml.org/lkml/2002/11/24/122

It was finally merged by the original author of the rb-tree
implementation, Andrea Arcangeli, in one of his kernel trees.
Citing from http://lkml.org/lkml/2002/12/25/51:

>Only in 2.4.21pre2aa1: 00_rbtree-cleanups-1
>
>	Merged rbtree cleanups/microoptimizations from Érsek László after
>	verifying their math correctness also with the help of Paolo Carlini
>	and of some gentle reminder from Rusty, they are obviously right,
>	thanks.

But obviousely, it never found is way into the mainline kernel,
so here it is again.

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>

====================================================
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
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
