Return-Path: <linux-kernel-owner+w=401wt.eu-S935173AbXKQBF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173AbXKQBF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 20:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXKQBFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 20:05:15 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45730 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368AbXKQBFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 20:05:13 -0500
Date: Fri, 16 Nov 2007 17:03:52 -0800
From: Micah Dowty <micah@vmware.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071117010352.GA13666@vmware.com>
References: <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com> <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com> <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com> <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu> <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com> <20071116221404.GC31527@vmware.com> <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 12:26:41AM +0100, Dmitry Adamushko wrote:
> Let's say we change a pattern for the niced task: e.g. run for 100 ms.
> and then sleep for 300 ms. (that's ~25% of cpu load) in the loop. Any
> behavioral changes?

For consistency, I tested this using /dev/rtc. I set the rtc frequency
to 16 Hz, and replaced the main loop of my high (-19) priority thread
with:

   while (1) {
      unsigned long data;

      for (i = 0; i < 3; i++) {
         if (read(rtc, &data, sizeof data) != sizeof data) {
            perror("read");
            return 1;
         }
      }

      fcntl(rtc, F_SETFL, O_NONBLOCK);
      while (read(rtc, &data, sizeof data) < 0);
      fcntl(rtc, F_SETFL, 0);
   }

Now it's busy-looping for 62ms, and sleeping for three consecutive
62.5ms chunks totalling 187.5ms.

The results aren't quite what I was expecting. I have only observed
this so far in test cases where I have a very high wakeup frequency,
so I wasn't expecting this to work. I did, however, still observe the
problem where occasionally I get into a state where one CPU is mostly
idle.

Qualitatively, this feels a bit different. With the higher clock
frequency it seemed like the CPU would easily get "stuck" in this
state where it's mostly idle, and it would stay there for a long
time. With the low wakeup frequency, I'm seeing it toggle between the
busy and mostly-idle states more quickly.

I tried a similar test using usleep() and gettimeofday() rather than
/dev/rtc:

   while (1) {
      usleep(300000);

      gettimeofday(&t1, NULL);
      do {
         gettimeofday(&t2, NULL);
      } while (t2.tv_usec - t1.tv_usec +
               (t2.tv_sec - t1.tv_sec) * 1000000 < 100000);
   }

With this test program, I haven't yet seen a CPU imbalance that lasts
longer than a fraction of a second.

--Micah

