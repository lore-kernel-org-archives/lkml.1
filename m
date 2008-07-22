Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYGVXTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYGVXTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYGVXRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:57443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYGVXRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:45 -0400
Date: Tue, 22 Jul 2008 16:14:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 05/47] block: Fix the starving writes bug in the
	anticipatory IO scheduler
Message-ID: <20080722231431.GF8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="block-fix-the-starving-writes-bug-in-the-anticipatory-io-scheduler.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Divyesh Shah <dpshah@google.com>

commit d585d0b9d73ed999cc7b8cf3cac4a5b01abb544e upstream

AS scheduler alternates between issuing read and write batches. It does
the batch switch only after all requests from the previous batch are
completed.

When switching to a write batch, if there is an on-going read request,
it waits for its completion and indicates its intention of switching by
setting ad->changed_batch and the new direction but does not update the
batch_expire_time for the new write batch which it does in the case of
no previous pending requests.
On completion of the read request, it sees that we were waiting for the
switch and schedules work for kblockd right away and resets the
ad->changed_data flag.
Now when kblockd enters dispatch_request where it is expected to pick
up a write request, it in turn ends the write batch because the
batch_expire_timer was not updated and shows the expire timestamp for
the previous batch.

This results in the write starvation for all the cases where there is
the intention for switching to a write batch, but there is a previous
in-flight read request and the batch gets reverted to a read_batch
right away.

This also holds true in the reverse case (switching from a write batch
to a read batch with an in-flight write request).

I've checked that this bug exists on 2.6.11, 2.6.18, 2.6.24 and
linux-2.6-block git HEAD. I've tested the fix on x86 platforms with
SCSI drives where the driver asks for the next request while a current
request is in-flight.

This patch is based off linux-2.6-block git HEAD.

Bug reproduction:
A simple scenario which reproduces this bug is:
- dd if=/dev/hda3 of=/dev/null &
- lilo
   The lilo takes forever to complete.

This can also be reproduced fairly easily with the earlier dd and
another test
program doing msync().

The example test program below should print out a message after every
iteration
but it simply hangs forever. With this bugfix it makes forward progress.

====
Example test program using msync() (thanks to suleiman AT google DOT
com)

inline uint64_t
rdtsc(void)
{
         int64_t tsc;

         __asm __volatile("rdtsc" : "=A" (tsc));
         return (tsc);
}

int
main(int argc, char **argv)
{
         struct stat st;
         uint64_t e, s, t;
         char *p, q;
         long i;
         int fd;

         if (argc < 2) {
                 printf("Usage: %s <file>\n", argv[0]);
                 return (1);
         }

         if ((fd = open(argv[1], O_RDWR | O_NOATIME)) < 0)
                 err(1, "open");

         if (fstat(fd, &st) < 0)
                 err(1, "fstat");

         p = mmap(NULL, st.st_size, PROT_READ | PROT_WRITE,
MAP_SHARED, fd, 0);

         t = 0;
         for (i = 0; i < 1000; i++) {
                 *p = 0;
                 msync(p, 4096, MS_SYNC);
                 s = rdtsc();
                *p = 0;
                 __asm __volatile(""::: "memory");
                 e = rdtsc();
                 if (argc > 2)
                         printf("%d: %lld cycles %jd %jd\n",
                                i, e - s, (intmax_t)s, (intmax_t)e);
                 t += e - s;
         }
         printf("average time: %lld cycles\n", t / 1000);
         return (0);
}

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/as-iosched.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -831,6 +831,8 @@ static void as_completed_request(struct 
 	}
 
 	if (ad->changed_batch && ad->nr_dispatched == 1) {
+		ad->current_batch_expires = jiffies +
+					ad->batch_expire[ad->batch_data_dir];
 		kblockd_schedule_work(&ad->antic_work);
 		ad->changed_batch = 0;
 

-- 
