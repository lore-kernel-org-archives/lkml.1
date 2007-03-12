Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXCLQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXCLQDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030477AbXCLQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:03:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42186 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030476AbXCLQDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:03:07 -0400
Message-ID: <45F57CFB.9010707@sw.ru>
Date: Mon, 12 Mar 2007 19:16:59 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelianov <xemul@sw.ru>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/7] Data structures changes for RSS accounting
References: <45ED7DEC.7010403@sw.ru> <45ED8181.2060905@sw.ru> <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Pavel Emelianov <xemul@sw.ru> writes:
> 
> 
>>Adds needed pointers to mm_struct and page struct,
>>places hooks to core code for mm_struct initialization
>>and hooks in container_init_early() to preinitialize
>>RSS accounting subsystem.
> 
> 
> An extra pointer in struct page is unlikely to fly.
> Both because it increases the size of a size critical structure,
> and because conceptually it is ridiculous.
as it was discussed multiple times (and according OLS):
- it is not critical nowdays to expand struct page a bit in case
  accounting is on.
- it can be done w/o extending, e.g. via mapping page <-> container
  using hash or some other data structure.
  i.e. we can optimize it on size if considered needed.

> If you are limiting the RSS size you are counting the number of pages in
> the page tables.  You don't care about the page itself.
> 
> With the rmap code it is relatively straight forward to see if this is
> the first time a page has been added to a page table in your rss
> group, or if this is the last reference to a particular page in your
> rss group.  The counters should only increment the first time a
> particular page is added to your rss group.  The counters should only
> decrement when it is the last reference in your rss subsystem.
You are fundamentally wrong if shared pages are concerned.
Imagine a glibc page shared between 2 containers - VE1 and VE2.
VE1 was the first who mapped it, so it is accounted to VE1
(rmap count was increased by it).
now VE2 maps the same page. You can't determine whether this page is mapped
to this container or another one w/o page->container pointer.
All the choices you have are:
a) do not account this page, since it is allready accounted to some other VE.
b) account this page again to current container.

(a) is bad, since VE1 can unmap this page first, and the last user will be VE2.
Which means VE1 will be charged for it, while VE2 uncharged. Accounting screws up.

b) is bad, since:
  - the same page is accounted multiple times, which makes impossible
    to understand how much real memory pages container needs/consumes
  - and because on container enter the process and it's pages
    are essentially moved to another context, while accounting
    can not be fixed up easily and we essentially have (a).

> This allow important little cases like glibc to be properly accounted
> for. One of the key features of a rss limit is that the kernel can
> still keep pages that you need in-core, that are accessible with just
> a minor fault.  Directly owning pages works directly against that
> principle.
Sorry, can't understand what you mean. It doesn't work against.
Each container has it's own LRU. So if glibc has the most
often used pages - it won't be thrashed out.

Thanks,
Kirill
