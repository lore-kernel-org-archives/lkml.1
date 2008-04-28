Return-Path: <linux-kernel-owner+w=401wt.eu-S966411AbYD1ScY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966411AbYD1ScY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936646AbYD1SZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:25:41 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53362 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936320AbYD1SZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:25:38 -0400
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804280903230.3119@woody.linux-foundation.org>
References: <1209320076.3801.26.camel@localhost.localdomain>
	 <20080428013400.GA6245@elte.hu>
	 <1209351113.3801.107.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0804280903230.3119@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:25:33 -0400
Message-Id: <1209407133.3367.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 09:05 -0700, Linus Torvalds wrote:
> 
> On Sun, 27 Apr 2008, James Bottomley wrote:
> > 
> > Try this; the signature for an uninitialised free list is easy (both
> > list pointers NULL), so the patch detects that and doesn't try to run
> > over the uninitialised list head.
> 
> Why aren't these things initialized?

They are, but not until we begin the freelist allocation.  That way we
can keep the list head being NULL as the signal for the freelist not
being initialised.

> You say that the signature of an uninitialised free list is trivial, but 
> that's not at all true in general. It depends intimately on how the memory 
> was allocated, and is thus very subtle indeed - some change to allocations 
> can break something simple like this, by initializing it with random old 
> memory contents.

No, no; for us it's guaranteed to be NULL ... they're allocated in the
host memory area with kzalloc. (and before kzalloc, we were using
kmalloc/memset because the host area has an API guarantee of being zero
initialised).

> So why not just initialize lists like this so early (ie at allocation 
> time) that problems like this cannot happen? Instead of adding ugly and 
> fragile cases to the freeing?

Because then I'd need another flag to know whether or not the free list
has actually been set up.  In theory, if we initialise the list,
list_empty() would do because when you're freeing you should always have
the reserve command on the free list ... but that would have prevented
us from seeing the bug Ingo reported recently (where we were freeing
with active commands), so I'm a bit reluctant to do that.

James


