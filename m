Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZGBIBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZGBIBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZGBIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:00:57 -0400
Received: from mga05.intel.com ([192.55.52.89]:26795 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbZGBIA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,331,1243839600"; 
   d="scan'208";a="704430823"
Subject: fio mmap sequential read 30% regression
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Levshin <lpk@581.spb.su>, wli@movementarian.org,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Jul 2009 16:01:22 +0800
Message-Id: <1246521682.2560.490.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comapring with 2.6.30's result, fio mmap sequtial read has
about 30% regression on one of my stoakley machine with 1
JBOD (7 SAS disks) with kernel 2.6.31-rc1.

﻿Every disk has 2 partitions and 4 1-GB files per partition. Start
10 processes per disk to do mmap read sequentinally.

Bisect down to below patch.

ef00e08e26dd5d84271ef706262506b82195e752 is first bad commit
commit ef00e08e26dd5d84271ef706262506b82195e752
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jun 16 15:31:25 2009 -0700

    readahead: clean up and simplify the code for filemap page fault readahead
    
    This shouldn't really change behavior all that much, but the single rather
    complex function with read-ahead inside a loop etc is broken up into more
    manageable pieces.
    
    The behaviour is also less subtle, with the read-ahead being done up-front
    rather than inside some subtle loop and thus avoiding the now unnecessary
    extra state variables (ie "did_readaround" is gone).
    
    Fengguang: the code split in fact fixed a bug reported by Pavel Levshin:
    the PGMAJFAULT accounting used to be bypassed when MADV_RANDOM is set, in
    which case the original code will directly jump to no_cached_page reading.


The bisect is stable.

Yanmin


