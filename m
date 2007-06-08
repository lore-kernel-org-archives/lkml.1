Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbXFHTEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbXFHTEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXFHTEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:04:24 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:1460 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXFHTEW convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:04:22 -0400
Message-ID: <4669A831.3040105@de.ibm.com>
Date: Fri, 08 Jun 2007 21:04:17 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?UTF-8?B?SUJNIERldXRzY2hsYW5kIEVudHdpY2tsdW5nIEdtYkgsVm9ycw==?=
 =?UTF-8?B?aXR6ZW5kZXIgZGVzIEF1ZnNpY2h0c3JhdHM6IEpvaGFubiBXZWloZW4sR2VzY2g=?=
 =?UTF-8?B?w6RmdHNmw7xocnVuZzogSGVyYmVydCBLaXJjaGVyLFNpdHogZGVyIEdlc2VsbHM=?=
 =?UTF-8?B?Y2hhZnQ6IELDtmJsaW5nZW4sUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNodCA=?=
 =?UTF-8?B?U3R1dHRnYXJ0LCBIUkIgMjQzMjk0?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>
CC: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com> <20070608080401.GA17684@infradead.org> <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com> <20070608160929.GA3366@infradead.org> <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com> <20070608161526.GA3729@infradead.org> <20070608175152.GG20718@lazybastard.org>
In-Reply-To: <20070608175152.GG20718@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Nitbit: Sooner or later the point/unpoint should get replaced by
> something with page granularity.  Something also needs to keep lists of
> mapped pages and invalidate them whenever the device is written to.
> That could be done in the filesystem or device driver.  I believe the
> device driver would be a better solution.
I think it needs to work like this:
- temporary references (for read/write syscalls and friends) get 
retrieved via get_xip_page and returned again via to-be-invented 
put_page/page_cache_release
- permanent references (for mapping to userland) get retrieved via 
get_xip_page and don't get returned until unmap
- the device driver can access page->count via a helper function 
provided by mm. This way, it can identify which pages are in use.
- In order to get references back, the device driver can call a 
callback provided by the file system. A default implementation will go 
to filemap_xip.c. This callback would use rmap to find all mappings, 
and unmap the page via xip_file_unmap()[mm/filemap_xip.c].

The nice thing about this approach is: we use page->count and rmap, 
both already exist and are perfectly suited for our purpose.
The downside: We need mem_map[] struct page entries behind all memory 
segments. Nowerdays we can easily create those via vmem_map/sparsemem.

Opinions?


