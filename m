Return-Path: <linux-kernel-owner+w=401wt.eu-S1751383AbZL1CDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbZL1CDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZL1CDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:03:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:29075 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbZL1CDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:03:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,461,1257148800"; 
   d="scan'208";a="582438991"
Date: Mon, 28 Dec 2009 10:03:48 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: [PATCH]cfq-iosched: don't take requests with long distence as close
Message-ID: <20091228020348.GB28115@sli10-desk.sh.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
 <4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 06:16:27PM +0800, Corrado Zoccolo wrote:
> Hi Shaohua,
> On Thu, Dec 24, 2009 at 1:55 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > df5fe3e8e13883f58dc97489076bbcc150789a21
> > b3b6d0408c953524f979468562e7e210d8634150
> > The coop merge is too aggressive. For example, if two tasks are reading two
> > files where the two files have some adjecent blocks, cfq will immediately
> > merge them. cfq_rq_close() also has trouble, sometimes the seek_mean is very
> > big. I did a test to make cfq_rq_close() always checks the distence according
> > to CIC_SEEK_THR, but still saw a lot of wrong merge. (BTW, why we take a long
> > distence far away request as close. Taking them close doesn't improve any thoughtput
> > to me. Maybe we should always use CIC_SEEK_THR as close criteria).
> Yes, when deciding if two queues are going to be merged, we should use
> the constant CIC_SEEK_THR.

seek_mean could be very big sometimes, using it as close criteria is meanless
as this doen't improve any performance. So if it's big, let's fallback to
default value.

Signed-off-by: Shaohua Li<shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e2f8046..8025605 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1682,6 +1682,10 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (!sample_valid(cfqq->seek_samples))
 		sdist = CFQQ_SEEK_THR;
 
+	/* if seek_mean is big, using it as close criteria is meanless */
+	if (sdist > CFQQ_SEEK_THR)
+		sdist = CFQQ_SEEK_THR;
+
 	return cfq_dist_from_last(cfqd, rq) <= sdist;
 }
 
