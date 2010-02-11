Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0BKEJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 23:09:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0BKEJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 23:09:27 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jan Kara <jack@suse.cz>
Subject: Re: CFQ slower than NOOP with pgbench
Date: Thu, 11 Feb 2010 09:40:33 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
       jmoyer@redhat.com
References: <20100210223255.GC3367@quack.suse.cz>
In-Reply-To: <20100210223255.GC3367@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002110940.33303.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010 04:02:55 Jan Kara wrote:
>   Hi,
> 
>   I was playing with a pgbench benchmark - it runs a series of operations
> on top of PostgreSQL database. I was using:
>   pgbench -c 8 -t 2000 pgbench
> which runs 8 threads and each thread does 2000 transactions over the
> database. The funny thing is that the benchmark does ~70 tps (transactions
> per second) with CFQ and ~90 tps with a NOOP io scheduler. This is with
> 2.6.32 kernel.
>   The load on the IO subsystem basically looks like lots of random reads
> interleaved with occasional short synchronous sequential writes (the
> database does write immediately followed by fdatasync) to the database
> logs. I was pondering for quite some time why CFQ is slower and I've tried
> tuning it in various ways without success. What I found is that with NOOP
> scheduler, the fdatasync is like 20-times faster on average than with CFQ.
> Looking at the block traces (available on request) this is usually because
> when fdatasync is called, it takes time before the timeslice of the process
> doing the sync comes (other processes are using their timeslices for reads)
> and writes are dispatched... The question is: Can we do something about
> that? Because I'm currently out of ideas except for hacks like "run this
> queue immediately if it's fsync" or such...

I guess, noop would be hurting those reads which is also a synchronous 
operation like fsync. But it doesn't seem to have a huge negative impact on 
the pgbench. Is it because reads are random in this benchmark and delaying 
them might even help by getting new requests for sectors in between two random 
reads? If that is the case, I dont think fsync should be given higher priority 
than reads based on this benchmark.

Can you make the blktrace available?

Thanks
Nikanth
