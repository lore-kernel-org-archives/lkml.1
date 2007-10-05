Return-Path: <linux-kernel-owner+w=401wt.eu-S1762430AbXJES72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430AbXJES72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXJES7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:59:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbXJES7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:59:19 -0400
Date: Fri, 5 Oct 2007 14:58:28 -0400
From: Rik van Riel <riel@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: race with page_referenced_one->ptep_test_and_clear_young and
 pagetable setup/pulldown
Message-ID: <20071005145828.17ba9c69@cuia.boston.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com>
References: <470596C4.8060804@goop.org>
	<Pine.LNX.4.64.0710051146300.25518@blonde.wat.veritas.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007 12:36:33 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> To my naive mind, your problem actually lies in those two stages:
> whatever marks the pages RO should not be keeping Xen in ignorance.

It does.  Telling Xen to pin the page as a page table page is
basically the first thing a Xen kernel does after marking the
page read-only.

This makes for a narrow race window, during which ptep_test_and_clear_young
cannot clear the referenced bit and may end up causing a crash.  We do not
care about it not clearing the referenced bit during that window, since it
will be cleared during the next go-around and the race is very rare.

Hence, the only thing we need to fix is the crash.

We can do that by adding an entry for ptep_test_and_clear_young to the
exception table.  This way we do not need to turn this into a new paravirt
ops hook (since the fast path is exactly the same as x86 native) and there
is no need for added complexity.

Also, Xen would not conflict with SPLIT_PTLOCK_CPUS.

-- 
All Rights Reversed
