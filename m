Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXHVGrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXHVGrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXHVGri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:47:38 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:43558 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXHVGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:47:37 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 02:47:37 EDT
Subject: huge improvement with per-device dirty throttling
From: "Jeffrey W. Baker" <jwbaker@acm.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain
Date: Tue, 21 Aug 2007 23:37:18 -0700
Message-Id: <1187764638.6869.17.camel@hannibal>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tested 2.6.23-rc2-mm + Peter's per-BDI v9 patches, versus 2.6.20 as
shipped in Ubuntu 7.04.  I realize there is a large delta between these
two kernels.

I load the system with du -hs /bigtree, where bigtree has millions of
files, and dd if=/dev/zero of=bigfile bs=1048576.  I test how long it
takes to ls /*, how long it takes to launch gnome-terminal, and how long
it takes to launch firefox.

2.6.23-rc2-mm-bdi is better than 2.6.20 by a factor between 50x and
100x.

1.

sleep 60 && time ls -l /var /home /usr /lib /etc /boot /root /tmp

2.6.20: 53s, 57s
2.6.23: .652s, .870s, .819s

improvement: ~70x

2.

sleep 60 && time gnome-terminal

2.6.20: 1m50s, 1m50s
2.6.23: 3s, 2s, 2s

improvement: ~40x

3.

sleep 60 && time firefox

2.6.20: >30m
2.6.23: 30s, 32s, 37s

improvement: +inf

Yes, you read that correctly.  In the presence of a sustained writer and
a competing reader, it takes more than 30 minutes to start firefox.

4.

du -hs /bigtree

Under 2.6.20, lstat64 has a mean latency of 75ms in the presence of a
sustained writer.  Under 2.6.23-rc2-mm+bdi, the mean latency of lstat64
is only 5ms (15x improvement).  The worst case latency I observed was
more than 2.9 seconds for a single lstat64 call.

Here's the stem plot of lstat64 latency under 2.6.20

  The decimal point is 1 digit(s) to the left of the |

   0 | 00000000000000000000000000000000000000000000000000000000000000000000+1737
   2 | 177891223344556788899999
   4 | 00000111122333333444444555555556666666666667777777777777788888888888+69
   6 | 00000111222334557778999344677788899
   8 | 0123484589
  10 | 020045
  12 | 1448239
  14 | 1
  16 | 5
  18 | 399
  20 | 32
  22 | 80
  24 | 
  26 | 2
  28 | 1

Here's the same plot for 2.6.23-rc2-mm+bdi.  Note the scale

  The decimal point is 1 digit(s) to the left of the |

   0 | 00000000000000000000000000000000000000000000000000000000000000000000+2243
   1 | 1222255677788999999
   2 | 0011122257
   3 | 237
   4 | 3
   5 | 
   6 | 
   7 | 3
   8 | 45
   9 | 
  10 | 
  11 | 
  12 | 
  13 | 9

In other words, under 2.6.20, only writing processes make progress.
Readers never make progress.

5.

dd writeout speed

2.6.20: 36.3MB/s, 35.3MB/s, 33.9MB/s
2.6.23: 20.9MB/s, 22.2MB/s

2.6.23 is slower when writing out, because other processes make progress

My system is a Core 2 Duo, 2GB, single SATA disk.

-jwb

