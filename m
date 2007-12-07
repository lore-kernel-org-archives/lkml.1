Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbXLGRy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbXLGRy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXLGRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:51:49 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:65175 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002AbXLGRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:51:48 -0500
Subject: Major regression on hackbench with SLUB
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 12:50:46 -0500
Message-Id: <1197049846.1645.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been doing some benchmarks for RT task migrations and I stumbled
over this regression. I first thought it was a regression with CFS and
started doing a git bisect. But I later found that the "good" kernel
also failed. Then I started looking at the config options and discovered
that SLUB has become the default.

When I put SLAB back, the regression went away, even on the lastest git
tree.

So I ran the hackbench benchmarks with the latest git commit
(f194d132e4971111f85c18c96067acffb13cee6d at the time of this writing).
And put up the results on my web page.

http://people.redhat.com/srostedt/slab/

I ran Ingo's cfs-debug-info.sh and have the results of that on the web
page. That script records lots of good information to see what kind of
machine I ran this on. This is a 64way box (yes lots of CPUS!).

The hackbench code and the script I used to run and record the results
is also present. I ran "hackbench 90" 20 times, 10 times as SCHED_OTHER
and 10 times as SCHED_FIFO (chrt -f 10 hackbench 90).  The graph shows
both runs (min, max and average). The versions that start with
"rt:" (although the graph somehow truncated it to just "t:") are the
SCHED_FIFO runs. (click on the graph to see a bigger version)

The regression is that hackbench slows down tremendously. It goes from
running just under 2 seconds to running around 14 seconds.

Hackbench seems to show this regression the most. In my tests I didn't
see much change with kernel builds and such, but the focus was on
scheduling not memory management. I'll run my kernel tests next for both
SLAB and SLUB and see if there's any difference there.

But this regression might be a reason to not have SLUB as default for
now. At least until we find out why this is affected so badly.

-- Steve


