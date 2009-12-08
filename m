Return-Path: <linux-kernel-owner+w=401wt.eu-S965274AbZLHAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274AbZLHAnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965245AbZLHAnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:43:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35362 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965246AbZLHAnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:43:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: Increased Buffers due to patch 56e49d (vmscan: evict use-once pages first), but why exactly?
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <4B1D46C0.4040503@redhat.com>
References: <4B1D12E7.4070701@linux.vnet.ibm.com> <4B1D46C0.4040503@redhat.com>
Message-Id: <20091208093533.B57B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 09:43:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/07/2009 09:36 AM, Christian Ehrhardt wrote:
> > Hi,
> > commit 56e49d - "vmscan: evict use-once pages first" changed behavior of
> > memory management quite a bit which should be fine.
> > But while tracking down a performance regression I was on the wrong path
> > for a while suspecting this patch is causing the regression.
> > Fortunately this was not the case, but I got some interesting data which
> > I couldn't explain completely and I thought maybe its worth to get it
> > clarified publicly in case someone else looks at similar data again :-)
> >
> > All is about the increased amount of "Buffers" accounted as active while
> > loosing the same portion from "Cache" accounted as inactive in
> > /proc/meminfo.
> > I understand that with the patch applied there will be some more
> > pressure to file pages until the balance of active/inactive file pages
> > is reached.
> > But I didn't get how this prefers buffers compared to cache pages (I
> > assume dropping inactive before active was the case all the time so that
> > can't be the only difference between buffers/cache).
> 
> Well, "Buffers" is the same kind of memory as "Cached", with
> the only difference being that "Cached" is associated with
> files, while "Buffers" is associated with a block device.
> 
> This means that "Buffers" is more likely to contain filesystem
> metadata, while "Cached" is more likely to contain file data.
> 
> Not putting pressure on the active file list if there are a
> large number of inactive file pages means that pages which were
> accessed more than once get protected more from pages that were
> only accessed once.
> 
> My guess is that "Buffers" is larger because the VM now caches
> more (frequently used) filesystem metadata, at the expense of
> caching less (used once) file data.
> 
> > The scenario I'm running is a low memory system (256M total), that does
> > sequential I/O with parallel iozone processes.
> 
> This indeed sounds like the kind of workload that would only
> access the file data very infrequently, while accessing the
> filesystem metadata all the time.
> 
> > But I can't really see in the code where buffers are favored in
> > comparison to cached pages - (it very probably makes sense to do so, as
> > they might contain e.g. the inode data about the files in cache).
> 
> You are right that the code does not favor Buffers or Cache
> over the other, but treats both kinds of pages the same.
> 
> I believe that you are just seeing the effect of code that
> better protects the frequently accessed metadata from the
> infrequently accessed data.

I try to explain the same thing as another word. if active list have
lots unimportant pages, the patch makes to gurard unimportant pages.
it might makes stream I/O benchmark score a bit because such workload
doesn't have the pages theat should be protected. iow, it only reduce
memory for cache.

The patch's intention is to improve real workload (i.e. stream/random I/O mixed workload).
not improve benchmark score. So, I'm interest how much decrease your
benchmark score.






