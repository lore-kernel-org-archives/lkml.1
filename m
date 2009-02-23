Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZBWPcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZBWPcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZBWPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:32:38 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51026 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752445AbZBWPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:32:37 -0500
Date: Mon, 23 Feb 2009 10:23:52 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of precalculated
 values
In-Reply-To: <1235344649-18265-5-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902231003090.7298@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, Mel Gorman wrote:

> Every page allocation uses gfp_zone() to calcuate what the highest zone
> allowed by a combination of GFP flags is. This is a large number of branches
> to have in a fast path. This patch replaces the branches with a lookup
> table that is calculated at boot-time and stored in the read-mostly section
> so it can be shared. This requires __GFP_MOVABLE to be redefined but it's
> debatable as to whether it should be considered a zone modifier or not.

Are you sure that this is a benefit? Jumps are forward and pretty short
and the compiler is optimizing a branch away in the current code.


0xffffffff8027bde8 <try_to_free_pages+95>:      mov    %esi,-0x58(%rbp)
0xffffffff8027bdeb <try_to_free_pages+98>:      movq   $0xffffffff80278cd0,-0x48(%rbp)
0xffffffff8027bdf3 <try_to_free_pages+106>:     test   $0x1,%r8b
0xffffffff8027bdf7 <try_to_free_pages+110>:     mov    0x620(%rax),%rax
0xffffffff8027bdfe <try_to_free_pages+117>:     mov    %rax,-0x88(%rbp)
0xffffffff8027be05 <try_to_free_pages+124>:     jne    0xffffffff8027be2c <try_to_free_pages+163>
0xffffffff8027be07 <try_to_free_pages+126>:     mov    $0x1,%r14d
0xffffffff8027be0d <try_to_free_pages+132>:     test   $0x4,%r8b
0xffffffff8027be11 <try_to_free_pages+136>:     jne    0xffffffff8027be2c <try_to_free_pages+163>
0xffffffff8027be13 <try_to_free_pages+138>:     xor    %r14d,%r14d
0xffffffff8027be16 <try_to_free_pages+141>:     and    $0x100002,%r8d
0xffffffff8027be1d <try_to_free_pages+148>:     cmp    $0x100002,%r8d
0xffffffff8027be24 <try_to_free_pages+155>:     sete   %r14b
0xffffffff8027be28 <try_to_free_pages+159>:     add    $0x2,%r14d
0xffffffff8027be2c <try_to_free_pages+163>:     mov    %gs:0x8,%rdx

