Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYA1SvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYA1SvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYA1SvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:51:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42433 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbYA1SvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:51:04 -0500
Date: Mon, 28 Jan 2008 10:51:03 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/4] mmu_notifier: Core code
In-Reply-To: <20080126115639.GQ26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801281048330.14003@schroedinger.engr.sgi.com>
References: <20080125055606.102986685@sgi.com> <20080125055801.212744875@sgi.com>
 <20080125183934.GO26420@sgi.com> <Pine.LNX.4.64.0801251041040.672@schroedinger.engr.sgi.com>
 <20080125185646.GQ3058@sgi.com> <Pine.LNX.4.64.0801251058170.3198@schroedinger.engr.sgi.com>
 <20080125193554.GP26420@sgi.com> <Pine.LNX.4.64.0801251206390.7856@schroedinger.engr.sgi.com>
 <20080126115639.GQ26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008, Robin Holt wrote:

> > No you cannot do that because there are still callbacks that come later. 
> > The invalidate_all may lead to invalidate_range() doing nothing for this 
> > mm. The ops notifier and the freeing of the structure has to wait until 
> > release().
> 
> Could you be a little more clear here?  If you are saying that the other
> callbacks will need to do work?  I can assure you we will clean up those
> pages and raise memory protections.  It will also be done in a much more
> efficient fashion than the individual callouts.

No the other callbacks need to work in the sense that they can be called. 
You could have them do nothing after an invalidate_all().
But you cannot release the allocated structs needed for list traversal 
etc.

> If, on the other hand, you are saying we can not because of the way
> we traverse the list, can we return a result indicating to the caller
> we would like to be unregistered and then the mmu_notifier code do the
> remove followed by a call to the release notifier?

You would need to release the resources when the release notifier is 
called.

> > That does not sync with the current scheme of the invalidate_range() 
> > hooks. We would have to do a global invalidate early and then place the 
> > other invalidate_range hooks in such a way that none is called in later in 
> > process exit handling.
> 
> But if the notifier is removed from the list following the invalidate_all
> callout, there would be no additional callouts.

Hmmm.... Okay did not think about that. Then you would need to do a 
synchronize_rcu() in invalidate_all()?

