Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYEKNOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYEKNOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYEKNOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:14:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:53791 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYEKNOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pfvZJszyYvAFf6AhDOvXy5gR1iisMXQF/4VAQWLX5y6Gp2x8LDbnIT0FK1UxQnjFxyZl+TQtlhG2xvopA5jYpXjQeTXOOHCAcN//E5e19PI0oZPYnF7vlHTUjUm5w9u/aUMChIkuHfygBUxVWIrYZnZOUkwDfmQvRwDHsdj4bY4=
Message-ID: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
Date: Sun, 11 May 2008 14:14:06 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: axboe@kernel.dk
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       Matthew <jackdachef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been experiencing this for a while also; an almost 50% regression
is seen for single-process reads (ie sync) if slice_idle is 1ms or
more (eg default of 8) [1], which seems phenomenal.

Jens, is this the expected price to pay for optimal busy-spindle
scheduling, a design issue, bug or am I missing something totally?

Thanks,
  Daniel

--- [1]

# cat /sys/block/sda/queue/iosched/slice_idle
8
# echo 1 >/proc/sys/vm/drop_caches
# dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 4.92922 s, 66.5 MB/s

# echo 0 >/sys/block/sda/queue/iosched/slice_idle
# echo 1 >/proc/sys/vm/drop_caches
# dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 2.74098 s, 120 MB/s

# hdparm -Tt /dev/sda

/dev/sda:
 Timing cached reads:   15464 MB in  2.00 seconds = 7741.05 MB/sec
 Timing buffered disk reads:  342 MB in  3.01 seconds = 113.70 MB/sec

[120MB/s is known platter-rate for this disc, so expected]
-- 
Daniel J Blueman
