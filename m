Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXHCBeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXHCBeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 21:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbXHCBeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 21:34:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37605 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756302AbXHCBeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 21:34:06 -0400
Date: Thu, 2 Aug 2007 18:34:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
In-Reply-To: <20070803011448.GF14775@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0708021827280.13538@schroedinger.engr.sgi.com>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de>
 <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
 <20070802034201.GA32631@wotan.suse.de> <Pine.LNX.4.64.0708021254160.8527@schroedinger.engr.sgi.com>
 <20070803002639.GC14775@wotan.suse.de> <Pine.LNX.4.64.0708021748110.13312@schroedinger.engr.sgi.com>
 <20070803005700.GD14775@wotan.suse.de> <Pine.LNX.4.64.0708021801010.13312@schroedinger.engr.sgi.com>
 <20070803011448.GF14775@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Nick Piggin wrote:

> Yeah it only gets set if the parent is initially using a default policy
> at this stage (and then is restored afterwards of course).

Uggh. Looks like more hackery ahead. I think this cannot be done in the 
desired clean way until we have some revving of the memory policy 
subsystem that makes policies task context independent so that you can do

alloc_pages(...., memory_policy)

The cleanest solution that I can think of at this point is certainly to 
switch to another processor and do the allocation and copying actions from 
there. We have the migration process context right? Can that be used to 
start the new thread and can the original processor wait on some flag 
until that is complete?

Forking off from there not only places the data correctly but it also 
warms up the caches for the new process and avoids evicting cacheline on 
the original processor.
