Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbXJEUfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbXJEUfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760724AbXJEUfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:35:42 -0400
Received: from gw.goop.org ([64.81.55.164]:54276 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760057AbXJEUfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:35:41 -0400
Message-ID: <4706A013.6080003@goop.org>
Date: Fri, 05 Oct 2007 13:35:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
References: <C32C1AD6.167B3%keir@xensource.com>
In-Reply-To: <C32C1AD6.167B3%keir@xensource.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> The PREEMPT_BITS limitation is a good argument for at least taking the pte
> locks in small batches though (small batches is preferable to one-by-one
> since we will want to batch the make-readonly-and-pin hypercall requests to
> amortise the cost of the hypervisor trap).

Hm, I don't see how we can avoid holding locks for the whole pagetable
at once.  We need to hold the locks from between marking a particular
pte page RO until the whole pagetable is pinned; if we don't, pte
updates can come in from other cpus, which will fault on the RO but
won't be fixed up by Xen.

Could we avoid it by doing a series of partial pins, locking and
unlocking each one in the process, and then pin the whole pagetable?

    J
