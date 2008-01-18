Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYARFmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYARFmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYARFl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:41:56 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44927 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751011AbYARFlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:41:55 -0500
Message-ID: <400634919.20750@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 18 Jan 2008 13:41:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Michael Rubin <mrubin@google.com>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
References: <20080115080921.70E3810653@localhost> <400562938.07583@ustc.edu.cn> <532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com> <20080118050107.GS155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118050107.GS155259@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JFjyv-0001hU-FA@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fairness is a tradeoff between seeks and bandwidth.  Ideally, we
> want to spend 50% of the *disk* time servicing sequential writes and
> 50% of the time servicing seeky writes - that way neither get
> penalised unfairly by the other type of workload.
> 
> Switching inodes during writeback implies a seek to the new write
> location, while continuing to write the same inode has no seek
> penalty because the writeback is sequential.  It follows from this
> that allowing larges file a disproportionate amount of data
> writeback is desirable.
> 
> Also, cycling rapidly through all the large files to write 4MB to each is
> going to cause us to spend time seeking rather than writing compared
> to cycling slower and writing 40MB from each large file at a time.
> 
> i.e. servicing one large file for 100ms is going to result in higher
> writeback throughput than servicing 10 large files for 10ms each
> because there's going to be less seeking and more writing done by
> the disks.
> 
> That is, think of large file writes like process scheduler batch
> jobs - bulk throughput is what matters, so the larger the time slice
> you give them the higher the throughput.
> 
> IMO, the sort of result we should be looking at is a
> writeback design that results in cycling somewhat like:
> 
> 	slice 1: iterate over small files
> 	slice 2: flush large file 1
> 	slice 3: iterate over small files
> 	slice 4: flush large file 2
> 	......
> 	slice n-1: flush large file N
> 	slice n: iterate over small files
> 	slice n+1: flush large file N+1
> 
> So that we keep the disk busy with a relatively fair mix of
> small and large I/Os while both are necessary.

If we can sync fast enough, the lower layer would be able to merge
those 4MB requests. Whatever the slice size is, we end up sending the
same set of pages to disk: the writable pages of expired inodes. We
only have to worry about choosing the right set of pages being written
in one single batch(in every pdflush wakeup time). That set is
currently defined by the 5s/30s dirty expiration rules.

> Furthermore, as disk bandwidth goes up, the relationship
> between large file and small file writes changes if we want
> to maintain writeback at a significant percentage of the
> maximum bandwidth of the drive (which is extremely desirable).
> So if we take a 4k page machine and a 1024page writeback slice,
> for different disks, we get a bandwidth slice in terms of disk
> seeks like:
> 
> slow disk: 20MB/s, 10ms seek (say a laptop drive)
> 	- 4MB write takes 200ms, or equivalent of 10 seeks
> 
> normal disk: 60MB/s, 8ms seek (desktop)
> 	- 4MB write takes 66ms, or equivalent of 8 seeks
> 
> fast disk: 120MB/s, 5ms seek (15krpm SAS)
> 	- 4MB write takes 33ms,  or equivalent of 6 seeks
> 
> small RAID5 lun: 200MB/s, 4ms seek
> 	- 4MB write takes 20ms, or equivalent of 5 seeks
> 
> Large RAID5 lun: 1GB/s, 2ms seek
> 	- 4MB write takes 4ms, or equivalent of 2 seeks
> 
> Put simply:
> 
> 	The higher the bandwidth of the device, the more frequently
> 	we need to be servicing the inodes with large amounts of
> 	dirty data to be written to maintain write throughput at a
> 	significant percentage of the device capability.
> 
> The writeback algorithm needs to take this into account for it
> to be able to scale effectively for high throughput devices.

Slow queues go full first. Currently the writeback code will skip
_and_ congestion_wait() for congested filesystems. The better policy
is to congestion_wait() _after_ all other writable pages have been
synced. The same have been done for blocked inodes/pages in my
patchset.

> BTW, it needs to be recognised that if we are under memory pressure
> we can clean much more memory in a short period of time by writing
> out all the large files first. This would clearly benefit the system
> as a whole as we'd get the most pages available for reclaim as
> possible in a short a time as possible. The writeback algorithm
> should really have a mode that allows this sort of flush ordering to
> occur....

We might do write-behind for large files :-)

