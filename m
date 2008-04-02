Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbYDBV4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbYDBV4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbYDBV4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:56:12 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50263
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760150AbYDBV4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:56:10 -0400
Date: Wed, 2 Apr 2008 23:56:04 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/9] Convert anon_vma lock to rw_sem and refcount
Message-ID: <20080402215604.GU19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205636.777127252@sgi.com> <20080402175058.GR19189@duo.random> <Pine.LNX.4.64.0804021107520.27337@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021107520.27337@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:15:26AM -0700, Christoph Lameter wrote:
> On Wed, 2 Apr 2008, Andrea Arcangeli wrote:
> 
> > On Tue, Apr 01, 2008 at 01:55:36PM -0700, Christoph Lameter wrote:
> > >   This results in f.e. the Aim9 brk performance test to got down by 10-15%.
> > 
> > I guess it's more likely because of overscheduling for small crtitical
> > sections, did you counted the total number of context switches? I
> > guess there will be a lot more with your patch applied. That
> > regression is a showstopper and it is the reason why I've suggested
> > before to add a CONFIG_XPMEM or CONFIG_MMU_NOTIFIER_SLEEP config
> > option to make the VM locks sleep capable only when XPMEM=y
> > (PREEMPT_RT will enable it too). Thanks for doing the benchmark work!
> 
> There are more context switches if locks are contended. 
> 
> But that has actually also some good aspects because we avoid busy loops 
> and can potentially continue work in another process.

That would be the case if the "wait time" would be longer than the
scheduling time, the whole point is that with anonvma the write side
is so fast it's likely never worth scheduling (probably not even with
preempt-rt for the write side, the read side is an entirely different
matter but the read side can run concurrently if the system is heavy
paging), hence the slowdown. What you benchmarked is the write side,
which is also the fast path when the system is heavily CPU bound. I've
to say aim is a great benchmark to test this regression.

But I think a config option will solve all of this.
