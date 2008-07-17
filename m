Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYGQACO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYGQACO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYGQAB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:01:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:38706 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYGQABy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pZc0+3x4Ro8YRXQbhYzp2hWfV/Xy0uPhG+o1hf8Sn646tQubXflaiDn6yHWkot2XI2
         +AearsyEZqTs+v/0XY1IAeSUpZh0FzCej5FCyetdjV+VVPFrp1bx51+JN8Q+UqAS4Fz+
         RwCSPHbXdPRFKJx7rtEDVaz3dK2/G4PsIXs6c=
Subject: Re: madvise(2) MADV_SEQUENTIAL behavior
From: Eric Rannaud <eric.rannaud@gmail.com>
To: Chris Snook <csnook@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <487E628A.3050207@redhat.com>
References: <1216163022.3443.156.camel@zenigma>
	 <1216210495.5232.47.camel@twins>
	 <20080716105025.2daf5db2@cuia.bos.redhat.com> <487E628A.3050207@redhat.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 00:01:50 +0000
Message-Id: <1216252910.3443.247.camel@zenigma>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 17:05 -0400, Chris Snook wrote:
> Rik van Riel wrote:
> > I believe that for mmap MADV_SEQUENTIAL, we will have to do
> > an unmap-behind from the fault path.  Not every time, but
> > maybe once per megabyte, unmapping the megabyte behind us.
>
> Wouldn't it just be easier to not move pages to the active list when 
> they're referenced via an MADV_SEQUENTIAL mapping?  If we keep them on 
> the inactive list, they'll be candidates for reclaiming, but they'll 
> still be in pagecache when another task scans through, as long as we're 
> not under memory pressure.

This approach, instead of invalidating the pages right away would
provide a middle ground: a way to tell the kernel "these pages are not
too important".

Whereas if MADV_SEQUENTIAL just invalidates the pages once per megabyte
(say), then it's only doing what is already possible using MADV_DONTNEED
("drop this pages now"). It would automate the process, but it would not
provide a more subtle hint, which could be quite useful.

As I see it, there are two basic concepts here:
- no_reuse (like FADV_NOREUSE)
- more_ra (more readahead)
(DONTNEED being another different concept)

Then:
MADV_SEQUENTIAL = more_ra | no_reuse
FADV_SEQUENTIAL = more_ra | no_reuse
FADV_NOREUSE = no_reuse

Right now, only the 'more_ra' part is implemented. 'no_reuse' could be
implemented as Chris suggests.

It looks like the disagreement a year ago around Peter's approach was
mostly around the question of whether using read ahead as a heuristic
for "drop behind" was safe for all workloads.

Would it be less controversial to remove the heuristic (ra->size ==
ra->ra_pages), and to do something only if the user asked for
_SEQUENTIAL or _NOREUSE?

It might encourage user space applications to start using
FADV_SEQUENTIAL or FADV_NOREUSE more often (as it would become
worthwhile to do so), and if they do (especially cron jobs), the problem
of the slow desktop in the morning would progressively solve itself.

Thanks.

