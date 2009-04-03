Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbZDCWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbZDCWxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZDCWxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:53:36 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:58614 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZDCWxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aWPuy6croqmt1jWavix4wOoCgtWhP1LJ5EKWxP++f7GErpGAub6l4Yc1QCG9EaapRz
         1bGM2g8c4jx1FBojUD43EkqzLKVnRfS9poMWijcPhnjl+81GvVO377mtGjfczmvwwYCi
         xNL33dHog/Hh+2cHBIRb1jUbQQvIpU1CXSJaE=
MIME-Version: 1.0
In-Reply-To: <49D68631.4030706@garzik.org>
References: <20090326182519.d576d703.akpm@linux-foundation.org> 
	<20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> 
	<alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> 
	<20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> 
	<49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> 
	<49D68631.4030706@garzik.org>
Date: Fri, 3 Apr 2009 15:53:18 -0700
Message-ID: <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Janne Grunau <j@jannau.net>, Mark Lord <lkml@rtr.ca>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 2:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Just curious, does MythTV need fsync(), or merely to tell the kernel to
> begin asynchronously writing data to storage?
>
> sync_file_range(..., SYNC_FILE_RANGE_WRITE) might be enough, if you do not
> need to actually wait for completion.
>
> This may be the case, if the idea behind MythTV's fsync(2) is simply to
> prevent the kernel from building up a huge amount of dirty pages in the
> pagecache [which, in turn, produces bursty write-out behavior].

The *only* reason MythTV fsyncs (or fdatasyncs) the data to disk all
the time is to keep a large amount of dirty pages from building up and
then causing horrible latencies when that data starts getting flushed
to disk.

A typical example of this would be that MythTV is recording a show in
the background while playing back another show.

When the dirty limit is hit and data gets flushed to disk, this would
keep the read buffer on the player from happening fast enough and then
playback would stutter.

Instead of telling people ext3 sucks - mount it in writeback or use
xfs or tweak your vm knobs, they simply put a hack in there instead
which largely eliminates the effect.

I don't think many people would care too much if they lost 30-60
seconds of their recorded TV show if the system crashes for whatever
reason.

-Dave
