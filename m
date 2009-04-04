Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbZDDJda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbZDDJda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZDDJdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:33:17 -0400
Received: from stinky.trash.net ([213.144.137.162]:41404 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbZDDJdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:33:16 -0400
Message-ID: <49D72953.9080804@trash.net>
Date: Sat, 04 Apr 2009 11:33:07 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: keyoor.khristi@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Issue with netlink implementation
References: <6b4fbcea0904030921j1b627d3ar37af13a0788706b4@mail.gmail.com>	<6b4fbcea0904031424j4b1f5526ydd1d21307e511273@mail.gmail.com> <20090403.220616.176801869.davem@davemloft.net>
In-Reply-To: <20090403.220616.176801869.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Keyoor Khristi <keyoor.khristi@gmail.com>
>> We are facing an issue with netlink implementation. We are sending the
>> data from user space to kernel space. a kernel thread gets the data
>> from netlink socket (via skb_recv_datagram). After doing little bit
>> processing we give the skb to driver. driver sends the data and frees
>> the skb. Sometimes we observe that the writer thread in userspace gets
>> stuck writing a packet and doesnt come out. We traced the problem to
>> netlink_attachskb. When a packet is sent on the netlink socket
>> netlink_attachskb is called to add the skb to the queue. when there is
>> not enough space, the thread is added to nlk->wait queue and issues
>> schedule_timeout. it doesnt come out of it as no other thread awakens
>> it. It seems when the driver frees the skb, the data is freed and the
>> receive space is made available in the destructor but the thread
>> waiting is not awaken. This is causing the problem we're seeing.
>> I think the netlink implementation in af_netlink.c can be enhanced. In
>> netlink_attachskb, after invoking skb_set_owner_r we should change the
>> skb->destructor to point to newly added function netlink_rfree. When
>> skb is freed, netlink_rfree function can issue sock_rfree and awaken
>> the threads waiting on nlk->wait queue.

This sounds like you're not using netlink_kernel_create() to create
your netlink socket. Messages from userspace to the kernel are processed
synchronously, your process should never end up on the wait queue if
you've set up the netlink socket in the kernel properly:

int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
		    u32 pid, int nonblock)
{
	struct sock *sk;
	int err;
	long timeo;

	skb = netlink_trim(skb, gfp_any());

	timeo = sock_sndtimeo(ssk, nonblock);
retry:
	sk = netlink_getsockbypid(ssk, pid);
	if (IS_ERR(sk)) {
		kfree_skb(skb);
		return PTR_ERR(sk);
	}
	if (netlink_is_kernel(sk))
		return netlink_unicast_kernel(sk, skb);
...

 >> a kernel thread gets the data from netlink socket (via 
skb_recv_datagram)

You need to either use netlink kernel sockets or go through
recvmsg().
