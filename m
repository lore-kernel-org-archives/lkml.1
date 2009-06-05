Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZFER2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZFER2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZFER17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:27:59 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:60918 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZFER16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:27:58 -0400
X-IronPort-AV: E=Sophos;i="4.41,312,1241395200"; 
   d="scan'208";a="173123527"
From: Roland Dreier <rdreier@cisco.com>
To: lkml@MoreThan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
References: <200906051150.17889.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 05 Jun 2009 10:28:00 -0700
In-Reply-To: <200906051150.17889.lkml@morethan.org> (Michael S. Zick's message
	of "Fri, 5 Jun 2009 11:50:15 -0500")
Message-ID: <ada1vpywpy7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Jun 2009 17:28:00.0663 (UTC) FILETIME=[F97A3A70:01C9E602]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I can't argue with gcc on this one either:
 > 
 > drivers/scsi/sd.c: In function 'sd_read_capacity':
 > drivers/scsi/sd.c:1451: warning: comparison is always false due to limited range of data type
 > 
 > It reads to my eyes as if the function can never
 > select read_capacity_16 for very large devices.

The code is:

		if ((sizeof(sdkp->capacity) > 4) &&
		    (sdkp->capacity > 0xffffffffULL)) {

sdkp->capacity is a sector_t, and <linux/types.h> has:

	#ifdef CONFIG_LBD
	typedef u64 sector_t;
	typedef u64 blkcnt_t;
	#else
	typedef unsigned long sector_t;
	typedef unsigned long blkcnt_t;
	#endif

so if you don't set CONFIG_LBD on a 32-bit architecture, then you are
correct that sd.c won't ever hit the READ_CAPACITY(16) case, and the
kernel won't be able to handle large SCSI disks.
