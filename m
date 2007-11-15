Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXKOK6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXKOK6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 05:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXKOK6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 05:58:08 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:44315 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751049AbXKOK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 05:58:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=C6RAyeseM+rx/NIOchpCk0dnu8UsNpNq1e5BanpEFvqdQlsuYsMPZPLmN4nW/wZ9m3flgQ9G/TbW1WHIvSov6HsEnbx4Fu26AVyJjxKJJSd7tcpLa77P/yIIxQ9LskXKkRiHTYYTRE8+7Lhz1T3Cj7es3X8qdKB3J1AcGyPeq3g=  ;
X-YMail-OSG: 9ZGtixcVM1nAx3l249vGOoL6uUulkOH3B2YNVm5C4qTD9G9rD19MIYEC2PAG.N.njoNC44tkBg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Date: Thu, 15 Nov 2007 21:57:59 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <20071114225335.GV19691@waste.org> <20071114.154143.112110604.davem@davemloft.net> <20071115104331.GA11390@elte.hu>
In-Reply-To: <20071115104331.GA11390@elte.hu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3YCPHlD4iawrIK8"
Message-Id: <200711152157.59409.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_3YCPHlD4iawrIK8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 15 November 2007 21:43, Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> > From: Matt Mackall <mpm@selenic.com>
> > Date: Wed, 14 Nov 2007 17:37:13 -0600
> >
> > > No, the usual strategy for debugging problems -outside- SLOB is to
> > > switch to another allocator with more extensive debugging facilities.
> >
> > Ok, so the thing we still can do is do a dump_stack() at the list
> > debugging assertion trigger points.
>
> ok, i'll first try to trigger it again.

I had implemented SLOB in userspace, so I resynched and think I
found your problem. Sorry for the attachment format -- this mailer
isn't the best. I'm really computer illiterate when it comes to
userspace...

Anyway, I'm really happy to see you're testing and using SLOB
upstream :) Is there any particular reason that you're using it?

Thanks,
Nick

--Boundary-00=_3YCPHlD4iawrIK8
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="slob-rotate-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="slob-rotate-fix.patch"

Previously, it would be possible for prev->next to point to &free_slob_pages,
and thus we would try to move a list onto itself, and bad things would
happen.

It seems a bit hairy to be doing list operations with the list marker as an
entry, rather than a head, but...

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c
+++ linux-2.6/mm/slob.c
@@ -321,7 +321,8 @@ static void *slob_alloc(size_t size, gfp
 		/* Improve fragment distribution and reduce our average
 		 * search time by starting our next search here. (see
 		 * Knuth vol 1, sec 2.5, pg 449) */
-		if (free_slob_pages.next != prev->next)
+		if (prev != free_slob_pages.prev &&
+				free_slob_pages.next != prev->next)
 			list_move_tail(&free_slob_pages, prev->next);
 		break;
 	}

--Boundary-00=_3YCPHlD4iawrIK8--
