Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYJCD5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYJCD5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYJCD5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:57:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbYJCD5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:57:05 -0400
Date: Thu, 2 Oct 2008 20:56:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
Message-Id: <20081002205604.47910d6d.akpm@linux-foundation.org>
In-Reply-To: <200810031347.21586.nickpiggin@yahoo.com.au>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<200810031259.17527.nickpiggin@yahoo.com.au>
	<20081002201410.07afff73.akpm@linux-foundation.org>
	<200810031347.21586.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 13:47:21 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > I expect there's no solution which avoids blocking the writers at some
> > stage.
> 
> See my other email. Something roughly like this would do the trick
> (hey, it actually boots and runs and does fix the problem too).

It needs exclusion to protect all those temp tags.  Is do_fsync()'s
i_mutex sufficient?  It's qute unobvious (and unmaintainable?) that all
the callers of this stuff are running under that lock.

> It's ugly because we don't have quite the right radix tree operations 
> yet (eg. lookup multiple tags, set tag X if tag Y was set, proper range
> lookups). But the theory is to up-front tag the pages that we need to
> get to disk.

Perhaps some callback-calling radix tree walker.

> Completely no impact or slowdown to any writers (although it does add
> 8 bytes of tags to the radix tree node... but doesn't increase memory
> footprint as such due to slab).

Can we reduce the amount of copy-n-pasting here?
