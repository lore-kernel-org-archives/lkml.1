Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYKQGTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYKQGTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYKQGTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:19:38 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:28813 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752494AbYKQGTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:19:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uLg5H70f0VZhJDsZQYQ6rYVkGSi7suIiqkdrcsM3cSgLRX3W7Dtn9glkU1a22iIVqTVBEmTUSgdo0+MFvhexXvPQVWuvi7GoWASLnMdajrWBswEOUqfyb7cVPHlEuNdfssQrh1w8Ws6zTrw+fU4U0fp0thyRZo/juNnTDulD6x4=  ;
X-YMail-OSG: WM2ZE94VM1lQmzjeL8m_rwg7gpNe90pYVjdWBsaiBXUJ.J7OaaU2hvApFJpL5fctfnpb2pgd3OeTAqc08Lb2FcpMK_XAghYrYAYbxzH0lBit1HckYVSBkW5xpIwLoO98XQfAHFJASfLusa2sLAHOkJVbX6EvKZg0dAWykOl0YOIA8XEeBerQ.5Ep3rUm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: evict streaming IO cache first
Date: Mon, 17 Nov 2008 17:19:31 +1100
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Gene Heskett <gene.heskett@gmail.com>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com> <49208E9A.5080801@redhat.com> <20081116204720.1b8cbe18.akpm@linux-foundation.org>
In-Reply-To: <20081116204720.1b8cbe18.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811171719.31936.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008 15:47, Andrew Morton wrote:
> On Sun, 16 Nov 2008 16:20:26 -0500 Rik van Riel <riel@redhat.com> wrote:

> > I will take a look at producing smoother self tuning behaviour
> > in get_scan_ratio(), with logic along these lines:
> > - the more file pages are inactive, the more eviction should
> >    focus on file pages, because we are not eating away at the
> >    working set yet
> > - the more file pages are active, the more there needs to be
> >    a balance between file and anon scanning, because we are
> >    starting to get to the working sets for both
>
> hm.  I wonder if it would be prohibitive to say "hey, we did the wrong
> thing in that scanning pass - rewind and try it again".  Probably it
> would be.
>
> Anyway, we need to do something.
>
> Shouldn't get_scan_ratio() be handling this case already?

I have a patch that was actually for the old vmscan logic that I
found really helps prevent working set get paged out. Actually
the old vmscan behaviour wasn't any good either at preventing
unmapped pagecache from being evicted, which is the main thing I
was trying to fix (eg. keep git tree in cache while doing other
use-once IO).

It ended up working really well, but I suspect it would still fall
over in the case where you were trying to populate your caches with
the git tree *while* the streaming IO is happening (if those pages
don't have a chance to get touched again for a while, they'll look
like use-once IO to the vm)... but still no worse than current
behaviour.

I need to forward port it to the new system, however...

But this would be a pretty big change and I can't see how it could
be appropriate for -rc6. Aren't we allergic to even single-line
changes in vmscan without seemingly multi-year "testing" phases? :)
