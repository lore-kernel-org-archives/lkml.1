Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbYE2VOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbYE2VOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYE2VOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:14:35 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:22373 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753596AbYE2VOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:14:34 -0400
Date: Fri, 30 May 2008 06:12:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080529211207.GB13663@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	akpm@linux-foundation.org, mpm@selenic.com
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI> <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com> <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com> <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 04:21:05PM +0300, Pekka J Enberg wrote:
> On Thu, 29 May 2008, David Howells wrote:
> > ELF-FDPIC is currently using kobjsize() so that it can expand the heap/stack
> > segment to fill up the entirety of its allocation.  It's probably worth
> > dropping that, though.
> > 
> > NOMMU mmap() is using kobjsize()/ksize() to keep track of the number of bytes
> > allocated and the amount of dead space.  We can probably ditch that too.
> > 
> > However, fs/proc/task_nommu.c uses kobjsize() quite a bit to determine how
> > much metadata space a process is carrying around.  We could just use sizeof(),
> > I suppose, and not bother calculating the slack.
> 
> For short term, we should merge my two nommu patches as-is, no?

Not until the page->index bits are killed, otherwise you aren't fixing
anything. SLOB on nommu with those page->index tests will automatically
oops today, before or after your patches. Until that's resolved, there's
no point in pretending like kobjsize() has been "fixed". As no one has
come up with a valid reason for those tests existing in the first place,
simply having your patches and killing the BUG_ON()'s seems ok.

If we're not going to kill the BUG_ON()'s, then your patches are purely
cosmetic fixups with no behavioural change -- (ie, nommu is still hosed
on SLOB with current git).
