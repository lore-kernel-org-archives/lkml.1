Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYEWRoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYEWRoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYEWRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:43:57 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:34177 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYEWRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:43:56 -0400
X-IronPort-AV: E=Sophos;i="4.27,531,1204531200"; 
   d="scan'208";a="71776543"
From: Roland Dreier <rdreier@cisco.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: rolandd@cisco.com, Linux Kernel list <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: [PATCH] infiniband/hw/ipath/ipath_sdma.c , fix compiler warnings
References: <48342C6C.2010502@googlemail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 23 May 2008 10:42:24 -0700
In-Reply-To: <48342C6C.2010502@googlemail.com> (Gabriel C.'s message of "Wed,
	21 May 2008 16:06:36 +0200")
Message-ID: <adave14apdr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2008 17:42:25.0056 (UTC) FILETIME=[5C8CA200:01C8BCFC]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'sdma_abort_task':
 > drivers/infiniband/hw/ipath/ipath_sdma.c:267: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type

Perhaps the best way to fix these is to change code like

		if (/* ScoreBoardDrainInProg */
		    test_bit(63, &hwstatus) ||
		    /* AbortInProg */
		    test_bit(62, &hwstatus) ||
		    /* InternalSDmaEnable */
		    test_bit(61, &hwstatus) ||
		    /* ScbEmpty */
		    !test_bit(30, &hwstatus)) {

to something like

		if ((hwstatus & (IPATH_SDMA_STATUS_SCORE_BOARD_DRAIN_IN_PROG |
				 IPATH_SDMA_STATUS_ABORT_IN_PROG	     |
				 IPATH_SDMA_STATUS_INTERNAL_SDMA_ENABLE)) ||
		    !(hwstatus & IPATH_SDMA_STATUS_SCB_EMPTY)) {

with appropriate defines for the constants 1ull << 63 etc.

(I think I got the logic correct but someone should check)

 > drivers/infiniband/hw/ipath/ipath_sdma.c:348: warning: format '%016llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
 > drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'ipath_restart_sdma':
 > drivers/infiniband/hw/ipath/ipath_sdma.c:618: warning: format '%016llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'

I have a fix for this pending; will ask Linus to pull today.
