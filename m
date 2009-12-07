Return-Path: <linux-kernel-owner+w=401wt.eu-S964855AbZLGXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbZLGXh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935309AbZLGXhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:37:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40478 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935193AbZLGXhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:37:53 -0500
Message-ID: <4B1D91C8.7040900@us.ibm.com>
Date: Mon, 07 Dec 2009 15:37:44 -0800
From: Vernon Mauery <vernux@us.ibm.com>
Reply-To: vernux@us.ibm.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>
Subject: [RT] Silent hang on -rt kernel using tc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing a silent hang on -rt kernels that is getting provoked
when using tc (traffic control) to enforce bandwidth limiting on
a network interface.  I set up the rate-limiting using HTB (or CBQ)
and then send traffic out on the interface and the machine hangs.

When the machine hangs, it is nearly completely unresponsive, with
sysrq sometimes working, but I can crash it with an NMI.  Sometimes
the machine will also spit out messages from the SCSI or SAN or
NIC drivers that are getting timeouts because of the hang.

Here is how I have been able to cause the hang:

#!/bin/bash

if [ -z "$1" ]; then
        ETH=eth2
else
        ETH="$1"
fi

SPEED=`ethtool $ETH | grep Speed | sed 's/[^0-9]*\([0-9]*\).*/\1/'`
case $SPEED in
   10000) ZEROS=00 ;;
    1000) ZEROS=0 ;;
 default) ZEROS='' ;;
esac

tc qdisc del dev $ETH root >&/dev/null || :
tc qdisc add dev $ETH root handle 1: htb default 30 r2q 600$ZEROS
tc class add dev $ETH parent 1: classid 1:1 htb rate 30${ZEROS}mbit
tc class add dev $ETH parent 1:1 classid 1:10 htb rate 5${ZEROS}mbit prio 1
tc class add dev $ETH parent 1:1 classid 1:20 htb rate 5${ZEROS}mbit prio 2
tc class add dev $ETH parent 1:1 classid 1:30 htb rate 8${ZEROS}mbit

-------

Run netserver on another machine that is connected to the desired interface.
Then run:

netperf -l 2000 -H $IP -t UDP_STREAM -- -m 65505

Wait a bit and the machine should hang.

I can only reproduce on 8-way systems; smaller systems don't hang for me.  I
see the hang within seconds of running netperf after running the tc commands.

I can reproduce it on any of my available network interfaces 1GbE or 10GbE.
It usually takes a little bit longer on the 1GbE interface, but it still
will hang.  It seems to hang faster if I am running `top -d .2` in another
shell on that machine which produces a fair amount of network traffic
and CPU utilization.

I can reproduce it on 2.6.24-rt and on 2.6.31-rt, but not on 2.6.32 vanilla.

Often when it hangs, the machine will only respond to an NMI, though on
occasion, I have been able to use sysrq over the SOL line.

Once, I did see the machine give an oops when running this scenario, but
it is much much more common to see a silent hang.  Here is the oops message:

Unable to handle kernel NULL pointer dereference at 0000000000000010 RIP:
 [<ffffffff8113b38c>] rb_erase+0x1f3/0x2b1
PGD 14e150067 PUD 142d34067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 2
Modules linked in: sch_htb pktgen nfs nfsd lockd nfs_acl auth_rpcgss exportfs
ipmi_devintf ipmi_si ipmi_msghandler ibm_rtl ipv6 autofs4 i2c_dev i2c_core hidp
rfcomm l2cap bluetooth sunrpc dm_mirror dm_multipath scsi_dh dm_mod video
output sbs sbshc battery ac parport_pc lp parport sg bnx2 button netxen_nic
serio_raw amd64_edac edac_core pcspkr shpchp mptsas mptscsih mptbase
scsi_transport_sas sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 38, comm: sirq-hrtimer/2 Not tainted 2.6.24-rt #1
RIP: 0010:[<ffffffff8113b38c>]  [<ffffffff8113b38c>] rb_erase+0x1f3/0x2b1
RSP: 0018:ffff81014f16fe50  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff81014640bac8 RCX: ffff810001085780
RDX: 0000000000000000 RSI: ffff8100010076a8 RDI: 0000000000000000
RBP: ffff81014f16fe60 R08: ffff81033f15dac8 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8100010076a8
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000080
FS:  00007ff9960016e0(0000) GS:ffff81014fc09cc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 000000014e188000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sirq-hrtimer/2 (pid: 38, threadinfo ffff81014f16e000, task
ffff81014f16c300)
Stack:  ffff81013a5e67d0 ffff810001007698 ffff81014f16fe90 ffffffff81054dfc
 ffffffff81227401 ffff81013a5e67d0 ffff810001085640 0000000000000002
 ffff81014f16fec0 ffffffff81055cbb 0000000000000002 ffffffff815005e8
Call Trace:
 [<ffffffff81054dfc>] __remove_hrtimer+0x6e/0x7b
 [<ffffffff81227401>] ? qdisc_watchdog+0x0/0x23
 [<ffffffff81055cbb>] run_hrtimer_softirq+0x7a/0x14e
 [<ffffffff81043d26>] ksoftirqd+0x16a/0x26f
 [<ffffffff81043bbc>] ? ksoftirqd+0x0/0x26f
 [<ffffffff81043bbc>] ? ksoftirqd+0x0/0x26f
 [<ffffffff8105261c>] kthread+0x49/0x79
 [<ffffffff8100d088>] child_rip+0xa/0x12
 [<ffffffff810525d3>] ? kthread+0x0/0x79
 [<ffffffff8100d07e>] ? child_rip+0x0/0x12


Code: e8 d2 fb ff ff e9 8b 00 00 00 48 8b 07 a8 01 75 1a 48 83 c8 01 4c 89 e6
48 89 07 48 83 23 fe 48 89 df e8 10 fc ff ff 48 8b 7b 10 <48> 8b 57 10 48 85 d2
74 05 f6 02 01 74 2c 48 8b 47 08 48 85 c0
RIP  [<ffffffff8113b38c>] rb_erase+0x1f3/0x2b1
 RSP <ffff81014f16fe50>


Any help in debugging this would be greatly appreciated.

--Vernon
