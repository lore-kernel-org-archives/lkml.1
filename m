Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbXKGEXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbXKGEXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXKGEXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:23:46 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:46963 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbXKGEXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:23:45 -0500
Date: Wed, 7 Nov 2007 09:31:19 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>, general@lists.openfabrics.org
Subject: Re: problem in follow_hugetlb_page on ppc64 architecture with
	get_user_pages
Message-ID: <20071106223119.GC31367@localhost.localdomain>
Mail-Followup-To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
	Roland Dreier <rdreier@cisco.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ppc <linuxppc-dev@ozlabs.org>,
	Christoph Raisch <RAISCH@de.ibm.com>,
	Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>, general@lists.openfabrics.org
References: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com> <200711061606.04402.hnguyen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711061606.04402.hnguyen@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 04:06:04PM +0100, Hoang-Nam Nguyen wrote:
> Hello Roland!
> > We currently see this when testing Infiniband on ppc64 with ehca +
> > hugetlbfs.
> > From reading the code this should also be an issue on other architectures.
> > Roland, Adam, are you aware of anything in this area with mellanox
> > Infiniband cards or other usages with I/O adapters?
> Below is a testcase demonstrating this problem. You need to install
> libhugetlbfs.so and run it as below:
> HUGETLB_MORECORE=yes LD_PRELOAD=libhugetlbfs.so ./hugetlb_ibtest 100
> 
> This testcase does the following steps (high level desc):
> 1. malloc two buffers each of 100MB for send and recv
> 2. register them as memory regions
> 3. create queue pair QP
> 4. send data in send buffer using QP to itself (target is then recv buffer)
> 5. compare those buffers content
> 
> It runs fine without libhugetlbsf. If you call it with libhugetlbfs as
> above, step 5 will fail. If you do memset() of the buffers before step 2
> (register mr), then it runs without errors.
> It appears that hugetlb_cow() is called when first write access is performed
> after mrs have been registered. That means the testcase is seeing other pages
> than the ones registered to the adapter...
> 
> I was able reproduce this with mthca on 2.6.23/ppc64 and fc6/intel.

We should cut this down to the bare necessary and fold it into the
libhugetlbfs testsuite.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
