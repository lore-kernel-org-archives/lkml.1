Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbYDEAXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbYDEAXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 20:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYDEAXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 20:23:33 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:60858
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYDEAXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 20:23:33 -0400
Date: Sat, 5 Apr 2008 02:23:30 +0200
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
Subject: Re: [PATCH] mmu notifier #v11
Message-ID: <20080405002330.GF14784@duo.random>
References: <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com> <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com> <20080402221716.GY19189@duo.random> <Pine.LNX.4.64.0804021821230.639@schroedinger.engr.sgi.com> <20080403151908.GB9603@duo.random> <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com> <20080404202055.GA14784@duo.random> <Pine.LNX.4.64.0804041504310.12396@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804041504310.12396@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 03:06:18PM -0700, Christoph Lameter wrote:
> Adds some comments. Still objectionable is the multiple ways of
> invalidating pages in #v11. Callout now has similar locking to emm.

range_begin exists because range_end is called after the page has
already been freed. invalidate_page is called _before_ the page is
freed but _after_ the pte has been zapped.

In short when working with single pages it's a waste to block the
secondary-mmu page fault, because it's zero cost to invalidate_page
before put_page. Not even GRU need to do that.

Instead for the multiple-pte-zapping we have to call range_end _after_
the page is already freed. This is so that there is a single range_end
call for an huge amount of address space. So we need a range_begin for
the subsystems not using page pinning for example. When working with
single pages (try_to_unmap_one, do_wp_page) invalidate_page avoids to
block the secondary mmu page fault, and it's in turn faster.

Besides avoiding need of serializing the secondary mmu page fault,
invalidate_page also reduces the overhead when the mmu notifiers are
disarmed (i.e. kvm not running).
