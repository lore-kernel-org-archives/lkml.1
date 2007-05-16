Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXEPNKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXEPNKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXEPNKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:10:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:39855 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXEPNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mXkeF2FDsugZMEC1teSVfEIFME/AyEnYpWjmICZkLNkcSteZNrxacdXJn46thJBpt036TvVA++pkXcpwKdnMzevBb3ZbDJRARToqLMxM3h5XwDdpXCXlGaTF0F+RO0ZhAfsNZjWgLDlkURniX6L7mjNSxojinGf/7mdS4w97FXQ=
Message-ID: <6278d2220705160609x5c8462b6i25935a449352bf12@mail.gmail.com>
Date: Wed, 16 May 2007 14:09:59 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Zoltan Menyhart" <Zoltan.Menyhart@bull.net>
Subject: Re: copy_one_pte()
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <461209BE.6010905@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220704020917h69d7c0d1t7ac61a544ec23f4@mail.gmail.com>
	 <461209BE.6010905@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/07, Zoltan Menyhart <Zoltan.Menyhart@bull.net> wrote:
> Daniel J Blueman wrote:
> > On 13 Mar, 20:20, Zoltan Menyhart <Zoltan.Menyh...@free.fr> wrote:
> >
> >> I had a look at copy_one_pte().
> >> I cannot see any ioproc_update_page() call, not even for the COW pages.
> >> Is it intentional?
> >
> > There could be an ioproc_update_range() call in
> > memory.c:copy_pte_range(), after the pte_unmap_unlock(), and this
> > would be an optimisation, since explicitly updating the mappings in
> > the Quadrics RDMA NIC avoids the need for the NIC to trap and update
> > it's MMU later.
>
> I can agree that this optimization is a good idea.
>
> Can you please confirm that cp->update_range() understands the concept of
> the COW? (I.e. the card should not write anything into the COW pages.)
>
> > The code which implements [1] this takes the pagetable locks with
> > pte_offset_map_lock(), and uses one of the kmap_atomic slots, so has
> > to be after the pagetables are unlocked. The
> > ioproc_invalidate_page/range() calls are different and can't live with
> > this race, so have to be used with the pagetable locks held.
>
> I can see two issues here:
>
> - Performance problem: page_table_lock is more expensive than a split lock,
>   and taking page_table_lock after the split lock released is even worse.

I have introduced an ioproc_update_page_locked() call for this and
related paths, and updated the kernel patches; this avoids a race
condition I was seeing in multi-threaded processes taking concurrent
page faults under the split locks. The split lock is now acquired
once, and the changes allowed me to do other some optimisations on
this path too.

> - Synchronization problem: do_wp_page() is protected by the appropriate
>   split lock, i.e. the COW page can be broken up while you are inside
>   cp->update_range() under the protection of page_table_lock.

The split locks were used previously via pte_offset_map_lock(), so
this race wasn't possible previously.

> I think the PTE modification and the cp->update_xxx() should be protected
> by the very same lock, without releasing it between the two operations.
> I think the PTE modification and the cp->update_xxx() should be an
> atomic operation with respect to the VMM activity.

This does make most sense and is now the case, although atomiticity
wasn't a problem, since it's fine to use ioproc_update_page/range()
speculatively.

Dan

> Thanks,
>
> Zoltan
-- 
Daniel J Blueman
