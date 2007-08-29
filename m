Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbXH2OsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbXH2OsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXH2OsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:48:11 -0400
Received: from smtp141.iad.emailsrvr.com ([207.97.245.141]:56417 "EHLO
	smtp141.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXH2OsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:48:10 -0400
Subject: Re: speeding up swapoff
From: Daniel Drake <ddrake@brontes3d.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070829073040.1ec35176@laptopd505.fenrus.org>
References: <1188394172.22156.67.camel@localhost>
	 <20070829073040.1ec35176@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 10:44:43 -0400
Message-Id: <1188398683.22156.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 07:30 -0700, Arjan van de Ven wrote:
> > My experiments show that when there is not much free physical memory,
> > swapoff moves pages out of swap at a rate of approximately 5mb/sec.
> 
> sounds like about disk speed (at random-seek IO pattern)

We are only using 'standard' seagate SATA disks, but I would have
thought much more performance (40+ mb/sec) would be reachable.

> before you go there... is this a "real life" problem? Or just a
> mostly-artificial corner case? (the answer to that obviously is
> relevant for the 'should we really care' question)

It's more-or-less a real life problem. We have an interactive
application which, when triggered by the user, performs rendering tasks
which must operate in real-time. In attempt to secure performance, we
want to ensure everything is memory resident and that nothing might be
swapped out during the process. So, we run swapoff at that time.

If there is a decent number of pages swapped out, the user sits for a
while at a 'please wait' screen, which is not desirable. To throw some
numbers out there, likely more than a minute for 400mb of swapped pages.

Sure, we could run the whole interactive application with swap disabled,
which is pretty much what we do. However we have other non-real-time
processing tasks which are very memory hungry and do require swap. So,
there are 'corner cases' where the user can reach the real-time part of
the interactive application when there is a lot of memory swapped out.

> Another question, if this is during system shutdown, maybe that's a
> valid case for flushing most of the pagecache first (from userspace)
> since most of what's there won't be used again anyway. If that's enough
> to make this go faster...

Shutdown isn't a concern here.

> A third question, have you investigated what happens if a process gets
> killed that has pages in swap; as long as we don't page those in but
> just forget about them, that would solve the shutdown problem nicely
> (since we kill stuff first anyway there)

According to top, those pages in swap disappear when the process is
killed. So, I don't think there are any swap-related performance issues
on the shutdown path.

Thanks.
-- 
Daniel Drake
Brontes Technologies, A 3M Company
http://www.brontes3d.com/opensource

