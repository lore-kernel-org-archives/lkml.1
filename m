Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbXBDBXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbXBDBXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXBDBXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:23:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbXBDBXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:23:03 -0500
Date: Sat, 3 Feb 2007 17:22:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
Message-Id: <20070203172242.e5bf2534.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	<20070203005316.eb0b4042.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
	<1170525860.3073.1054.camel@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 11:03:59 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> Here is the second piece removing mlock pages off the LRU during scanning. 
> I tried moving them to a separate list but then we run into issues with
> locking. We do not need ithe list though since we will encounter the
> page again anyways during zap_pte_range.
> 
> However, in zap_pte_range we then run into another problem. Multiple 
> zap_pte_ranges may handle the same page and without a page flag and 
> scanning all the vmas we cannot determine if the page should or should not 
> be moved back to the LRU. As a result this patch may decrement NR_MLOCK 
> too much so that is goes below zero. Any ideas on how to fix this without 
> a page flag and a scan over vmas?
> 
> Plus there is the issue of NR_MLOCK only being updated when we are 
> reclaiming and when we may already be in trouble. An app may mlock huge 
> amounts of memory and NR_MLOCK will stay low. If memory gets too low then
> NR_MLOCKED is suddenly become accurate and the VM is likely undergoing a 
> shock from that discovery (should we actually use NR_MLOCK elsewhere to 
> determine memory management behavior). Hopefully we will not fall over 
> then.

Do we actually need NR_MLOCK?  Page reclaim tends to care more about the
size of the LRUs and doesn't have much dependency on ->present_pages,
iirc.

I guess we could use NR_MLOCK for writeback threshold calculations, to
force writeback earlier if there's a lot of mlocked memory in the affected
zones.  But that code isn't zone-aware anyway, and we don't know how to make
it zone aware in any sane fashion and making it cpuset-aware isn't very
interesting or useful..

So..  Why do we want NR_MLOCK?
