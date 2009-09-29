Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbZI2K02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbZI2K02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZI2K01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:26:27 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:49009 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbZI2K00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:26:26 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Scott James Remnant <scott@ubuntu.com>
Subject: Re: 2.3.31++: Badness at kernel/softirq.c:143 due to new session leader connector
Date: Tue, 29 Sep 2009 12:26:28 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Oleg Nesterov <oleg@tv-sign.ru>
References: <200909251123.03482.borntraeger@de.ibm.com>
In-Reply-To: <200909251123.03482.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291226.28548.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, since the problem does still exist.


Am Freitag 25 September 2009 11:23:03 schrieb Christian Borntraeger:
> Scott,
> 
> I am using the proc connector for fork and exit tracking. With the latest
>  git the new session leader connector(commit
>  02b51df1b07b4e9ca823c89284e704cadb323cd1 proc connector: add event for
>  process becoming session leader)
> causes the following warning:
> 
> ------------[ cut here ]------------
> Badness at kernel/softirq.c:143
> Modules linked in: tun bridge stp kvm sclp_cpi dm_multipath scsi_dh sunrpc
>  ipv6 qeth_l2 binfmt_misc dm_mod qeth ccwgroup
> CPU: 7 Not tainted 2.6.31-selfgit-08936-g851b147-dirty #130
> Process xzd (pid: 7189, task: 000000013d804758, ksp: 00000001329eddb8)
> Krnl PSW : 0404c00180000000 00000000001481d4 (local_bh_enable+0xb0/0xe0)
>            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000fcdd68 0000000100000000
>  00000001329ee000 00000000008268a8 0000000132980bb4 0000000000000000
>  0000000132980ac8 0000000000000001 0000000132980ac8 0000000100000000
>  000000013db3a470 0000000132980ac8 0000000000525de8 000000000048a946
>  00000001329edc58 Krnl Code: 00000000001481c6: e33002f00004       lg     
>  %r3,752
>            00000000001481cc: a7f4ffd8           brc     15,14817c
>            00000000001481d0: a7f40001           brc     15,1481d2
> 
>           >00000000001481d4: a7280001           lhi     %r2,1
> 
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
> 
> Any ideas for a proper fix?
> 
> 
> Christian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
