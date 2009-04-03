Return-Path: <linux-kernel-owner+w=401wt.eu-S935433AbZDCVZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935433AbZDCVZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZDCVYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:24:51 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:1932 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZDCVYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=v/HzaU6cFv6eikQ/+C4+44oXXC5qW+j2Pzjd3u4gCwSXh0T6klDebPIxvPZmAe5bC4
         qjOpbnNQlpwfttsDlemcRMvAP6MMwMC4OIem2aFQyNepjUgZrDKQ7PnPyHuggoAZ1eoo
         iOTI7xxGrAUWCDyKMLZ4K1VU0r8rVVqAl9PfU=
MIME-Version: 1.0
In-Reply-To: <6b4fbcea0904030921j1b627d3ar37af13a0788706b4@mail.gmail.com>
References: <6b4fbcea0904030921j1b627d3ar37af13a0788706b4@mail.gmail.com>
Date: Sat, 4 Apr 2009 02:54:48 +0530
Message-ID: <6b4fbcea0904031424j4b1f5526ydd1d21307e511273@mail.gmail.com>
Subject: Issue with netlink implementation
From: Keyoor Khristi <keyoor.khristi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We are facing an issue with netlink implementation. We are sending the
data from user space to kernel space. a kernel thread gets the data
from netlink socket (via skb_recv_datagram). After doing little bit
processing we give the skb to driver. driver sends the data and frees
the skb. Sometimes we observe that the writer thread in userspace gets
stuck writing a packet and doesnt come out. We traced the problem to
netlink_attachskb. When a packet is sent on the netlink socket
netlink_attachskb is called to add the skb to the queue. when there is
not enough space, the thread is added to nlk->wait queue and issues
schedule_timeout. it doesnt come out of it as no other thread awakens
it. It seems when the driver frees the skb, the data is freed and the
receive space is made available in the destructor but the thread
waiting is not awaken. This is causing the problem we're seeing.
I think the netlink implementation in af_netlink.c can be enhanced. In
netlink_attachskb, after invoking skb_set_owner_r we should change the
skb->destructor to point to newly added function netlink_rfree. When
skb is freed, netlink_rfree function can issue sock_rfree and awaken
the threads waiting on nlk->wait queue.

Please let me know what you think about it.
I'm not sure if i've sent the email to correct forum. If i should be
sending to another forum, please tell me.

Regards,
K
