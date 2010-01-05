Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329Ab0AET63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0AET63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708Ab0AET61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:58:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab0AET60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:58:26 -0500
Date: Tue, 5 Jan 2010 20:58:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Roland McGrath <roland@redhat.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
	results on s390x)
Message-ID: <20100105195818.GA20358@redhat.com>
References: <1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20100104155225.GA16650@redhat.com> <20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com> <20100104181412.GA21146@redhat.com> <20100104211147.4CC94D532@magilla.sf.frob.com> <20100105105030.66bb8a0a@mschwide.boeblingen.de.ibm.com> <20100105153633.GA9376@redhat.com> <20100105164610.388effd3@mschwide.boeblingen.de.ibm.com> <20100105155913.GA10652@redhat.com> <20100105170301.GA13641@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100105170301.GA13641@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05, Oleg Nesterov wrote:
>
> On 01/05, Oleg Nesterov wrote:
> >
> > I'll add clear_bit(TIF_SINGLE_STEP) into do_fork() path and re-test.
>
> Hmm. This patch
>
> 	--- kernel/fork.c~	2009-12-22 10:41:53.188084961 -0500
> 	+++ kernel/fork.c	2010-01-05 11:42:58.370636323 -0500
> 	@@ -1206,6 +1206,8 @@ static struct task_struct *copy_process(
> 		 * of CLONE_PTRACE.
> 		 */
> 		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACE);
> 	+	clear_tsk_thread_flag(p, TIF_SINGLE_STEP);
> 	+	user_disable_single_step(p);
> 	 #ifdef TIF_SYSCALL_EMU
> 		clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);
> 	 #endif
>
> doesn't help, I still see the same XXX's in dmesg...

Oh, now I am totally confused.

I reverted your fix from
https://www.redhat.com/archives/utrace-devel/2010-January/msg00006.html
and now there is nothing in dmesg.


I decided to re-test this all with vanilla 2.6.33-rc2. It is really
amazing how long it takes to recompile/install the kernel! I spent
the rest of this day fighting with this rhts machine. Result - it
doesn't boot:

	00: zIPL v1.8.2-5.el6 interactive boot menu
	00:
	00:  0. default (2.6.33-rc2)
	00:
	00:  1. 2.6.33-rc2
	00:  2. 2.6.32.2-14.s390x.el6.s390x
	00:  3. 2.6.32.2-14.el6.s390x
	00:  4. linux
	00:
	00: Note: VM users please use '#cp vi vmsg <input>'
	00:
	00: Please choose (default will boot in 15 seconds):
	00: Booting default (2.6.33-rc2)...
	 Ý<000000000011c4fc>¨ sysc_return+0x0/0x8
	 Ý<00000000003cc0c6>¨ selinux_sb_copy_data+0x17e/0x238
	(Ý<00000000003cbf94>¨ selinux_sb_copy_data+0x4c/0x238)
	 Ý<00000000003b62a6>¨ security_sb_copy_data+0x4e/0x60
	 Ý<0000000000280338>¨ vfs_kern_mount+0x19c/0x1f4
	 Ý<00000000002803de>¨ kern_mount_data+0x4e/0x5c
	 Ý<0000000000ae1908>¨ devtmpfs_init+0x60/0xbc
	 Ý<0000000000ae1818>¨ driver_init+0x28/0x6c
	 Ý<0000000000abe582>¨ kernel_init+0x32a/0x3d8
	 Ý<000000000010b8c2>¨ kernel_thread_starter+0x6/0xc
	 Ý<000000000010b8bc>¨ kernel_thread_starter+0x0/0xc
	INFO: lockdep is turned off.
	00: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 00114BD4
	00:
	00:
	00:
	00:
	00:
	00:

Cai, any chance you can help? Using /usr/bin/console I can't choose another
kernel at the "00: Please choose (default will boot in 15 seconds):" stage,
how can I do this???

Oleg.

