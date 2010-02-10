Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0BJWct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:32:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0BJWcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:32:48 -0500
Date: Wed, 10 Feb 2010 23:32:55 +0100
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jens.axboe@oracle.com, jmoyer@redhat.com
Subject: CFQ slower than NOOP with pgbench
Message-ID: <20100210223255.GC3367@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  I was playing with a pgbench benchmark - it runs a series of operations
on top of PostgreSQL database. I was using:
  pgbench -c 8 -t 2000 pgbench
which runs 8 threads and each thread does 2000 transactions over the
database. The funny thing is that the benchmark does ~70 tps (transactions
per second) with CFQ and ~90 tps with a NOOP io scheduler. This is with
2.6.32 kernel.
  The load on the IO subsystem basically looks like lots of random reads
interleaved with occasional short synchronous sequential writes (the
database does write immediately followed by fdatasync) to the database
logs. I was pondering for quite some time why CFQ is slower and I've tried
tuning it in various ways without success. What I found is that with NOOP
scheduler, the fdatasync is like 20-times faster on average than with CFQ.
Looking at the block traces (available on request) this is usually because
when fdatasync is called, it takes time before the timeslice of the process
doing the sync comes (other processes are using their timeslices for reads)
and writes are dispatched... The question is: Can we do something about
that? Because I'm currently out of ideas except for hacks like "run this
queue immediately if it's fsync" or such...
  The config of the database is attached (it actually influences the
performance and the visibility of the problem noticably). The machine
is just Core 2 Duo with 3.7 GB of memory and a plain SATA drive.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="postgresql.conf"

shared_buffers = 1GB
temp_buffers = 256MB
work_mem = 256MB
maintenance_work_mem = 1GB
effective_io_concurrency = 0
wal_buffers = 1MB
checkpoint_segments = 2048
random_page_cost = 6.0
effective_cache_size = 2GB
synchronous_commit = on
#commit_delay = 1000
#wal_writer_delay = 100
#default_statistics_target = 1000
bgwriter_lru_maxpages = 1000

log_destination = 'stderr'
logging_collector = on
#log_checkpoints = on
#log_connections = on
#log_disconnections = on
#log_lock_waits = on
#log_statement = 'none'
#log_statement_stats=1
#log_planner_stats=1
#log_parser_stats=1
#log_executor_stats=1

--xHFwDpU9dbj6ez1V--
