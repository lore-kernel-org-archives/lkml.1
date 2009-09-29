Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZI2N0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZI2N0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 09:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZI2N0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 09:26:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZI2N0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 09:26:22 -0400
Date: Tue, 29 Sep 2009 15:22:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: 2.3.31++: Badness at kernel/softirq.c:143 due to new session
	leader connector
Message-ID: <20090929132201.GA4538@redhat.com>
References: <200909251123.03482.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909251123.03482.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Christian Borntraeger wrote:
>
> I am using the proc connector for fork and exit tracking. With the latest git 
> the new session leader connector(commit 02b51df1b07b4e9ca823c89284e704cadb323cd1 
> proc connector: add event for process becoming session leader)
> causes the following warning:
>
> ------------[ cut here ]------------
> Badness at kernel/softirq.c:143
> Modules linked in: tun bridge stp kvm sclp_cpi dm_multipath scsi_dh sunrpc ipv6 
> qeth_l2 binfmt_misc dm_mod qeth ccwgroup
> CPU: 7 Not tainted 2.6.31-selfgit-08936-g851b147-dirty #130
> Process xzd (pid: 7189, task: 000000013d804758, ksp: 00000001329eddb8)
> Krnl PSW : 0404c00180000000 00000000001481d4 (local_bh_enable+0xb0/0xe0)
>            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000fcdd68 0000000100000000 00000001329ee000
>            00000000008268a8 0000000132980bb4 0000000000000000 0000000132980ac8
>            0000000000000001 0000000132980ac8 0000000100000000 000000013db3a470
>            0000000132980ac8 0000000000525de8 000000000048a946 00000001329edc58
> Krnl Code: 00000000001481c6: e33002f00004       lg      %r3,752
>            00000000001481cc: a7f4ffd8           brc     15,14817c
>            00000000001481d0: a7f40001           brc     15,1481d2
>           >00000000001481d4: a7280001           lhi     %r2,1
>            00000000001481d8: 50201000           st      %r2,0(%r1)
>            00000000001481dc: a7f4ffd0           brc     15,14817c
>            00000000001481e0: c0e5fffe4b76       brasl   %r14,1118cc
>            00000000001481e6: e33002f00004       lg      %r3,752
> Call Trace:
> ([<000000013fe04100>] 0x13fe04100)
>  [<000000000048a946>] sk_filter+0x9a/0xd0
>  [<000000000049d938>] netlink_broadcast+0x2c0/0x53c
>  [<00000000003ba9ae>] cn_netlink_send+0x272/0x2b0
>  [<00000000003baef0>] proc_sid_connector+0xc4/0xd4
>  [<0000000000142604>] __set_special_pids+0x58/0x90
>  [<0000000000159938>] sys_setsid+0xb4/0xd8
>  [<00000000001187fe>] sysc_noemu+0x10/0x16
>  [<00000041616cb266>] 0x41616cb266
> Last Breaking-Event-Address:
>  [<00000000001481d0>] local_bh_enable+0xac/0xe0
>
>
> The warning is
> --->    WARN_ON_ONCE(in_irq() || irqs_disabled());
>
> I think the problem is, that sys_setsid holds the tasklist_lock with
> spinlock_irq. while calling the connector.

Yes, local_bh_enable() doesn't like irqs_disabled().

> Any ideas for a proper fix?

Please see http://lkml.org/lkml/2009/6/23/690

As for daemonize(), I don't think this case is important. Even if it is,
we can add proc_sid_connector() to daemonize() as well.

Oleg.

