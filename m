Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYFPDTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYFPDTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 23:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYFPDTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 23:19:08 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:45815 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751891AbYFPDTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 23:19:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ag1Ec8Omq93ESpyp7n2Y1/TEx75bNMdfNUGzxJcoNIQ8gSmL7TgdhxpUTJYbESHS2bhiII1KCEbPKTlqooowlDXFwC9VppOm3ReVvtvyhpgjwRCSX6/qoKb2bHfvN4wMHOpHDmP7VjqSdaqhgnurJb2WFt8DW0xtkcFmwTZxqag=  ;
X-YMail-OSG: X1W.7oIVM1mXQfwo4pfNQrzeTQmpXFAH7XqphCphA7Az38626mUNK2MY8pnQVUC8orX_wQHSG1Gw6k6XvkAtwiihm7mKtaNHTG3lnV4z0CUpdaMZa4l7eqFosRsKJS_XvQI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Divyesh Shah <dpshah@google.com>
Subject: Re: [BUGFIX][RESEND] Fix the starving writes bug in the anticipatory IO scheduler
Date: Mon, 16 Jun 2008 13:18:56 +1000
User-Agent: KMail/1.9.5
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>
References: <935894B7-5FD4-4C3D-9A74-6B18E532462B@google.com>
In-Reply-To: <935894B7-5FD4-4C3D-9A74-6B18E532462B@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161318.57435.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, thanks for the report and test case. I'm a bit out of the
loop when it comes to IO scheduling these days, however the fix
seems good to me.

Does google still use AS scheduling? This doesn't introduce any
performance regressions that you can tell?

Andrew might be away this week I think. Jens, any chance you can
pick this up and get it merged when you feel it is ready?

Acked-by: Nick Piggin <npiggin@suse.de>

Thanks,
Nick


On Saturday 14 June 2008 03:03, Divyesh Shah wrote:
> [Sorry for the resend, the previous mail got bounced off lkml]
>
> Bug description:
> AS scheduler alternates between issuing read and write batches. It does
> the batch switch only after all requests from the previous batch are
> completed.
>
> When switching to a write batch, if there is an on-going read request,
> it waits for its completion and indicates its intention of switching by
> setting ad->changed_batch and the new direction but does not update the
> batch_expire_time for the new write batch which it does in the case of
> no previous pending requests.
> On completion of the read request, it sees that we were waiting for the
> switch and schedules work for kblockd right away and resets the
> ad->changed_data flag.
> Now when kblockd enters dispatch_request where it is expected to pick
> up a write request, it in turn ends the write batch because the
> batch_expire_timer was not updated and shows the expire timestamp for
> the previous batch.
>
> This results in the write starvation for all the cases where there is
> the intention for switching to a write batch, but there is a previous
> in-flight read request and the batch gets reverted to a read_batch
> right away.
>
> This also holds true in the reverse case (switching from a write batch
> to a read batch with an in-flight write request).
>
> I've checked that this bug exists on 2.6.11, 2.6.18, 2.6.24 and
> linux-2.6-block git HEAD. I've tested the fix on x86 platforms with
> SCSI drives where the driver asks for the next request while a current
> request is in-flight.
>
> This patch is based off linux-2.6-block git HEAD.
>
> Bug reproduction:
> A simple scenario which reproduces this bug is:
> - dd if=/dev/hda3 of=/dev/null &
> - lilo
>    The lilo takes forever to complete.
>
> This can also be reproduced fairly easily with the earlier dd and
> another test
> program doing msync().
>
> The example test program below should print out a message after every
> iteration
> but it simply hangs forever. With this bugfix it makes forward progress.
>
> ====
> Example test program using msync() (thanks to suleiman AT google DOT
> com)
>
> inline uint64_t
> rdtsc(void)
> {
>          int64_t tsc;
>
>          __asm __volatile("rdtsc" : "=A" (tsc));
>          return (tsc);
> }
>
> int
> main(int argc, char **argv)
> {
>          struct stat st;
>          uint64_t e, s, t;
>          char *p, q;
>          long i;
>          int fd;
>
>          if (argc < 2) {
>                  printf("Usage: %s <file>\n", argv[0]);
>                  return (1);
>          }
>
>          if ((fd = open(argv[1], O_RDWR | O_NOATIME)) < 0)
>                  err(1, "open");
>
>          if (fstat(fd, &st) < 0)
>                  err(1, "fstat");
>
>          p = mmap(NULL, st.st_size, PROT_READ | PROT_WRITE,
> MAP_SHARED, fd, 0);
>
>          t = 0;
>          for (i = 0; i < 1000; i++) {
>                  *p = 0;
>                  msync(p, 4096, MS_SYNC);
>                  s = rdtsc();
>                 *p = 0;
>                  __asm __volatile(""::: "memory");
>                  e = rdtsc();
>                  if (argc > 2)
>                          printf("%d: %lld cycles %jd %jd\n",
>                                 i, e - s, (intmax_t)s, (intmax_t)e);
>                  t += e - s;
>          }
>          printf("average time: %lld cycles\n", t / 1000);
>          return (0);
> }
> ====
>
>   block/as-iosched.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/block/as-iosched.c b/block/as-iosched.c
> index 8c39467..d4c9f9c 100644
> --- a/block/as-iosched.c
> +++ b/block/as-iosched.c
> @@ -831,6 +831,8 @@ static void as_completed_request(struct
> request_queue *q, struct request *rq)
>          }
>
>          if (ad->changed_batch && ad->nr_dispatched == 1) {
> +                ad->current_batch_expires = jiffies +
> +                        ad->batch_expire[ad->batch_data_dir];
>                  kblockd_schedule_work(&ad->antic_work);
>                  ad->changed_batch = 0;
>
> --
>
> -Divyesh Shah
