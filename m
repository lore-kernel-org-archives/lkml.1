Return-Path: <linux-kernel-owner+w=401wt.eu-S1030698AbXCHV46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030698AbXCHV46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030714AbXCHV46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:56:58 -0500
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:50940 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030698AbXCHV44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:56:56 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.21-rc3: /proc broken
Date: Fri, 9 Mar 2007 08:56:44 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703090152.49253.kernel@kolivas.org>
In-Reply-To: <200703090152.49253.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703090856.45386.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 01:52, Con Kolivas wrote:
> On Thursday 08 March 2007 15:19, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/
> >2. 6.21-rc3-mm2/
> >
> > - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
> >   were dropped.

> So on qemu I can reproduce the oops you're getting with your config (make
> oldconfig all default on top of your config), but I'm getting other
> wonderful related problems too on rc3-mm2. On qemu -mm1 boots mostly
> without error and then crashes nicely when I type 'ps' with a long pause
> for about twenty seconds and then a combination of soft lockups, bitmap
> errors, and eventually hits the BUG_ON I put in bitmap_error(). However,
> -mm2 also vomits on typing 'ps'.
>
> It pauses and then spits out (fun lines selected from ps output):
>
>     7 ?        serial8250: too much work for irq4
> 00:00:00 watchdog/1
>    88 ?        00:00:0serial8250: too much work for irq4
> 0 cqueue/1
>   137 ?        00:00serial8250: too much work for irq4
>
> :00 aio/0
>
> Checking a few /proc files I see that "serial83250" info littered
> throughout /proc/stat as well. -mm2 does not oops but the proc output is
> variously corrupted.
>
> Interestingly if I don't type 'ps' in the -mm1 qemu it runs fine with no
> sign of a bug... In summary, here I can only reproduce your big fat oops by
> it being triggered by some corruption elsewhere on this config related to
> /proc breakage that I haven't managed to track down. I checked the
> broken-out patches to see which touched /proc and it was oh, most of them.
> I tried on rc3 and had the same thing happen. I haven't tried rc3 without
> rsdl (your config takes too darn long to build!).

/proc appears broken on vanilla -rc3 as well.

I did make oldconfig from http://userweb.kernel.org/~akpm/ck/config.txt and 
chose all the defaults. Then building your fat config with -rc3, 'ps' hangs 
on qemu for almost 30 seconds and then at last produces a broken output

  PID TTY          TIME CMD
    1 ?        00:00:00 init
    2 ?        00:00:00 migration/0
    3 ?        00:00:00 ksoftirqd/0
    4 ?        00:00:00 watchdog/0
    5 ?        00:00:00 migration/1
    6 ?        00:00:00 ksoftirqd/1
    7 ?        serial8250: too much work for irq4
00:00:00 watchdog/1
    8 ?        00:00:00 events/0
    9 ?        00:00:00 events/1
   10 ?        00:00:00 khelper
   11 ?        00:00:00 kthread
   52 ?        00:00:00 kblockd/0
   53 ?        00:00:00 kblockd/1
   54 ?        00:00:00 kacpid
   87 ?        00:00:00 cqueue/0
   88 ?        00:00:00 cqueue/1
   89 ?        00:00:00 ata/0
   90 ?        00:00:00 ata/1
   91 ?        00:00:00 ata_aux
   92 ?        00:00:00 ksuspend_usbd
   95 ?        00:00:00 khubd
   97 ?        00:00:00 kseriod
  133 ?        00:00:00 pdflush
  134 ?        00:00:00 pdflush
  135 ?        00:00:00 kserial8250: too much work for irq4
swapd0
  136 ?        00:00:00 aio/0
  137 ?        00:00:00 aio/1
  287 ?        00:00:00 kpsmoused
  311 ?        00:00:00 sh
  312 ?        00:00:00 ps

It's random where this happens too. Sometimes it goes away, other times it's 
different tasks, and it happens to /proc/stat too

-- 
-ck
