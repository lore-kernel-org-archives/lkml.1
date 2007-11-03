Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbXKCRY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbXKCRY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXKCRYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:24:19 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36536 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXKCRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:24:18 -0400
Date: Sat, 3 Nov 2007 17:10:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] slub: fix leakage
Message-ID: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Slub has been quite leaky under load.  Taking mm_struct as an example, in
a loop of swapping kernel builds, after the first iteration slabinfo shows:
Name        Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
mm_struct        55     840    73.7K         18/7/4    4 0  38  62 A
but Objects and Partials steadily creep up - after the 340th iteration:
mm_struct       110     840   188.4K        46/36/4    4 0  78  49 A

The culprit turns out to be __slab_alloc(), where it copes with the race
that another task has assigned the cpu slab while we were allocating one.
Don't rush off to load_freelist there: that assumes c->freelist is empty,
and will lose all of its free slots when c->page->freelist is not empty.
Instead just do a local allocation from c->freelist when it has one.

Which fixes the leakage: Objects and Partials then remain stable.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I recommend this for 2.6.24-rc2 and 2.6.23-stable.

 mm/slub.c |    5 +++++
 1 file changed, 5 insertions(+)

--- 2.6.24-rc1/mm/slub.c	2007-10-24 07:16:04.000000000 +0100
+++ linux/mm/slub.c	2007-11-03 13:22:31.000000000 +0000
@@ -1525,6 +1525,11 @@ new_slab:
 				 * want the current one since its cache hot
 				 */
 				discard_slab(s, new);
+				if (c->freelist) {
+					object = c->freelist;
+					c->freelist = object[c->offset];
+					return object;
+				}
 				slab_lock(c->page);
 				goto load_freelist;
 			}
