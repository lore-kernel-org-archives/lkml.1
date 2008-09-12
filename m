Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYILQfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYILQfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYILQfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:35:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36250 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYILQe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:34:59 -0400
Subject: Re: [RFC v3][PATCH 5/9] Memory managemnet (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <48C8CAC6.3090209@cs.columbia.edu>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040404060.5982@takamine.ncl.cs.columbia.edu>
	 <1220551683.23386.32.camel@nimitz> <48C345D2.1020603@cs.columbia.edu>
	 <1220892596.23386.166.camel@nimitz> <48C6113A.3080804@cs.columbia.edu>
	 <1221082922.6781.62.camel@nimitz>  <48C8CAC6.3090209@cs.columbia.edu>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 09:34:48 -0700
Message-Id: <1221237288.17910.26.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 03:37 -0400, Oren Laadan wrote:
> Let me start with the bottom line - since this creates too much confusion,
> I'll just switch to the alternative: will use get_user_pages() to bring
> pages in and copy the data directly. Hopefully this will end the discussion.
> 
> (Note, there there is a performance penalty in the form of extra data copy:
> instead of reading data directly to the page, we instead read into a buffer,
> kmap_atomic the page and copy into the page).

Yep but, as we discussed on IRC, this code needs some optimization for
pages in swap, anyway.  It isn't optimal for those, either.  So, for
this we'll leave it at a minimal amount of code rather than maximal
functionality. :)

> > I bugged Serge about this.  He said that this, at least, bypasses the SE
> > Linux checks that are normally done with an mprotect() system call.
> > That's a larger design problem that we need to keep in mind: we need to
> > be careful to keep existing checks in place.
> 
> I also discussed this with Serge, and I got the impression that he
> agreed that there was no security issue because it was all and only
> about private memory.

Yep, as long as there are some sanity checks to make sure that we're not
overriding permissions, I'm happy with this.

> If a task is ptraced, then the tracer can easily arrange for the tracee
> to call mprotect(), or to call sys_restart() with a tampered checkpoint
> file, or do other tricks. The call to mprotect_fix(), on a private vma,
> does not make this any worse. That is why I didn't bother implementing
> that bit.

I completely agree that it isn't an issue on a private VMA.  My only
concern is if this is done to any shared memory or could potentially be
abused in such a way that it gets applied to shared memory.

-- Dave

