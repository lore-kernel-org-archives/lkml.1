Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbYDBWRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbYDBWRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYDBWRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:17:25 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51141
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYDBWRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:17:25 -0400
Date: Thu, 3 Apr 2008 00:17:16 +0200
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
Subject: Re: EMM: Require single threadedness for registration.
Message-ID: <20080402221716.GY19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com> <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:06:19PM -0700, Christoph Lameter wrote:
> On Thu, 3 Apr 2008, Andrea Arcangeli wrote:
> 
> > That would work for #v10 if I remove the invalidate_range_start from
> > try_to_unmap_cluster, it can't work for EMM because you've
> > emm_invalidate_start firing anywhere outside the context of the
> > current task (even regular rmap code, not just nonlinear corner case
> > will trigger the race). In short the single threaded approach would be
> 
> But in that case it will be firing for a callback to another mm_struct. 
> The notifiers are bound to mm_structs and keep separate contexts.

Why can't it fire on the mm_struct where GRU just registered? That
mm_struct existed way before GRU registered, and VM is free to unmap
it w/o mmap_sem if there was any memory pressure.

> You could flush in _begin and free on _end? I thought you are taking a 
> refcount on the page? You can drop the refcount only on _end to ensure 
> that the page does not go away before.

we're going to lock + flush on begin and unlock on _end w/o
refcounting to microoptimize. Free is done by
unmap_vmas/madvise/munmap at will. That's a very slow path, inflating
the balloon is not problematic. But invalidate_page allows to avoid
blocking page faults during swapping so minor faults can happen and
refresh the pte young bits etc... When the VM unmaps the page while
holding the page pin, there's no race and that's where invalidate_page
is being used to generate lower invalidation overhead.
