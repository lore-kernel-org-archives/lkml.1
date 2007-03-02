Return-Path: <linux-kernel-owner+w=401wt.eu-S1422707AbXCBBj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbXCBBj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXCBBj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:39:58 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:40809 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422707AbXCBBj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:39:57 -0500
Message-ID: <45E78053.6010000@in.ibm.com>
Date: Fri, 02 Mar 2007 07:09:31 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@skynet.ie>, npiggin@suse.de, clameter@engr.sgi.com,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org>
In-Reply-To: <20070301160915.6da876c5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> So some urgent questions are: how are we going to do mem hotunplug and
> per-container RSS?
> 
> 
> 
> Our basic unit of memory management is the zone.  Right now, a zone maps
> onto some hardware-imposed thing.  But the zone-based MM works *well*.  I
> suspect that a good way to solve both per-container RSS and mem hotunplug
> is to split the zone concept away from its hardware limitations: create a
> "software zone" and a "hardware zone".  All the existing page allocator and
> reclaim code remains basically unchanged, and it operates on "software
> zones".  Each software zones always lies within a single hardware zone. 
> The software zones are resizeable.  For per-container RSS we give each
> container one (or perhaps multiple) resizeable software zones.
> 
> For memory hotunplug, some of the hardware zone's software zones are marked
> reclaimable and some are not; DIMMs which are wholly within reclaimable
> zones can be depopulated and powered off or removed.
> 
> NUMA and cpusets screwed up: they've gone and used nodes as their basic
> unit of memory management whereas they should have used zones.  This will
> need to be untangled.
> 
> 
> Anyway, that's just a shot in the dark.  Could be that we implement unplug
> and RSS control by totally different means.  But I do wish that we'd sort
> out what those means will be before we potentially complicate the story a
> lot by adding antifragmentation.
> 

Paul Menage had suggested something very similar in response to the RFC
for memory controllers I sent out and it was suggested that we create
small zones (roughly 64 MB) to avoid the issue of a zone/node not being
a shareable across containers. Even with a small size, there are some 
issues. The following thread has the details discussed.

	http://lkml.org/lkml/2006/10/30/120

RSS accounting is very easy (with minimal changes to the core mm),
supplemented with an efficient per-container reclaimer, it should be
easy to implement a  good per-container RSS controller.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
