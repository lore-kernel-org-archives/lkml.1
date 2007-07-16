Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbXGPGBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbXGPGBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXGPGBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:01:24 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:43296 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752379AbXGPGBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:01:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=QrpZiSwMLzoQP/OadT8rHepqHYChGC6PKNCoyFs7erxtuHmdnpoYrFk39oHwhKFBRw6blN2Sg2NZ++XHBBuOPBTcxKc1ULNL1LUXknNMGMGEfHlp/+eXh6d8031ciKMdEyAy3PImmq+R3FU5TD7znVeCP0eZMdnd1hg0JcyLfd4=  ;
X-YMail-OSG: 2tEVTvYVM1mP.zDbG4RQKpB5KrjI3qp7VRlBOwvmY5XR5cpKI3niyDALad5BJYkKGxGyOh7fLw--
Message-ID: <469B09AB.5010309@yahoo.com.au>
Date: Mon, 16 Jul 2007 16:01:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] slob: reduce list scanning
References: <20070714055434.GQ11115@waste.org>
In-Reply-To: <20070714055434.GQ11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> The version of SLOB in -mm always scans its free list from the
> beginning, which results in small allocations and free segments
> clustering at the beginning of the list over time. This causes the
> average search to scan over a large stretch at the beginning on each
> allocation.
> 
> By starting each page search where the last one left off, we evenly
> distribute the allocations and greatly shorten the average search.
> 
> Without this patch, kernel compiles on a 1.5G machine take a large
> amount of system time for list scanning. With this patch, compiles are
> within a few seconds of performance of a SLAB kernel with no notable
> change in system time.

This looks pretty nice, and performance results sound good too.
IMO this should probably be merged along with the previous
SLOB patches, because they removed the cyclic scanning to begin
with (so it may be possible that introduces a performnace
regression in some situations).

I wonder what it would take to close the performance gap further.
I still want to look at per-cpu freelists after Andrew merges
this set of patches. That may improve both cache hotness and
CPU scalability.

Actually SLOB potentially has some fundamental CPU cache hotness
advantages over the other allocators, for the same reasons as
its space advantages. It may be possible to make some workloads
faster with SLOB than with SLUB! Maybe we could remove SLAB and
SLUB then :)

-- 
SUSE Labs, Novell Inc.
