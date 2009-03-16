Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbZCPTPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbZCPTPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbZCPTOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:14:55 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:44402 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZCPTOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:14:54 -0400
Date: Mon, 16 Mar 2009 15:12:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of precalculated
 values
In-Reply-To: <1237226020-14057-25-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161500280.20024@qirst.com>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie> <1237226020-14057-25-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> +int gfp_zone_table[GFP_ZONEMASK] __read_mostly;

The gfp_zone_table is compile time determinable. There is no need to
calculate it.

const int gfp_zone_table[GFP_ZONEMASK] = {
	ZONE_NORMAL,		/* 00 No flags set */
	ZONE_DMA,		/* 01 Only GFP_DMA set */
	ZONE_HIGHMEM,		/* 02 Only GFP_HIGHMEM set */
	ZONE_DMA,		/* 03 GFP_HIGHMEM and GFP_DMA set */
	ZONE_DMA32,		/* 04 Only GFP_DMA32 set */
	ZONE_DMA,		/* 05 GFP_DMA and GFP_DMA32 set */
	ZONE_DMA32,		/* 06 GFP_DMA32 and GFP_HIGHMEM set */
	ZONE_DMA,		/* 07 GFP_DMA, GFP_DMA32 and GFP_DMA32 set */
	ZONE_MOVABLE,		/* 08 Only ZONE_MOVABLE set */
	ZONE_DMA,		/* 09 MOVABLE + DMA */
	ZONE_MOVABLE,		/* 0A MOVABLE + HIGHMEM */
	ZONE_DMA,		/* 0B MOVABLE + DMA + HIGHMEM */
	ZONE_DMA32,		/* 0C MOVABLE + DMA32 */
	ZONE_DMA,		/* 0D MOVABLE + DMA + DMA32 */
	ZONE_DMA32,		/* 0E MOVABLE + DMA32 + HIGHMEM */
	ZONE_DMA		/* 0F MOVABLE + DMA32 + HIGHMEM + DMA
};

Hmmmm... Guess one would need to add some #ifdeffery here to setup
ZONE_NORMAL in cases there is no DMA, DMA32 and HIGHMEM.

