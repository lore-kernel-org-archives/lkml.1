Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYEGM3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYEGM3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYEGM3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:29:30 -0400
Received: from saeurebad.de ([85.214.36.134]:35241 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbYEGM32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:29:28 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC no patch yet] bootmem2: Another try
References: <20080505095938.326928514@symbol.fehenstaub.lan>
Date: Wed, 07 May 2008 14:29:20 +0200
In-Reply-To: <20080505095938.326928514@symbol.fehenstaub.lan> (Johannes
	Weiner's message of "Mon, 05 May 2008 11:59:38 +0200")
Message-ID: <87ve1qcn6n.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my idea is now as follows:

Bootmem2 is block-oriented where a block represents a contiguous range
of physical memory.  Every block has a bitmap that keeps track of the
pages on it.

On top of this block interface, bootmem2 implements the node model
where a node can provide one or more memory blocks.

On configurations with multiple blocks per node, the arch code has to
register each block on its own.

free_bootmem and reserve_bootmem require that the requested range is
contiguous but they might go across node boundaries (two blocks on two
nodes can be contiguous).  For example:

node 0: block 0 = 0-2G, block 1 = 4-6G
node 1: block 2 = 2-4G, block 3 = 6-8G

free_bootmem(1.5G, 3G) is valid here, the range spans two nodes and two
blocks but is contiguous.

free_bootmem_node and reserve_bootmem_node are more strict, the ranges
have to be completely within one block of the specified node (two
blocks on one node are never contiguous).

alloc_bootmem_node tries to get memory between goal and limit from a
specific node and falls back to any free memory range on that node on
failure.

alloc_bootmem tries to get memory from between goal and limit and
falls back to any free memory range in the system on failure.

What do you say?

	Hannes
