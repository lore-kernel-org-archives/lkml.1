Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbZKYCQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbZKYCQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbZKYCQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:16:15 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40470 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217AbZKYCQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:16:15 -0500
Subject: Re: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20091123090630.GF5602@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain>
	 <20091017223902.GA29439@wotan.suse.de> <1258507696.2077.61.camel@localhost>
	 <20091118042516.GC21813@wotan.suse.de>
	 <1258683764.3840.28.camel@localhost.localdomain>
	 <20091123090630.GF5602@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 24 Nov 2009 18:16:17 -0800
Message-ID: <1259115377.2115.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 10:06 +0100, Nick Piggin wrote:
> BTW. Have you tested like ext4, xfs and btrfs cases?  I don't think ext3
> is likely to see a huge amount of scalability work, and so it will be
> good to give an early heads up to the more active projects...

Yea, I need to give those a shot. I also generated the same numbers as
before with ext2 (all the raw numbers are in dbench-scalability dir):

http://sr71.net/~jstultz/dbench-scalability/graphs/ext2-scalability.png

Again, its similar to ext3, in that all the -rt variants are hitting
some contention issues. But I was a little surprised to see
2.6.32-rc7-nick below 2.6.32-rc7 there, so generated perf data there as
well:

http://sr71.net/~jstultz/dbench-scalability/perflogs/2.6.32-rc7-nick.ext2.perflog


31.91%       dbench  [kernel]                    [k] _spin_lock
                |          
                |--44.17%-- dput
                |          |          
                |          |--50.39%-- __link_path_walk
                |          |          |          
                |          |          |--99.88%-- path_walk
                |          |          |          |          
                |          |          |          |--96.18%-- do_path_lookup
                |          |          |          |          |          
                |          |          |          |          |--51.49%-- user_path_at
                |          |          |          |          |          |          
                |          |          |          |          |          |--96.84%-- vfs_fstatat
                |          |          |          |          |          |          vfs_stat
                |          |          |          |          |          |          sys_newstat
                |          |          |          |          |          |          system_call_fastpath
                |          |          |          |          |          |          _xstat
                |          |          |          |          |          |          
                |          |          |          |          |           --3.16%-- do_utimes
                |          |          |          |          |                     sys_utime
                |          |          |          |          |                     system_call_fastpath
                |          |          |          |          |                     __GI_utime
                |          |          |          |          |          
                |          |          |          |          |--43.18%-- do_filp_open
                |          |          |          |          |          do_sys_open
                |          |          |          |          |          sys_open
                |          |          |          |          |          system_call_fastpath
                |          |          |          |          |          __GI___open
...

		|--39.98%-- path_get
                |          |          
                |          |--51.19%-- path_init
                |          |          |          
                |          |          |--96.40%-- do_path_lookup
                |          |          |          |          
                |          |          |          |--55.12%-- user_path_at
                |          |          |          |          |          
                |          |          |          |          |--91.47%-- vfs_fstatat
                |          |          |          |          |          vfs_stat
                |          |          |          |          |          sys_newstat
                |          |          |          |          |          system_call_fastpath
                |          |          |          |          |          _xstat
                |          |          |          |          |          |          
                |          |          |          |          |           --100.00%-- 0x7478742e746e65
                |          |          |          |          |          


So I'm a little confused here. Why is dput/path_get showing up in ext2
when it all but disappeared with ramfs? Does ramfs have some sort of
vfs_stat shortcut that avoids whatever is catching us here?

thanks
-john

