Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXJBCAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXJBCAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 22:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXJBCAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 22:00:46 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36874 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750715AbXJBCAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 22:00:45 -0400
Message-ID: <391290444.23950@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 2 Oct 2007 10:00:40 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Chakri n <chakriin5@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>, akpm@linux-foundation.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       richard kennedy <richard@rsk.demon.co.uk>
Subject: [PATCH] writeback: avoid possible balance_dirty_pages() lockup on
	a light-load bdi
Message-ID: <20071002020040.GA5275@mail.ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <391063897.19256@ustc.edu.cn> <470118EE.1020103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470118EE.1020103@redhat.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 11:57:34AM -0400, Chuck Ebbert wrote:
> On 09/29/2007 07:04 AM, Fengguang Wu wrote:
> > On Thu, Sep 27, 2007 at 11:32:36PM -0700, Chakri n wrote:
> >> Hi,
> >>
> >> In my testing, a unresponsive file system can hang all I/O in the system.
> >> This is not seen in 2.4.
> >>
> >> I started 20 threads doing I/O on a NFS share. They are just doing 4K
> >> writes in a loop.
> >>
> >> Now I stop NFS server hosting the NFS share and start a
> >> "dd" process to write a file on local EXT3 file system.
> >>
> >> # dd if=/dev/zero of=/tmp/x count=1000
> >>
> >> This process never progresses.
> > 
> > Peter, do you think this patch will help?
> > 
> > ===
> > writeback: avoid possible balance_dirty_pages() lockup on light-load bdi
[...] 
> This looks better than the other candidate to fix the problem. Are we going
> to fix 2.6.23 before release? Multiple people have reported this problem now...

(expecting real world confirmations...)

Here is a new safer version.  It's more ugly though.

---
writeback: avoid possible balance_dirty_pages() lockup on a light-load bdi

On a busy-writing system, a writer could be hold up infinitely on a
light-load device. It will be trying to sync more than available dirty data.

The problem case:

0. sda/nr_dirty >= dirty_limit;
   sdb/nr_dirty == 0
1. dd writes 32 pages on sdb
2. balance_dirty_pages() blocks dd, and tries to write 6MB.
3. it never gets there: there's only 128KB dirty data.
4. dd may be blocked for a loooong time

Fix it by returning on 'zero dirty inodes' in the current bdi.
(In fact there are slight differences between 'dirty inodes' and 'dirty pages'.
But there is no available counters for 'dirty pages'.)

But the newly introduced 'break' could make the nr_writeback drift away
above the dirty limit. The workaround is to limit the error under 1MB.

Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/page-writeback.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.22.orig/mm/page-writeback.c
+++ linux-2.6.22/mm/page-writeback.c
@@ -250,6 +250,11 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+			if (list_empty(&mapping->host->i_sb->s_dirty) &&
+			    list_empty(&mapping->host->i_sb->s_io) &&
+			    nr_reclaimable + global_page_state(NR_WRITEBACK) <=
+				    dirty_thresh + (1 << (20-PAGE_CACHE_SHIFT)))
+				break;
 		}
 		congestion_wait(WRITE, HZ/10);
 	}

