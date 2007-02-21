Return-Path: <linux-kernel-owner+w=401wt.eu-S964835AbXBUBv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835AbXBUBv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964824AbXBUBvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:51:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:42857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835AbXBUBv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:51:29 -0500
Date: Tue, 20 Feb 2007 17:50:07 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland Dreier <rolandd@cisco.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 05/18] IB/srp: Fix FMR mapping for 32-bit kernels and addresses above 4G
Message-ID: <20070221015007.GF3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-srp-fix-fmr-mapping-for-32-bit-kernels-and-addresses-above-4g.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <rdreier@cisco.com>

struct srp_device.fmr_page_mask was unsigned long, which means that
the top part of addresses above 4G was being chopped off on 32-bit
architectures.  Of course nothing good happens when data from SRP
targets is DMAed to the wrong place.

Fix this by changing fmr_page_mask to u64, to match the addresses
actually used by IB devices.

Thanks to Brian Cain <Brian.Cain@ge.com> and David McMillen
<davem@systemfabricworks.com> for help diagnosing the bug and testing
the fix.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/ulp/srp/ib_srp.c |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.18.7.orig/drivers/infiniband/ulp/srp/ib_srp.c
+++ linux-2.6.18.7/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1851,7 +1851,7 @@ static void srp_add_one(struct ib_device
 	 */
 	srp_dev->fmr_page_shift = max(9, ffs(dev_attr->page_size_cap) - 1);
 	srp_dev->fmr_page_size  = 1 << srp_dev->fmr_page_shift;
-	srp_dev->fmr_page_mask  = ~((unsigned long) srp_dev->fmr_page_size - 1);
+	srp_dev->fmr_page_mask  = ~((u64) srp_dev->fmr_page_size - 1);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
 
--- linux-2.6.18.7.orig/drivers/infiniband/ulp/srp/ib_srp.h
+++ linux-2.6.18.7/drivers/infiniband/ulp/srp/ib_srp.h
@@ -87,7 +87,7 @@ struct srp_device {
 	struct ib_fmr_pool     *fmr_pool;
 	int			fmr_page_shift;
 	int			fmr_page_size;
-	unsigned long		fmr_page_mask;
+	u64			fmr_page_mask;
 };
 
 struct srp_host {

--
