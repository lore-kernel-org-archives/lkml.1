Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZFERte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZFERte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZFERtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:49:25 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:49323 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZFERtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:49:25 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Date: Fri, 5 Jun 2009 12:49:22 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200906051150.17889.lkml@morethan.org> <ada1vpywpy7.fsf@cisco.com>
In-Reply-To: <ada1vpywpy7.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051249.25053.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 5 2009, Roland Dreier wrote:
> 
>  > I can't argue with gcc on this one either:
>  > 
>  > drivers/scsi/sd.c: In function 'sd_read_capacity':
>  > drivers/scsi/sd.c:1451: warning: comparison is always false due to limited range of data type
>  > 
>  > It reads to my eyes as if the function can never
>  > select read_capacity_16 for very large devices.
> 
> The code is:
> 
> 		if ((sizeof(sdkp->capacity) > 4) &&
> 		    (sdkp->capacity > 0xffffffffULL)) {
> 
> sdkp->capacity is a sector_t, and <linux/types.h> has:
> 
> 	#ifdef CONFIG_LBD
> 	typedef u64 sector_t;
> 	typedef u64 blkcnt_t;
> 	#else
> 	typedef unsigned long sector_t;
> 	typedef unsigned long blkcnt_t;
> 	#endif
> 
> so if you don't set CONFIG_LBD on a 32-bit architecture, then you are
> correct that sd.c won't ever hit the READ_CAPACITY(16) case, and the
> kernel won't be able to handle large SCSI disks.
> 
> 

Perhaps then let gcc coherce the test value into a local sector_t holder
to make the warning go away (it would still be protected by the >4 thing).

Not a problem here - NetBooks don't (yet) come with that big a disk.  ;)

Thanks
Mike
