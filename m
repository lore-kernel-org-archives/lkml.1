Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497Ab0AYT7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0AYT7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432Ab0AYT7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:59:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153Ab0AYT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:59:06 -0500
Date: Mon, 25 Jan 2010 11:58:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: anfei <anfei.zhou@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux@arm.linux.org.uk, Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Flush dcache before writing into page to avoid alias
Message-Id: <20100125115814.156d401d.akpm@linux-foundation.org>
In-Reply-To: <20100125133308.GA26799@desktop>
References: <979dd0561001202107v4ddc1eb7xa59a7c16c452f7a2@mail.gmail.com>
	<20100125133308.GA26799@desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 21:33:08 +0800 anfei <anfei.zhou@gmail.com> wrote:

> Hi Andrew,
> 
> On Thu, Jan 21, 2010 at 01:07:57PM +0800, anfei zhou wrote:
> > The cache alias problem will happen if the changes of user shared mapping
> > is not flushed before copying, then user and kernel mapping may be mapped
> > into two different cache line, it is impossible to guarantee the coherence
> > after iov_iter_copy_from_user_atomic.  So the right steps should be:
> > 	flush_dcache_page(page);
> > 	kmap_atomic(page);
> > 	write to page;
> > 	kunmap_atomic(page);
> > 	flush_dcache_page(page);
> > More precisely, we might create two new APIs flush_dcache_user_page and
> > flush_dcache_kern_page to replace the two flush_dcache_page accordingly.
> > 
> > Here is a snippet tested on omap2430 with VIPT cache, and I think it is
> > not ARM-specific:
> > 	int val = 0x11111111;
> > 	fd = open("abc", O_RDWR);
> > 	addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> > 	*(addr+0) = 0x44444444;
> > 	tmp = *(addr+0);
> > 	*(addr+1) = 0x77777777;
> > 	write(fd, &val, sizeof(int));
> > 	close(fd);
> > The results are not always 0x11111111 0x77777777 at the beginning as expected.
> > 
> Is this a real bug or not necessary to support?

Bug.  If variable `addr' has type int* then the contents of that file
should be 0x11111111 0x77777777.  You didn't tell us what the contents
were in the incorrect case, but I guess it doesn't matter.


