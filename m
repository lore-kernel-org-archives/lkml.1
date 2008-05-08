Return-Path: <linux-kernel-owner+w=401wt.eu-S933349AbYEHRtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbYEHRtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYEHRnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:33551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764815AbYEHRny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:54 -0400
Date: Thu, 8 May 2008 10:42:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 13/16] CRYPTO: api: Fix scatterwalk_sg_chain
Message-ID: <20080508174226.GN855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-api-fix-scatterwalk_sg_chain.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[CRYPTO] api: Fix scatterwalk_sg_chain

[ Upstream commit: 8ec970d8561abb5645d4602433b772e268c96d05 ]

When I backed out of using the generic sg chaining (as it isn't currently
portable) and introduced scatterwalk_sg_chain/scatterwalk_sg_next I left
out the sg_is_last check in the latter.  This causes it to potentially
dereference beyond the end of the sg array.

As most uses of scatterwalk_sg_next are bound by an overall length, this
only affected the chaining code in authenc and eseqiv. Thanks to Patrick
McHardy for identifying this problem.

This patch also clears the "last" bit on the head of the chained list as
it's no longer last.  This also went missing in scatterwalk_sg_chain and
is present in sg_chain.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/crypto/scatterwalk.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -57,10 +57,14 @@ static inline void scatterwalk_sg_chain(
 					struct scatterlist *sg2)
 {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
+	sg1[num - 1].page_link &= ~0x02;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
+	if (sg_is_last(sg))
+		return NULL;
+
 	return (++sg)->length ? sg : (void *)sg_page(sg);
 }
 

-- 
