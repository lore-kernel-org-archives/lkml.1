Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbZBKSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbZBKSgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZBKSgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:36:09 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26257 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbZBKSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:36:07 -0500
X-IronPort-AV: E=Sophos;i="4.38,193,1233532800"; 
   d="scan'208";a="247549229"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.30] RDMA/cxgb3: Remove modulo math.
References: <20090210184448.22891.31130.stgit@dell3.ogc.int>
	<adamyctajv8.fsf@cisco.com> <4992F26A.4030800@opengridcomputing.com>
	<adatz70972e.fsf@cisco.com> <499319CF.6050204@opengridcomputing.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 11 Feb 2009 10:36:01 -0800
In-Reply-To: <499319CF.6050204@opengridcomputing.com> (Steve Wise's message of
	"Wed, 11 Feb 2009 12:32:47 -0600")
Message-ID: <adak57w95ym.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Feb 2009 18:36:01.0842 (UTC) FILETIME=[96F53920:01C98C77]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Is it possible for the page to be bigger than 4GB?  If so then yes you
 > > might be chopping off high-order bits or something.

 > Yes it is possible.
 > 
 > A MR can be created with an iov_base of say 0xffffffff00000000.
 > 
 > Then any sge.addr entries would be the iob_base + any offset.

But the code we're talking about is:

		/* to in the WQE == the offset into the page */
		wqe->recv.sgl[i].to = cpu_to_be64(((u32) wr->sg_list[i].addr) %
				(1UL << (12 + page_size[i])));

so it seems the top address bits don't matter unless page_size[i] is at
least 20 -- in which case using 1UL to shift overflows on 32 bits anyway...

 > So you are handling the offset patch that will make it u64 and remove
 > the mod usage, correct?

Yeah, I rolled the fix into the "offset needs to be u64" patch, it
should be in linux-next by now (or at least in my for-next branch).

 - R.
