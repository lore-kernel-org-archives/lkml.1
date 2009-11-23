Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZKWV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZKWV5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZKWV5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:57:08 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53105 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZKWV5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:57:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gJ6iusKEHJ2HTltpYd0Ea0aUQ0ocRSKlIE1hJQegOLJ/S5WjDETiKwU9DwgZTNy9ZV
         lE952cz4ixnAujubpl63MN7UwdcNbm3iIQHE7Sl/50oBanUd6bPT8yhGszWOVsWSPVEz
         m0UOm3FpsUBqNrdycl68Lm/hm9tYYSzRkRxco=
MIME-Version: 1.0
In-Reply-To: <4B04E8F6.3000004@wpkg.org>
References: <4B046AEA.80109@wpkg.org>
	 <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com>
	 <alpine.DEB.2.00.0911190200370.32644@aurora.sdinet.de>
	 <20091119013810.GO9467@discord.disaster> <4B04E8F6.3000004@wpkg.org>
Date: Mon, 23 Nov 2009 16:57:09 -0500
X-Google-Sender-Auth: d51c1e8519d74deb
Message-ID: <c0c067900911231357u16af88cahce74b755df791146@mail.gmail.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
From: Dan Merillat <dan.merillat@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Norbert Preining <preining@logic.at>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 1:43 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> What is also interesting, that a normal software RAID-1 sync (i.e. from a
> degraded state) does not seem to make any visible effect on system
> responsiveness.
>
> Uncompress a big tar file, or VM writes out lots of data - system becomes
> really unresponsive.

Setup:

XFS -> LV -> md0 (degraded) -> ST3500630AS  ver 3.AA  (500gb)
Basically no other disk activity while doing these tests.

barriers on:
$ time git checkout -f
Checking out files: 100% (29108/29108), done.

real	2m51.913s
user	0m3.128s
sys	0m3.004s
$ time rm -r *

real	1m52.562s
user	0m0.072s
sys	0m2.980s
$ sudo mount /usr/src -o remount,nobarrier
$ time git checkout -f
Checking out files: 100% (29108/29108), done.

real	0m9.782s
user	0m2.944s
sys	0m2.984s
$ time rm -r *

real	0m24.996s
user	0m0.076s
sys	0m2.808s

So XFS + barriers are part of the culprit here, but I was only using
xfs for /usr/src.  Reformatted that to ext4 after I found that little
nugget of joy.   Ext4+barriers isn't anywhere near as dramatic a hit,
it's a much more reasonable speed/safety tradeoff.   Again, that's
only for /usr/src, the rest of my system is using ext4, so it doesn't
explain any other workload problems.  btrfs doesn't seem to have much
of a hit at all using barriers but I'd need to test that properly,
it's below 6 seconds for checkout and the differences would be in the
noise without averaging multiple runs.

On Thu, Nov 19, 2009 at 9:36 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> Hi Dan,
>
> Umm, very strange.
> I made two debug patch. can you please apply it and post following
> command output?
>
> % cat /proc/meminfo
> % cat /proc/vmstat
> % cat /proc/zoneinfo
> # cat /proc/filecache | sort -nr -k3 |head -30

Unfortunately not, it doesn't compile on 2.6.31 which means I'd have
to re-port vmware & fglrx just to test that.

  CC      fs/proc/filecache.o
fs/proc/filecache.c: In function ‘iwin_fill’:
fs/proc/filecache.c:108: error: ‘bdi_lock’ undeclared (first use in
this function)
fs/proc/filecache.c:108: error: (Each undeclared identifier is
reported only once
fs/proc/filecache.c:108: error: for each function it appears in.)
fs/proc/filecache.c:109: error: ‘struct backing_dev_info’ has no
member named ‘bdi_list’
fs/proc/filecache.c:109: warning: type defaults to ‘int’ in
declaration of ‘__mptr’
fs/proc/filecache.c:109: error: ‘bdi_list’ undeclared (first use in
this function)
fs/proc/filecache.c:109: error: ‘struct backing_dev_info’ has no
member named ‘bdi_list’
fs/proc/filecache.c:109: error: ‘struct backing_dev_info’ has no
member named ‘bdi_list’

And I can't forward port the patch without major work, since the whole
bdi_writeback structure was introduced post 2.6.31. The recent-rotated
patch works, I'll include that data as soon as I get the memory
pressure back up.

Right now it's behaving correctly after the reboot - the usual sign of
a problem is free memory going way up while swapping like mad.  I'm
putting a lot of memory pressure on the kernel post-reboot but swap is
behaving normally.   I hope this doesn't take multiple days of uptime
to get back into that state.
