Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZHSTFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZHSTFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 15:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZHSTFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 15:05:41 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31356 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZHSTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 15:05:41 -0400
Subject: Re: [PATCH 0/4] Page based O_DIRECT v2
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com, hch@infradead.org
In-Reply-To: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 15:05:42 -0400
Message-Id: <1250708742.5589.23.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens - 

I'm not using loop, but it appears that there may be a regression in
regular asynchronous direct I/O sequential write performance when these
patches are applied. Using my "small" machine (16-way x86_64, 256GB, two
dual-port 4GB FC HBAs connected through switches to 4 HP MSA1000s - one
MSA per port), I'm seeing a small but noticeable drop in performance for
sequential writes on the order of 2 to 6%. Random asynchronous direct
I/O and sequential reads appear to unaffected.

http://free.linux.hp.com/~adb/2009-08-19/nc.png

has a set of graphs showing the data obtained when utilizing LUNs
exported by the MSAs (increasing the number of MSAs being used along the
X-axis). The critical sequential write graph has numbers like (numbers
expressed in GB/second):

Kernel                    1MSA  2MSAs 3MSAs 4MSAs
------------------------  ----- ----- ----- -----
2.6.31-rc6              :  0.17  0.33  0.50  0.65 
2.6.31-rc6 + loop-direct:  0.15  0.31  0.46  0.61

Using all 4 devices we're seeing a drop of slightly over 6%. 

I also typically do runs utilizing just the caches on the MSAs (getting
rid of physical disk interactions (seeks &c).). Even here we see a small
drop off in sequential write performance (on the order of about 2.5%
when using all 4 MSAs)- but noticeable gains for both random reads and
(especially) random writes. That graph can be seen at:

http://free.linux.hp.com/~adb/2009-08-19/ca.png

BTW: The grace/xmgrace files that generated these can be found at - 

http://free.linux.hp.com/~adb/2009-08-19/nc.agr
http://free.linux.hp.com/~adb/2009-08-19/ca.agr

- as the specifics can be seen better whilst running xmgrace on those
files.

The 2.6.31-rc6 kernel was built using your block git trees master
branch, and the other one has your loop-direct branch at:

commit 806dec7809e1b383a3a1fc328b9d3dae1f633663
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Aug 18 10:01:34 2009 +0200

At the same time I'm doing this, I'm doing some other testing on my
large machine - but the test program has hung (using the loop-direct
branch kernel). I'm tracking that down...

Alan D. Brunelle
Hewlett-Packard

