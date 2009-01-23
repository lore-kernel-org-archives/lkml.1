Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZAWOJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZAWOJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZAWOJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:09:42 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13018 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbZAWOJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:09:41 -0500
X-IronPort-AV: E=Sophos;i="4.37,312,1231131600"; 
   d="scan'208";a="36918171"
Subject: Re: [Xen-devel] [PATCH] xen: actually release memory when
	shrinking domain
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>
In-Reply-To: <4978F4D8.6090706@goop.org>
References: <4978F4D8.6090706@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 23 Jan 2009 14:09:08 +0000
Message-Id: <1232719748.27712.19.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2009 14:09:40.0275 (UTC) FILETIME=[3B5A6030:01C97D64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 14:36 -0800, Jeremy Fitzhardinge wrote:
> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> Fix this:
> 
> > It appears that in the upstream balloon driver,
> > > the call to HYPERVISOR_update_va_mapping is missing
> > > from decrease_reservation.  I think as a result,
> > > the balloon driver is eating memory but not
> > > releasing it to Xen, thus rendering the balloon
> > > driver essentially useless.  (Can be observed via xentop.)

Fails on 32 bit with HighMem pages:
        
        kernel BUG at /local/scratch/ianc/devel/kernels/paravirt/drivers/xen/balloon.c:298!
        invalid opcode: 0000 [#1] SMP 
        last sysfs file: /sys/devices/system/xen_memory/xen_memory0/info/current_kb
        Modules linked in:
        
        Pid: 9, comm: events/0 Tainted: G        W  (2.6.29-rc1-x86_32p-xen0-tip #726)         
        EIP: 0061:[<c0266c57>] EFLAGS: 00010282 CPU: 0
        EIP is at balloon_process+0x527/0x530
        EAX: ffffffea EBX: deadbeef ECX: deadbeef EDX: deadbeef
        ESI: deadbeef EDI: c1000000 EBP: 00000000 ESP: f64b5f44
         DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
        Process events/0 (pid: 9, ti=f64b4000 task=f642d830 task.ti=f64b4000)
        Stack:
         00000000 ffffa0c0 0000002e 00000192 0000019d 00000000 00000400 f6427a00
         00000000 00000000 00000000 00000000 00007ff0 c04afcb0 f6427a00 c04afcac
         c0266730 c0143cf1 c0106bc2 f6427a0c c0107810 f642020c f6427a04 f6427a0c
        Call Trace:
         [<c0266730>] balloon_process+0x0/0x530
         [<c0143cf1>] run_workqueue+0x91/0x140
         [<c0106bc2>] check_events+0x8/0x16
         [<c0107810>] xen_spin_unlock+0x0/0x50
         [<c01473e0>] autoremove_wake_function+0x0/0x50
         [<c0144718>] worker_thread+0x98/0xf0
         [<c01473e0>] autoremove_wake_function+0x0/0x50
         [<c0144680>] worker_thread+0x0/0xf0
         [<c01470c2>] kthread+0x42/0x70
         [<c0147080>] kthread+0x0/0x70
         [<c010a5f3>] kernel_thread_helper+0x7/0x10
        Code: 00 00 00 00 e8 9b a1 f0 ff 31 f6 e8 e4 2f eb ff b8 e0 7b 54 c0 e8 1a 90 16 00 8b 6c 24 18 89 44 24 14 89 74 24 10 e9 eb fe ff ff <0f> 0b eb fe 90 8d 74 26 00 83 ec 04 b8 20 fc 4a c0 e8 13 dc ff 
        EIP: [<c0266c57>] balloon_process+0x527/0x530 SS:ESP 0069:f64b5f44
        ---[ end trace 4eaa2a86a8e2da28 ]---

diff -r b64a63f076cd drivers/xen/balloon.c
--- a/drivers/xen/balloon.c	Fri Jan 23 13:29:48 2009 +0000
+++ b/drivers/xen/balloon.c	Fri Jan 23 14:09:08 2009 +0000
@@ -292,10 +292,13 @@
 
 		scrub_page(page);
 
-		ret = HYPERVISOR_update_va_mapping(
-			(unsigned long)__va(pfn << PAGE_SHIFT),
-			__pte_ma(0), 0);
-		BUG_ON(ret);
+		if (!PageHighMem(page)) {
+			ret = HYPERVISOR_update_va_mapping(
+				(unsigned long)__va(pfn << PAGE_SHIFT),
+				__pte_ma(0), 0);
+			BUG_ON(ret);
+                }
+
 	}
 
 	/* Ensure that ballooned highmem pages don't have kmaps. */


