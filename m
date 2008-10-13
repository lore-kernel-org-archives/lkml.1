Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbYJMUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbYJMUUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJMUUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:20:20 -0400
Received: from iona.labri.fr ([147.210.8.143]:48001 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbYJMUUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:20:17 -0400
Message-ID: <48F3AD47.1050301@inria.fr>
Date: Mon, 13 Oct 2008 22:19:19 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: [PATCH 0/5] mm: rework sys_move_pages() to avoid vmalloc and reduce
 the overhead
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's the first patchset reworking sys_move_pages() as discussed earlier.
It removes the possibly large vmalloc by using multiple chunks when migrating
large buffers. It also dramatically increases the throughput for large buffers
since the lookup in new_page_node() is now limited to a single chunk, causing
the quadratic complexity to have a much slower impact. There is no need to use
any radix-tree-like structure to improve this lookup.

sys_move_pages() duration on a 4-quadcore-opteron 2347HE (1.9Gz), migrating
between nodes #2 and #3:
	length		move_pages (us)		move_pages+patch (us)
	4kB		126			98
	40kB		198			168
	400kB		963			937
	4MB		12503			11930
	40MB		246867			11848

Patches #1 and #4 are the important ones:
1) stop returning -ENOENT from sys_move_pages() if nothing got migrated
2) don't vmalloc a huge page_to_node array for do_pages_stat()
3) extract do_pages_move() out of sys_move_pages()
4) rework do_pages_move() to work on page_sized chunks
5) move_pages: no need to set pp->page to ZERO_PAGE(0) by default

thanks,
Brice


