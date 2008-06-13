Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYFMRPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYFMRPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYFMRPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:15:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYFMRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:15:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:mime-version:content-type:message-id:cc:
	content-transfer-encoding:from:subject:date:to:x-mailer;
	b=T8VtZKAnxXP9wNrtigAkLk2nN6lbI/rcCjFaGw2lkqYHJThnT0QCTjiDnIYFdZ/MM
	h7crN0hrNg51GmObA5l/w==
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <73DD0C9F-9A95-4636-A412-95E04ADED820@google.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Divyesh Shah <dpshah@google.com>
Subject: [BUGFIX][RESEND] Fix the starving writes bug in the anticipatory IO scheduler
Date: Fri, 13 Jun 2008 10:14:12 -0700
To: axboe@kernel.dk, nickpiggin@yahoo.com.au, akpm@linux-foundation.org
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry again for the resend, the previous mail got bounced off lkml]

Bug description:
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
====

  block/as-iosched.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 8c39467..d4c9f9c 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -831,6 +831,8 @@ static void as_completed_request(struct  
request_queue *q, struct request *rq)
         }

         if (ad->changed_batch && ad->nr_dispatched == 1) {
+                ad->current_batch_expires = jiffies +
+                        ad->batch_expire[ad->batch_data_dir];
                 kblockd_schedule_work(&ad->antic_work);
                 ad->changed_batch = 0;

--

-Divyesh Shah





