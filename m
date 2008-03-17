Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYCQIAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYCQIAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYCQIAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:00:20 -0400
Received: from sacred.ru ([62.205.161.221]:34080 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYCQIAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:00:19 -0400
Message-ID: <47DE24ED.7060101@openvz.org>
Date: Mon, 17 Mar 2008 10:59:41 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Audit vs netlink interaction problem
References: <47DAA660.90401@openvz.org> <20080314163929.GP20815@postel.suug.ch> <47DAB065.6060804@openvz.org> <20080314182927.GQ20815@postel.suug.ch>
In-Reply-To: <20080314182927.GQ20815@postel.suug.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 10:59:37 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Graf wrote:
> * Pavel Emelyanov <xemul@openvz.org> 2008-03-14 20:05
>> Hmmm... I'm afraid, that this can break the audit filtering and signal
>> auditing. I haven't yet looked deep into it, but it compares the 
>> task->tgid with this audit_pid for different purposes. If audit_pid
>> changes this code will be broken.
> 
> OK, then both pids have to be stored. audit_pid remains as-is but is
> no longer used as destination netlink pid. A second pid is stored and
> updated whenever a netlink message is received from userspace.
> 
>> Bu we have no the netlink socket at the moment of setting the pid to
>> check this. The audit_reveive_msg() call which does this set is received 
>> via another (pre-created global) socket.
> 
> I don't understand this. As far as I can read the code, a plain kernel
> side netlink socket is created in audit_init(). But it doesn't matter,
> as soon as we receive the first message from userspace, we know the
> netlink source pid.

audit_init() creates a kernel-side socket, while we need to know the pid 
of a user-side one. But I saw your patch, seems like the NETLINK_CB(skb).pid
is what we need for this check :)

>> I though, that proper behavior would be to split audit_pid, used for
>> filtering from the audit_nlk_pid used for netlink communications.
> 
> Yes, exactly.
> 

