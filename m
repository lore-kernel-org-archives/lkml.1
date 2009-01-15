Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbZAONZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbZAONZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZAONZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:25:17 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47591 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbZAONZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:25:15 -0500
Date: Thu, 15 Jan 2009 13:24:10 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about do_wp_page() and lock_page()
In-Reply-To: <200901151801.23580.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0901151240490.23036@blonde.anvils>
References: <1231968908.3198.17.camel@dhcp-100-19-198.bos.redhat.com>
 <200901151801.23580.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Nick Piggin wrote:
> On Thursday 15 January 2009 08:35:08 Larry Woodman wrote:
> > Why is it safe for do_wp_page() to call cow_user_page() without locking
> > the old_page first?  If a Direct IO read is outstanding on the old_page
> > or its the buffer to the file_read_actor() cant its contents change
> > during the COW fault?  Is this not a problem?

A problem for the application if it isn't synchronizing itself adequately.

> 
> Direct IO doesn't lock the pages either.
> 
> There has simply never been any synchronisation here (by design: see
> MADV_DONTFORK/MADV_DOFORK/VM_DONTCOPY etc).
> 
> This is one thing which Andrea had been trying to improve. If it can
> be done without introducing nasty overheads, then yes it would be
> nice to improve COW vs DIO semantics.

As far as Larry's question goes, direct IO is just a red herring.

If the page being COWed is a shared file page, another process could
have that page mapped shared writable, and be concurrently modifying
it - locking in do_wp_page won't protect against that at all.

And even if the page being COWed is an anonymous page, the normal
case is that the COW was done before starting direct IO or file
read into this page by this process.

When multithreaded there are indeed cases (fork) when the page
can get writeprotected and COW again, and that give surprises.

But your operative words are "There has simply never been any
synchronisation here (by design": the app would have to provide
the syncronisation it needs.  The kernel just makes sure it does
not free any pages while they're still subject to being modified.

It's consistent with the inconsistent way in which writing to a
MAP_PRIVATE mapping of a file faults in snapshots of pages of the
file as userspace modifies them, but leaves the intervening untouched
pages showing more recent modifications placed there by others.

Hugh
