Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYIZGQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYIZGQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYIZGQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:16:15 -0400
Received: from email1.etri.re.kr ([129.254.16.131]:55552 "EHLO
	email1.etri.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYIZGQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:16:15 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: Re: [PATCH 0/2] Traffic control cgroups subsystem
Date: Fri, 26 Sep 2008 15:16:13 +0900
Message-ID: <4C86297B4AC6554B8BA018F0806590CE017D5B3A@email1>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [PATCH 0/2] Traffic control cgroups subsystem
thread-index: Ackfn2COpxBQoeSvQBGgneaC1WonYg==
From: =?ks_c_5601-1987?B?sejA57+t?= <gauri@etri.re.kr>
To: <linux-kernel@vger.kernel.org>
Cc: "Ranjit Manomohan" <ranjitm@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Incorporated fixes suggested by Li Zefan.
>
>Please consider for net-next-2.6.
>
>This patch provides a simple resource controller (cgroup_tc) based on 
>the cgroups infrastructure to manage network traffic. The cgroup_tc 
>resource controller can be used to schedule and shape traffic belonging 
>to the task(s) in a particular cgroup.
>
>The implementation consists of two parts:
>
>1) A resource controller (cgroup_tc) that is used to associate packets from
>   a particular task belonging to a cgroup with a traffic control class id (
>   tc_classid). This tc_classid is propagated to all sockets created by tasks
>   in the cgroup and will be used for classifying packets at the link layer.
>
>2) A new traffic control classifier (cls_cgroup) that can classify packets
>   based on the tc_classid field in the socket to specific destination classes.
>
>An example of the use of this resource controller would be to limit the 
>traffic from all tasks from a file_server cgroup to 100Mbps. We could 
>achieve this by doing:
>
># make a cgroup of file transfer processes and assign it a arbitrary 
>unique # classid of 0x1234 - this will be used later to direct packets.
>mkdir -p /dev/cgroup
>mount -t cgroup tc -otc /dev/cgroup
>mkdir /dev/cgroup/file_transfer
>echo 0x1234 > /dev/cgroup/file_transfer/tc.classid
>echo $PID_OF_FILE_XFER_PROCESS > /dev/cgroup/file_transfer/tasks
>
># Now create a HTB class that rate limits traffic to 100mbits and 
>attach # a filter to direct all traffic from cgroup file_transfer to this new class.
>tc qdisc add dev eth0 root handle 1: htb tc class add dev eth0 parent 
>1: classid 1:10 htb rate 100mbit ceil 100mbit tc filter add dev eth0 
>parent 1: handle 800 protocol ip prio 1 cgroup value 0x1234 classid 
>1:10
>
>Signed-off-by: Ranjit Manomohan <ranjitm <at> google.com>
>

I installed your patch to kernel-2.6.27-rc7 with some hunkles but without failes.
After compiling the kernel, I run the command which you wrote above. Most of all commands successfully are run except the last command " tc filter add dev eth0 parent 1: handle 800 protocol ip prio 1 cgroup value 0x1234 classid 1:10"

After that, I received this messages
"Unknown filter "cgroup", hence option "value" is unparsable"

So I operated this command with "strace", then below messages returned.
...
socket(PF_NETLINK, SOCK_RAW, 0)         = 3
setsockopt(3, SOL_SOCKET, SO_SNDBUF, [32768], 4) = 0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [32768], 4) = 0 bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0 getsockname(3, {sa_family=AF_NETLINK, pid=5452, groups=00000000}, [12]) = 0
time(NULL)                              = 1222389948
open("/usr/lib/tc/f_cgroup.so", O_RDONLY) = -1 ENOENT (No such file or directory) write(2, "Unknown filter \"cgroup\", hence o"..., 60Unknown filter "cgroup", hence option "value" is unparsable
) = 60
close(3)                                = 0
exit_group(1)                           = ?

This messages told me tc couldn¡¯t find "f_cgroup.so" library in my system.
With this message, I thought that we need a modified "tc" command file to recognize the new filter, cgroup.

And I saw the line in your patch below
">Please consider for net-next-2.6."
What's the meaning of the line?
I wonder if I have to adopt another patch for net-netxt-2.6 before adopting this patch?

You didn't mentioned base kernel for this patch.
I am willing to know the base kernel version and why you didn't mention.

I've worked couple of days for resolving this problem. But I couldn't find the proper answer yet.

I'd really thank you if you help me.


To unsubscribe from this list: send the line "unsubscribe netdev" in the body of a message to majordomo <at> vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

