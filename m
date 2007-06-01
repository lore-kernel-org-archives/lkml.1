Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXFAHkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXFAHkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXFAHkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:40:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14594 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbXFAHkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:40:07 -0400
Message-ID: <465FCE59.2070703@openvz.org>
Date: Fri, 01 Jun 2007 11:44:25 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@in.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <465D9739.8070209@openvz.org>	<465D9B62.5050507@openvz.org>	<20070530144737.56456aaf.akpm@linux-foundation.org>	<465EA4FF.1000904@openvz.org> <20070531105842.0728f577.akpm@linux-foundation.org>
In-Reply-To: <20070531105842.0728f577.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 31 May 2007 14:35:43 +0400
> Pavel Emelianov <xemul@openvz.org> wrote:
> 
>>> Would I be correct in guessing that pages which are on the
>>> per-rss-container lists are also eligible for reclaim off the traditional
>>> page LRUs?  If so, how does that work?  When a page gets freed off the
>> Yes. All the pages are accessible from booth - global and per-container
>> LRU lists and reclamation can be performed from booth.
>>
>>> per-zone LRUs does it also get removed from the per-rss_container LRU?  But
>>> how can this be right?  
>> I don't get your idea here.
> 
> If we have a page which is on the zone LRU with refcount=1 and someone does
> put_page() on it, we will take that page off the zone LRU and then actually
> free the page.
> 
> I am assuming that your patches change that logic so that we will also
> remove that page from the per-container LRU at the same time?

Oh, I see. No that will work another way. Page stays in per-container
LRU lists as long as it is mapped. When the last process is unmapping
the page, it it is removed, but stays in global LRU till its refcount
drops to 0.

Since all unmaps happen from process-context this looks to be safe.

> If so, the problem which I see is that, under rare circumstances, that
> final put_page() will occur from interrupt context.  Hence we would be
> trying to remove the page from the per-container LRU at interrupt time. 
> But the locks which you have in there are not suited for taking from
> interrupt context.
> 
> 

Thanks,
Pavel.
