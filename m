Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZCFQk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZCFQk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZCFQku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:40:50 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42722 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbZCFQku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:40:50 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jan sonnek <ha2nny@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1236214452.22399.68.camel@nimitz>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
	 <1236076864.8547.20.camel@pc1117.cambridge.arm.com>
	 <1236092480.8547.67.camel@pc1117.cambridge.arm.com>
	 <1236214452.22399.68.camel@nimitz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 06 Mar 2009 16:40:16 +0000
Message-Id: <1236357616.3882.66.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 16:40:30.0977 (UTC) FILETIME=[43576710:01C99E7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 16:54 -0800, Dave Hansen wrote:
> On Tue, 2009-03-03 at 15:01 +0000, Catalin Marinas wrote:
> > > +     /* mem_map scanning */
> > > +     for_each_online_node(i) {
> > > +             struct page *page, *end;
> > > +
> > > +             page = NODE_MEM_MAP(i);
> > > +             end  = page + NODE_DATA(i)->node_spanned_pages;
> > > +
> > > +             scan_block(page, end, NULL);
> > > +     }
[...]
> One completely unoptimized thing you can do which will scan a 'struct
> page' at a time is this:
> 
> 	for_each_online_node(i) {
> 		unsigned long pfn;
> 		for (pfn = node_start_pfn(i); pfn < node_end_pfn(i); pfn++) {
> 			struct page *page;
> 			if (!pfn_valid(pfn))
> 				continue;
> 			page = pfn_to_page(pfn);
> 			scan_block(page, page+1, NULL);
> 		}
> 	}

It seems that node_start_pfn() isn't present on all the architectures. I
ended up with something like below:

+	/* struct page scanning for each node */
+	for_each_online_node(i) {
+		pg_data_t *pgdat = NODE_DATA(i);
+		unsigned long start_pfn = pgdat->node_start_pfn;
+		unsigned long end_pfn = start_pfn +
+			pgdat->node_spanned_pages - 1;
+		unsigned long pfn;
+
+		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+			struct page *page;
+
+			if (!pfn_valid(pfn))
+				continue;
+			page = pfn_to_page(pfn);
+			/* only scan if page is in use */
+			if (page_count(page) == 0)
+				continue;
+			scan_block(page, page + 1, NULL);
+		}
+	}

Are the pgdat->node_start_pfn and pgdat->node_spanned_pages always
valid? Thanks.

-- 
Catalin

