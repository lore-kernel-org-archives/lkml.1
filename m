Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYDBWJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYDBWJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYDBWIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:08:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37999 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755435AbYDBWIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:08:54 -0400
Date: Wed, 2 Apr 2008 15:06:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: Require single threadedness for registration.
In-Reply-To: <20080402220148.GV19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com>
 <20080402220148.GV19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Andrea Arcangeli wrote:

> That would work for #v10 if I remove the invalidate_range_start from
> try_to_unmap_cluster, it can't work for EMM because you've
> emm_invalidate_start firing anywhere outside the context of the
> current task (even regular rmap code, not just nonlinear corner case
> will trigger the race). In short the single threaded approach would be

But in that case it will be firing for a callback to another mm_struct. 
The notifiers are bound to mm_structs and keep separate contexts.

> The requirement for invalidate_page is that the pte and linux tlb are
> flushed _before_ and the page is freed _after_ the invalidate_page
> method. that's not the case for _begin/_end. The page is freed well
> before _end runs, hence the need of _begin and to block the secondary
> mmu page fault during the vma-mangling operations.

You could flush in _begin and free on _end? I thought you are taking a 
refcount on the page? You can drop the refcount only on _end to ensure 
that the page does not go away before.

