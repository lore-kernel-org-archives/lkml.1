Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZHNGAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZHNGAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZHNGAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:00:44 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60189 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZHNGAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:00:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19076.64899.915246.955189@drongo.ozlabs.ibm.com>
Date: Fri, 14 Aug 2009 16:00:35 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Does perf_counter need to make mmap pages uptodate?
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At a colleague's request, I did a backport of the perf_counter code to
2.6.30.3.  When I tried "perf record ls" I hit the WARN_ON_ONCE in
__set_page_dirty (fs/buffer.c line 669):

                WARN_ON_ONCE(warn && !PageUptodate(page));

and indeed we never mark the pages that we let userspace mmap as being
uptodate.  To get around the problem I added

	SetPageUptodate(vmf->page);

after the get_page call in perf_mmap_fault, but I can't see any
relevant changes between 2.6.30 and current upstream that would cause
this to be necessary for 2.6.30 but not for current upstream.

Should we in fact be marking the pages uptodate, or is there some
reason why we should never get to that WARN_ON_ONCE?

Paul.
