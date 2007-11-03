Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXKCXHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXKCXHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbXKCXGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:06:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbXKCXGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:06:31 -0400
Date: Sat, 3 Nov 2007 18:42:29 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/10] split anon and file LRUs
Message-ID: <20071103184229.3f20e2f0@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current page replacement scheme in Linux has a number of problems,
which can be boiled down to:
- Sometimes the kernel evicts the wrong pages, which can result in
  bad performance.
- The kernel scans over pages that should not be evicted.  On systems
  with a few GB of RAM, this can result in the VM using an annoying
  amount of CPU.  On systems with >128GB of RAM, this can knock the
  system out for hours since excess CPU use is compounded with lock
  contention and other issues.

This patch series tries to address the issues by splitting the LRU
lists into two sets, one for swap/ram backed pages ("anon") and
one for filesystem backed pages ("file").

The current version only has the infrastructure.  Large changes to
the page replacement policy will follow later.

More details can be found on this page:

	http://linux-mm.org/PageReplacementDesign

TODO:
- have any mlocked and ramfs pages live off of the LRU list,
  so we do not need to scan these pages
- switch to SEQ replacement for the anon LRU lists, so the
  worst case number of pages to scan is reduced greatly.
- figure out if the file LRU lists need page replacement
  changes to help with worst case scenarios
- implement and benchmark a scalable non-resident page
  tracking implementation in the radix tree, this may make
  the anon/file balancing algorithm more stable and could
  allow for further simplifications in the balancing algorithm

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
