Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYBHWYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYBHWYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYBHWYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:24:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYBHWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:24:42 -0500
Date: Fri, 8 Feb 2008 14:23:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: andrea@qumranet.com, holt@sgi.com, avi@qumranet.com, izike@qumranet.com,
       kvm-devel@lists.sourceforge.net, a.p.zijlstra@chello.nl,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org
Subject: Re: [patch 0/6] MMU Notifiers V6
Message-Id: <20080208142315.7fe4b95e.akpm@linux-foundation.org>
In-Reply-To: <20080208220616.089936205@sgi.com>
References: <20080208220616.089936205@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 14:06:16 -0800
Christoph Lameter <clameter@sgi.com> wrote:

> This is a patchset implementing MMU notifier callbacks based on Andrea's
> earlier work. These are needed if Linux pages are referenced from something
> else than tracked by the rmaps of the kernel (an external MMU). MMU
> notifiers allow us to get rid of the page pinning for RDMA and various
> other purposes. It gets rid of the broken use of mlock for page pinning.
> (mlock really does *not* pin pages....)
> 
> More information on the rationale and the technical details can be found in
> the first patch and the README provided by that patch in
> Documentation/mmu_notifiers.
> 
> The known immediate users are
> 
> KVM
> - Establishes a refcount to the page via get_user_pages().
> - External references are called spte.
> - Has page tables to track pages whose refcount was elevated but
>   no reverse maps.
> 
> GRU
> - Simple additional hardware TLB (possibly covering multiple instances of
>   Linux)
> - Needs TLB shootdown when the VM unmaps pages.
> - Determines page address via follow_page (from interrupt context) but can
>   fall back to get_user_pages().
> - No page reference possible since no page status is kept..
> 
> XPmem
> - Allows use of a processes memory by remote instances of Linux.
> - Provides its own reverse mappings to track remote pte.
> - Established refcounts on the exported pages.
> - Must sleep in order to wait for remote acks of ptes that are being
>   cleared.
> 

What about ib_umem_get()?
