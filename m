Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbYDDMau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbYDDMau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYDDMam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:30:42 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:49326
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYDDMam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:30:42 -0400
Date: Fri, 4 Apr 2008 14:30:40 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: disable other notifiers before register and unregister
Message-ID: <20080404123040.GC10185@duo.random>
References: <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com> <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com> <20080402221716.GY19189@duo.random> <Pine.LNX.4.64.0804021821230.639@schroedinger.engr.sgi.com> <20080403151908.GB9603@duo.random> <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 12:20:41PM -0700, Christoph Lameter wrote:
> On Thu, 3 Apr 2008, Andrea Arcangeli wrote:
> 
> > My attempt to fix this once and for all is to walk all vmas of the
> > "mm" inside mmu_notifier_register and take all anon_vma locks and
> > i_mmap_locks in virtual address order in a row. It's ok to take those
> > inside the mmap_sem. Supposedly if anybody will ever take a double
> > lock it'll do in order too. Then I can dump all the other locking and
> 
> What about concurrent mmu_notifier registrations from two mm_structs 
> that have shared mappings? Isnt there a potential deadlock situation?

No, the ordering of the lock avoids that. Here a snippnet.

/*
 * This operation locks against the VM for all pte/vma/mm related
 * operations that could ever happen on a certain mm. This includes
 * vmtruncate, try_to_unmap, and all page faults. The holder
 * must not hold any mm related lock. A single task can't take more
 * than one mm lock in a row or it would deadlock.
 */

So you can't do:

   mm_lock(mm1);
   mm_lock(mm2);

But if two different tasks run the mm_lock everything is ok. Each task
in the system can lock at most 1 mm at time.

> Well good luck. Hopefully we will get to something that works.

Looks good so far but I didn't finish it yet.
