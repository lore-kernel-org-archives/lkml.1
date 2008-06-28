Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYF1NL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYF1NL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYF1NLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:11:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:56584 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYF1NLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LfO0OhsfGO4AYjNSWFCU75etfePHYKSQokyCDWEFqDrqiKKwf+j7gQq4GrQjnsYERe
         ZfCl3QuSy60v3OWziqIuS/OJ2ASUlggdpu/PHbSNEyfm3ThCXsKhrt2uLtQMGtJ/VOTB
         aB4XusrDIwhOzSviI3eW57YCbfzOmtvVqINSs=
Message-ID: <48663873.5010200@gmail.com>
Date: Sat, 28 Jun 2008 08:11:15 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Lucina <mato@kotelna.sk>
CC: linux-kernel@vger.kernel.org, Martin Sustrik <sustrik@fastmq.com>
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk>
In-Reply-To: <20080628121131.GA14181@nodbug.moloch.sk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Lucina wrote:
> Hi,
> 
> we're getting some rather high figures for write(2) latency when testing
> synchronous writing to disk.  The test I'm running writes 2000 blocks of
> contiguous data to a raw device, using O_DIRECT and various block sizes
> down to a minimum of 512 bytes.  
> 
> The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
> using ata_piix.  Write caching has been explicitly disabled on the
> drive, and there is no other activity that should affect the test
> results (all system filesystems are on a separate drive).  The system is
> running Debian etch, with a 2.6.24 kernel.
> 
> Observed results:
> 
> size=1024, N=2000, took=4.450788 s, thput=3 mb/s seekc=1
> write: avg=8.388851 max=24.998846 min=8.335624 ms
> 8 ms: 1992 cases
> 9 ms: 2 cases
> 10 ms: 1 cases
> 14 ms: 1 cases
> 16 ms: 3 cases
> 24 ms: 1 cases
> 
> size=512, N=2000, took=4.401289 s, thput=1 mb/s seekc=1
> write: avg=8.364283 max=16.692206 min=2.010072 ms
> 2 ms: 1 cases
> 7 ms: 1 cases
> 8 ms: 1995 cases
> 16 ms: 3 cases
> 
> Measurement of the write(2) time is performed using the TSC, so any
> latency there is negligible.
> 
> The datasheet for the drive being used gives the following figures:
> 
> Average latency (msec): 4.16
> Track-to-track seek time (msec typical): <1.2 (write)
> Average seek, write (msec typical): 9.5
> 
> If these figures are to be believed, then why are we seeing latencies of
> 8.3 msec?  Is this normal?  Or are we just being overly optimistic in
> our performance expectations?

Consider this, 60/7200rpm=8.3ms for one rotation.

You write sector n and n+1, it takes some amount of time for that first set of 
sectors to come under the head, when it does you write it and immediately 
return.   Immediately after that you attempt write sector n+2 and n+3 which just 
a bit ago passed under the head, so you have to wait an *ENTIRE* revolution for 
those sectors to again come under the head to be written, another ~8.3ms, and 
you continue to repeat this with each block being written.   If the sector was 
randomly placed in the rotation (ie 50% chance of the disk being off by 1/2 a 
rotation or less-you would have a 4.15 ms average seek time for your test)-but 
the case of sequential sync writes this leaves the sector about as far as 
possible from the head (it just passed under the head).

> 
> What we find suspicious is that the latency we see is so close to the
> Average seek latency specified for the drive, almost as if the drive was
> performing a seek on every write.
> 
> For comparison, here are the results of the same test with the disk
> write cache *enabled*:
> 
> size=1024, N=2000, took=0.296284 s, thput=55 mb/s seekc=1
> write: avg=0.147745 max=0.606990 min=0.117246 ms
> 0 ms: 2000 cases
> 
> size=512, N=2000, took=0.304614 s, thput=26 mb/s seekc=1
> write: avg=0.152089 max=0.533234 min=0.125370 ms
> 0 ms: 2000 cases

Write cache allows a return without writing to the actual disk, so you don't 
have to wait, and on top of that it queues up all of the writes that are 
together on the track and does them at one pass of the head over all of the sectors.

> 
> We also ran the same test on a different system with recent SAS disks
> connected via a HP/Compaq CCISS controller.  I don't have the exact
> details of the drives used, since I don't know how to get them out of
> the cciss driver, but the latencies we got were around 4 msec.  Whilst
> this is better than the "commodity" hardware used in the tests above, it
> still seems excessive.

Almost the same case as for the 7200 rpm disk, but I bet these SAS drives are 
15k drives?   If so 60/15000=4ms.

> 
> Any advice would be appreciated.
> 
> Thanks,
> 

                        Roger
