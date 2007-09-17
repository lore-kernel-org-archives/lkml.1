Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbXIRJXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbXIRJXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXIRJXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:23:37 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:40152 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753861AbXIRJXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:23:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=guEUWz0ib3lTpGa8dOBs8+UfV6sE66jm9bBMKUjELTCTGNcDR9mQnKRB4nNEmh3tgXrT5zvLOjcf15axN9n7ZBzVxUuWy8+QUJj8tdjuoXPk+gW8dtM8QS55R7PI9rPnXwyqMm0r3456/dLelbMEJinhbz6cZPCnLI2uQJwVtho=  ;
X-YMail-OSG: Ne1YVToVM1m.OhEpXc9bJYMH4reDDBny7ektgxZMiShniCOmRiY.VqcFIeJhvOMCwE7vTafx4Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Date: Tue, 18 Sep 2007 03:12:31 +1000
User-Agent: KMail/1.9.5
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk> <200709170828.01098.nickpiggin@yahoo.com.au> <46EEB3AC.20205@redhat.com>
In-Reply-To: <46EEB3AC.20205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709180312.31937.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 03:04, Rik van Riel wrote:
> Nick Piggin wrote:
> > (Rik has a patch sitting in -mm I believe which would make this problem
> > even worse, by doing even less highmem scanning in response to lowmem
> > allocations).
>
> My patch should not make any difference here, since
> balance_pgdat() already scans the zones from high to
> low and sets an end_zone variable that determines the
> highest zone to scan.
>
> All my patch does is make sure that we do not try to
> reclaim excessive amounts of dma or low memory when
> a higher zone is full.

Sorry, yeah I had it the wrong way around. Your patch would not
increase the probability of this problem.

We could have some logic in there to scan highmem when buffer
heads are over limit. But that really kind of sucks in that it introduces
some arbitrary point where reclaim behaviour completely changes...
Adding a shrinker for buffer heads is the "logical" approach that we
take for other non-page caches. That also kind of sucks because we
normally don't want to do this out of band buffer reclaiming and just
have it work from page reclaim (it will introduce extra locking and list
scanning).

Maybe when the machine is near OOM, we can just change the scanning
to do all zones -- a change in scanning behaviour at that point is better
than oom kill.
