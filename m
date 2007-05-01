Return-Path: <linux-kernel-owner+w=401wt.eu-S1031597AbXEAIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031597AbXEAIoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031600AbXEAIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:44:18 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:42231 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031597AbXEAIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:44:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=a0NiuPABX+Zqeh+/xSMcFwI5M5SOnWx5WNG3i6p/EqZC1tPe3uDshks6n1f3ezWXdweyq83SKIyKZQ7vUmm9DyceBayrF788H3dBBkmVz4yLSTf8AImV5Uqvu25KooJggDA8taxr6kUx+OWxC5WwU8h7tf23I2CSwRk0E1CIidI=  ;
X-YMail-OSG: xrNtipAVM1leuOlmxA9uF.kI8igheaV36kAYJ9oIBEBcMBR.hqLgElk1Al12KaEeiHg3PL_A5A--
Message-ID: <4636FDD7.9080401@yahoo.com.au>
Date: Tue, 01 May 2007 18:44:07 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>, Andrea Arcangeli <andrea@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>  mm-simplify-filemap_nopage.patch
>  mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
>  mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
>  mm-merge-nopfn-into-fault.patch
>  convert-hugetlbfs-to-use-vm_ops-fault.patch
>  mm-remove-legacy-cruft.patch
>  mm-debug-check-for-the-fault-vs-invalidate-race.patch

>  mm-fix-clear_page_dirty_for_io-vs-fault-race.patch

> Miscish MM changes.  Will merge, dependent upon what still applies and works
> if the moveable-zone patches get stalled.

These fix some bugs in the core vm, at least the former one we have
seen numerous people hitting in production...

I don't suppose you mean these are logically dependant on new features
sitting below them in your patch stack, just that you don't want to
spend time fixing a lot of rejects? If so, I can help fix those up, but
I don't think there is anything major, IIRC the biggest annoyance is
just that changing some GFP_types throws some big hunks.

So, do you or anyone else have any problems with these patches going in
2.6.22? I haven't had much feedback for a while, but I was under the
impression that people are more-or-less happy with them?

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch

This patch fixes the core filemap_nopage vs invalidate_inode_pages2
race by having filemap_nopage return a locked page to do_no_page,
and removes the fairly complex (and inadequate) truncate_count
synchronisation logic.

There were concerns that we could do this more cheaply, but I think it
is important to start with a base that is simple and more likely to
be correct and build on that. My testing didn't show any obvious
problems with performance.

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
etc.

These move ->nopage, ->populate, ->nopfn (and soon, ->page_mkwrite)
into a single, unified interface. Although this strictly closes some
similar holes in nonlinear faults as well, they are very uncommon, so
I wouldn't be so upset if these aren't merged in 2.6.22 (I don't see
any reason not to, but at least they don't fix major bugs).

-- 
SUSE Labs, Novell Inc.
