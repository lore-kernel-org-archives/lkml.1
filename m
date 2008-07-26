Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYGZDls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYGZDls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 23:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYGZDlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 23:41:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37783 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYGZDli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 23:41:38 -0400
Date: Fri, 25 Jul 2008 20:41:27 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
Subject: Re: s390 hugetlb oops with libhugetlbfs test-suite
Message-ID: <20080726034127.GA8338@us.ibm.com>
References: <20080725211035.GA19738@us.ibm.com> <20080726033254.GA3810@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726033254.GA3810@us.ibm.com>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.07.2008 [20:32:54 -0700], Nishanth Aravamudan wrote:
> On 25.07.2008 [14:10:35 -0700], Nishanth Aravamudan wrote:
> > Hi Gerald,
> > 
> > Having noticed that the hugetlbfs code recently got an update to work
> > on s390, I decided to port the libhugetlbfs test-suite to work on
> > s390. The current development snapshot is available at
> > http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20080724.tar.gz.
> > You will need a patch [1] to build on s390, but it should roughly work
> > otherwise.  The specific testcase that causes the oops is counters.
> > The bit set in the flags is PG_Reserved, I think.
> 
> After enabling some debugging options, I got a slightly more precise
> stack trace. The last one I posted was for the 32-bit counters test and
> this one is for the 64-bit one, but appears to be the same problem
> (PG_reserved still being set).
> 
> Bad page state in process 'counters'
> page:000003e040000000 flags:0x0000000000000400 mapping:0000000000000000 mapcount:0 count:0
> Trying to fix it up, but a reboot is needed
> Backtrace:
> CPU: 1 Tainted: G        W 2.6.26-autokern1 #1

Odd, this is the same kernel as last time, which wasn't tainted. The reason for
the taint is the following:

------------[ cut here ]------------
Badness at drivers/s390/cio/qdio_main.c:1361
Modules linked in: zfcp(+) scsi_transport_fc scsi_mod vmur qeth qdio ccwgroup dm_mod dasd_fba_mod dasd_eckd_mod dasd_mod ext3 jbd
CPU: 2 Not tainted 2.6.26-autokern1 #1
Process modprobe (pid: 1812, task: 000000003855e300, ksp: 00000000375ffb10)
Krnl PSW : 0704100180000000 000003e0000f8cce (qdio_allocate+0x25a/0x354 [qdio])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 00000000381c1048 00000000381c1048 00000000381c1048 0000000000000000
           0000000036efb000 0000000000000000 000003e00069662a 0000000000000001
           00000000370c2140 00000000370c2c60 0000000036efb000 00000000375ff920
           000003e0000f5000 000003e0000fbf68 000003e0000f8ca8 00000000375ff920
Krnl Code: 000003e0000f8cc2: a7110fff		tmll	%r1,4095
           000003e0000f8cc6: a7840004		brc	8,3e0000f8cce
           000003e0000f8cca: a7f40001		brc	15,3e0000f8ccc
          >000003e0000f8cce: e3a0c0200004	lg	%r10,32(%r12)
           000003e0000f8cd4: e320a0000004	lg	%r2,0(%r10)
           000003e0000f8cda: b9020022		ltgr	%r2,%r2
           000003e0000f8cde: a784003f		brc	8,3e0000f8d5c
           000003e0000f8ce2: bf1f2018		icm	%r1,15,24(%r2)
Call Trace:
([<000003e0000f8ca8>] qdio_allocate+0x234/0x354 [qdio])
 [<000003e00068b5a2>] zfcp_qdio_allocate+0x106/0x120 [zfcp]
 [<000003e000686dbe>] zfcp_adapter_enqueue+0x62/0x4a4 [zfcp]
 [<000003e0006872b4>] zfcp_ccw_probe+0x40/0x8c [zfcp]
 [<00000000001af398>] ccw_device_probe+0x4c/0x70
 [<0000000000190eba>] driver_probe_device+0x102/0x1ac
 [<0000000000190fc8>] __driver_attach+0x64/0x98
 [<000000000019032a>] bus_for_each_dev+0x62/0xa0
 [<0000000000190c7a>] driver_attach+0x32/0x44
 [<000000000019091c>] bus_add_driver+0xdc/0x26c
 [<00000000001913aa>] driver_register+0xba/0x16c
 [<00000000001b0c2a>] ccw_driver_register+0x42/0x54
 [<000003e00000f4bc>] zfcp_ccw_register+0x24/0x38 [zfcp]
 [<000003e00000f140>] zfcp_module_init+0x140/0x498 [zfcp]
 [<0000000000067a24>] sys_init_module+0x1b40/0x1cb8
 [<000000000002498a>] sysc_noemu+0x10/0x16
 [<0000020000125eb2>] 0x20000125eb2
Last Breaking-Event-Address:
 [<0000000000000000>] 0x0

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
