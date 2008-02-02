Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbYBBAFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbYBBAFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbYBBAFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:05:12 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52736 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758836AbYBBAFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:05:09 -0500
Date: Fri, 1 Feb 2008 16:05:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/4] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080201233528.GE12099@sgi.com>
Message-ID: <Pine.LNX.4.64.0802011602360.21158@schroedinger.engr.sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201050623.344041545@sgi.com>
 <20080201220952.GA3875@sgi.com> <Pine.LNX.4.64.0802011517430.20608@schroedinger.engr.sgi.com>
 <20080201233528.GE12099@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Robin Holt wrote:

> On Fri, Feb 01, 2008 at 03:19:32PM -0800, Christoph Lameter wrote:
> > On Fri, 1 Feb 2008, Robin Holt wrote:
> > 
> > > We are getting this callout when we transition the pte from a read-only
> > > to read-write.  Jack and I can not see a reason we would need that
> > > callout.  It is causing problems for xpmem in that a write fault goes
> > > to get_user_pages which gets back to do_wp_page that does the callout.
> > 
> > Right. You placed it there in the first place. So we can drop the code 
> > from do_wp_page?
> 
> No, we need a callout when we are becoming more restrictive, but not
> when becoming more permissive.  I would have to guess that is the case
> for any of these callouts.  It is for both GRU and XPMEM.  I would
> expect the same is true for KVM, but would like a ruling from Andrea on
> that.

do_wp_page is entered when the pte shows that the page is not writeable 
and it makes the page writable in some situations. Then we do not 
invalidate the remote reference.

However, when we do COW then a *new* page is put in place of the existing 
readonly page. At that point we need to remove the remote pte that is 
readonly. Then we install a new pte pointing to a *different* page that is 
writable.

Are you saying that you get the callback when transitioning from a read 
only to a read write pte on the *same* page?

