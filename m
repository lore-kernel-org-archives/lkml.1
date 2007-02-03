Return-Path: <linux-kernel-owner+w=401wt.eu-S1750959AbXBCSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbXBCSEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 13:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXBCSEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 13:04:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43238 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXBCSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 13:04:39 -0500
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	 <20070203005316.eb0b4042.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 03 Feb 2007 19:04:20 +0100
Message-Id: <1170525860.3073.1054.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-03 at 09:56 -0800, Christoph Lameter wrote:
> On Sat, 3 Feb 2007, Andrew Morton wrote:
> 
> > I wonder if it can be simpler.  Make two changes:
> 
> Would be great if this could get simpler.
> 
> > a) If the scanner encounters an mlocked page on the LRU, take it off.
> 
> The current patch takes them off when mlock is set (which may not work 
> since the page may be off the LRU) and then has the scanner taking them 
> off. We could just remove the early one but what would this bring us?

it's simpler. You only move them off when you encounter them during a
scan. No walking early etc etc. Only do work when there is an actual
situation where you do scan.

> 
> > b) munlock() adds all affected pages to the LRU.
> 
> Hmmm... You mean without checking all the vmas of a page for VM_LOCKED? So they 
> are going to be removed again on the next pass? Ok. I see that makes it 
> simpler but it requires another reclaim scan.

Well.. That's the point! Only IF there is a reclaim scan do you move
them out again. The fact that these pages are on the list isn't a
problem. The fact that you keep encountering them over and over again
during *scanning* is. So Andrews suggestion makes them go away in the
situations that actually matter

> The page flag allows a clean state transition of a page and accurate 
> keeping of statistics for MLOCKed pages. There were objections against the 
> fuzzy counting in the earlier incarnation and it was proposed that a page 
> flag be introduced. Without the flag we cannot know that the page is 
> already mapped by a VM_LOCKED vma without scanning over all vmas 
> referencing the page.

who cares though.. just do it lazy.


