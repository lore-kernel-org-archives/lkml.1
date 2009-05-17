Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZEQE7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZEQE7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 00:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZEQE7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 00:59:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:48090 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbZEQE7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 00:59:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,206,1241420400"; 
   d="scan'208";a="143655486"
Date: Sun, 17 May 2009 12:58:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unresponsiveness on linux desktop during file copy
Message-ID: <20090517045800.GA32723@localhost>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com> <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com> <alpine.DEB.1.10.0905151533070.13433@qirst.com> <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com> <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost> <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com> <20090517020829.GB6809@localhost> <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 12:30:28PM +0800, Satish Eerpini wrote:
> > I've prepared a rolled up patch for you, run time tested.  It should
> > protect all of the above pages from being evicted by large file copies.
> >
> > The attached patch is for 2.6.29.
>
> I applied the patch , but the number don seem to show much difference

The numbers listed in your email? No the most relevant numbers are
memory and disk ones.

For my part, the number of mapped pages keeps stable when there is an
ongoing background file copy:

% ls -l /b/sparse
-rw-r--r-- 1 root root 98T 2009-04-29 22:38 /b/sparse
% cp /b/sparse /dev/null&
% for i in `seq 1 100`; do grep Mapped /proc/meminfo; sleep 1; done
Mapped:            22764 kB
Mapped:            22796 kB
Mapped:            22756 kB
Mapped:            22716 kB
Mapped:            22800 kB
Mapped:            22788 kB
Mapped:            22804 kB
Mapped:            22808 kB
Mapped:            22748 kB
Mapped:            22708 kB
Mapped:            22916 kB
Mapped:            22944 kB
Mapped:            22944 kB
Mapped:            22944 kB
Mapped:            22944 kB
Mapped:            22944 kB
Mapped:            22832 kB
Mapped:            22812 kB
Mapped:            22812 kB
Mapped:            22792 kB
Mapped:            22772 kB
Mapped:            22860 kB
Mapped:            22860 kB
Mapped:            22748 kB
Mapped:            22808 kB
Mapped:            22868 kB
Mapped:            22956 kB
Mapped:            22956 kB
Mapped:            22832 kB
Mapped:            22832 kB
Mapped:            22980 kB
Mapped:            22980 kB
Mapped:            22980 kB
Mapped:            22980 kB
Mapped:            22872 kB
Mapped:            22872 kB
Mapped:            22900 kB
Mapped:            22792 kB
Mapped:            22920 kB
Mapped:            22812 kB
Mapped:            22812 kB
Mapped:            22752 kB
Mapped:            22864 kB
Mapped:            22972 kB
Mapped:            22860 kB
Mapped:            22796 kB
Mapped:            22900 kB
Mapped:            22888 kB
Mapped:            22888 kB
Mapped:            22888 kB
Mapped:            22764 kB

> , following are the statistics with the patched kernel, could
> something else be causing the huge iowait,  :
>
> Linux 2.6.29 (satish) 	05/17/2009
>
> 09:57:14 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
> 09:57:18 AM     all     12.93      0.00     10.25     33.44      0.00     43.38
> 09:57:21 AM     all     13.32      0.00     28.09     24.40      0.00     34.19
> 09:57:24 AM     all     10.79      0.00      4.76     75.56      0.00      8.89
> 09:57:26 AM     all     11.46      0.00      8.01     35.64      0.00     44.90
> 09:57:30 AM     all     11.68      0.00      8.88     35.05      0.00     44.39
> Average:        all     12.03      0.00     11.94     40.81      0.00     35.22

The iowait is high. Do you have "iostat -x 5' numbers?

> and
>
> hdparm -tT /dev/sda
>
> /dev/sda:
>  Timing cached reads:   1332 MB in  2.00 seconds = 666.35 MB/sec
>  Timing buffered disk reads:   24 MB in  3.32 seconds =   7.23 MB/sec

That's pretty slow numbers. On my laptop:

# hdparm -tT /dev/sda

/dev/sda:
 Timing cached reads:   10266 MB in  1.98 seconds = 5188.46 MB/sec
 Timing buffered disk reads:  138 MB in  3.01 seconds =  45.90 MB/sec

Thanks,
Fengguang
