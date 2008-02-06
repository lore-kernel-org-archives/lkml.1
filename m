Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbYBFXRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbYBFXRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764230AbYBFXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:12:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:51218 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761597AbYBFXMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C0WXlDf7MdghbwxXeUs8u781HXTPqhP+XUXqPAVm/m34WVBaNNa7uQrblVylbcbkkjGnYwGXsgbq6e/tSl8Cf9AKG9LB4pJpIH3Iq2IKbqXvpqCfMaEiWfGRSyf68t8emNwuLzpU1jZtZesHKMXlvebCQXBN06nEHCOsNUX/8II=
Message-ID: <6101e8c40802061511k6356cd5cued8d9eb646a27bc9@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:11:58 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are remaining in quicklist 0
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
In-Reply-To: <20080206224520.GA11045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080202001232.472591439@mini.kroah.org>
	 <20080202002103.GW8368@suse.de>
	 <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
	 <1201915720.3781.18.camel@turion.linuxtx.org>
	 <Pine.LNX.4.64.0802011729560.21840@schroedinger.engr.sgi.com>
	 <20080206224520.GA11045@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, the patch in queue-2.6.23 is good for it

but the git id.: 96990a4ae979df9e235d01097d6175759331e88c

-------

>From stable-bounces@linux.kernel.org Tue Jan 15 10:52:21 2008
From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 16 Jan 2008 00:21:19 +0530
Subject: quicklists: Only consider memory that can be used with GFP_KERNEL
To: gregkh@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
clameter@sgi.com
Message-ID: <20080115185119.GA6806@linux.vnet.ibm.com>
Content-Disposition: inline

From: Christoph Lameter <clameter@sgi.com>

patch 96990a4ae979df9e235d01097d6175759331e88c in mainline.

Quicklists calculates the size of the quicklists based on the number of
free pages.  This must be the number of free pages that can be allocated
with GFP_KERNEL.  node_page_state() includes the pages in ZONE_HIGHMEM and
ZONE_MOVABLE which may lead the quicklists to become too large causing OOM.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/quicklist.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist, quickli
 static unsigned long max_pages(unsigned long min_pages)
 {
 	unsigned long node_free_pages, max;
+	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
+
+	node_free_pages =
+#ifdef CONFIG_ZONE_DMA
+		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
+#endif
+#ifdef CONFIG_ZONE_DMA32
+		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
+#endif
+		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);

-	node_free_pages = node_page_state(numa_node_id(),
-			NR_FREE_PAGES);
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 	return max(max, min_pages);
 }



On 2/6/08, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 01, 2008 at 05:30:14PM -0800, Christoph Lameter wrote:
> > On Fri, 1 Feb 2008, Justin M. Forbes wrote:
> >
> > >
> > > On Fri, 2008-02-01 at 16:39 -0800, Christoph Lameter wrote:
> > > > NO! Wrong fix. Was dropped from mainline.
> > >
> > > What is the right fix for the OOM issues with 2.6.22? Perhaps
> > > http://marc.info/?l=linux-mm&m=119973653803451&w=2 should be added to
> > > the queue in its place?  The OOM issue in 2.6.22 is real, and should be
> > > addressed.
> >
> > Indeed that is the right fix.
>
> Can someone send it to me, in patch form so that I can apply it?  Along
> with the git id of the same patch in mainline please, I can't seem to
> find it.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
