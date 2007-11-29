Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbXK2Npw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbXK2Npw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760658AbXK2Npm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:45:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41824 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbXK2Npm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:45:42 -0500
Date: Thu, 29 Nov 2007 14:45:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
Message-ID: <20071129134535.GA28180@one.firstfloor.org>
References: <474C34CC.6060509@gmail.com> <p734pf59wf7.fsf@crumb.suse.de> <19f34abd0711290524k49628a0dja8a5a04d10253157@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0711290524k49628a0dja8a5a04d10253157@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't need to flush all CPUs. This is my rationale: The debug
> exception (single-step trap) will always happen on the same CPU that
> the page fault occurred on. Page fault shows the page, debug exception
> hides the page again. Between those two operations, nothing else can

You're ignoring preemptible kernels for once.

Also there is always a race. e.g. consider another CPU fetches
the entry into its TLB while you have it temporarily unprotected.
Then you protect it again but the other CPU still keeps the unprotected
entry in its TLBs which you don't flush.

In general any changes to the direct mapping have to be done globally.

> happen that will use the TLB entry in question (unless you have some
> weird race condition, but then the code is in error anyway).
> 
> What is c_p_a() and what is a flush object?

change_page_attr() is designed to queue flush requests for later which
are then done by global_tlb_flush() For that it creates a list of pages.
It cannot be safely used without global_flush_tlb() otherwise the flush
list will just grow unbounded.

You could in theory write an equivalent optimized for your case that does
not require that, but it's not even safe for your case anyways.

-Andi

