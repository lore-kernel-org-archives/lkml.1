Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0CLJ6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:58:33 -0500
Received: from trinity.develer.com ([83.149.158.210]:38757 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab0CLJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:58:30 -0500
Date: Fri, 12 Mar 2010 10:58:26 +0100
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
Message-ID: <20100312095826.GA4438@linux>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
 <20100311180753.GE29246@redhat.com>
 <20100311235922.GA4569@linux>
 <20100312090326.ad07c05c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312090326.ad07c05c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:03:26AM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 12 Mar 2010 00:59:22 +0100
> Andrea Righi <arighi@develer.com> wrote:
> 
> > On Thu, Mar 11, 2010 at 01:07:53PM -0500, Vivek Goyal wrote:
> > > On Wed, Mar 10, 2010 at 12:00:31AM +0100, Andrea Righi wrote:
> 
> > mmmh.. strange, on my side I get something as expected:
> > 
> > <root cgroup>
> > $ dd if=/dev/zero of=test bs=1M count=500
> > 500+0 records in
> > 500+0 records out
> > 524288000 bytes (524 MB) copied, 6.28377 s, 83.4 MB/s
> > 
> > <child cgroup with 100M memory.limit_in_bytes>
> > $ dd if=/dev/zero of=test bs=1M count=500
> > 500+0 records in
> > 500+0 records out
> > 524288000 bytes (524 MB) copied, 11.8884 s, 44.1 MB/s
> > 
> > Did you change the global /proc/sys/vm/dirty_* or memcg dirty
> > parameters?
> > 
> what happens when bs=4k count=1000000 under 100M ? no changes ?

OK, I confirm the results found by Vivek. Repeating the tests 10 times:

        root cgroup  ~= 34.05 MB/s average
 child cgroup (100M) ~= 38.80 MB/s average

So, actually the child cgroup with the 100M limit seems to perform
better in terms of throughput.

IIUC, with the large write and the 100M memory limit it happens that
direct write-out is enforced more frequently and a single write chunk is
enough to meet the bdi_thresh or the global background_thresh +
dirty_thresh limits. This means the task is never (or less) throttled
with io_schedule_timeout() in the balance_dirty_pages() loop. And the
child cgroup gets better performance over the root cgroup.

-Andrea
