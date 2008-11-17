Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYKQTjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYKQTjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKQTji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:39:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44601
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbYKQTjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:39:37 -0500
Date: Mon, 17 Nov 2008 11:39:36 -0800 (PST)
Message-Id: <20081117.113936.81699150.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117184951.GA5585@elte.hu>
References: <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org>
	<20081117182320.GA26844@elte.hu>
	<20081117184951.GA5585@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 19:49:51 +0100

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> 4> The place for the sock_rfree() hit looks a bit weird, and i'll 
> > investigate it now a bit more to place the real overhead point 
> > properly. (i already mapped the test-bit overhead: that comes from 
> > napi_disable_pending())
> 
> ok, here's a new set of profiles. (again for tbench 64-thread on a 
> 16-way box, with v2.6.28-rc5-19-ge14c8bf and with the kernel config i 
> posted before.)

Again, do a non-NMI profile and the top (at least for me)
looks like this:

samples  %        app name                 symbol name
473       6.3928  vmlinux                  finish_task_switch
349       4.7169  vmlinux                  tcp_v4_rcv
327       4.4195  vmlinux                  U3copy_from_user
322       4.3519  vmlinux                  tl0_linux32
178       2.4057  vmlinux                  tcp_ack
170       2.2976  vmlinux                  tcp_sendmsg
167       2.2571  vmlinux                  U3copy_to_user

That tcp_v4_rcv() hit is %98 on the wake_up() call it does.
