Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZHING3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZHING3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 09:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZHING1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 09:06:27 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:16551 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367AbZHING0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 09:06:26 -0400
X-Trace: 243785024/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.93.38/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.93.38
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAB9mfkpQKV0m/2dsb2JhbACBUso2hBgF
X-IronPort-AV: E=Sophos;i="4.43,349,1246834800"; 
   d="scan'208";a="243785024"
Date: Sun, 9 Aug 2009 14:06:05 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
In-Reply-To: <Pine.LNX.4.64.0908091209150.23855@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908091346450.27358@sister.anvils>
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
 <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils>
 <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009, Hugh Dickins wrote:
> 
> filp 13343 objects:
> 
> CPU last cur F M
>   0    1   0 0 0
>   1    0   0 0 0
>   2   -1   0 0 0
>   3    0   0 0 0
> ggp = 35124, state = waitzero

Interesting that rcu_try_flip_waitzero() doesn't see 1 + 0 + -1 + 0 == 0.

That's because rcu_cpu_online_map is 0x1 instead of the 0xf it should be.

Which is because I don't have CONFIG_HOTPLUG_CPU=y on that PPC machine
(unlike the x86s), and I think you've made some recent mods which
accidentally made the rcu cpu initialization dependent on hotplug
cpu notifiers?  CONFIG_HOTPLUG_CPU=y and it works properly again.

And TREE_RCU doesn't use an rcu_cpu_online_map (though it does expect
some per-cpu initialization, but seems to get away without it).

So I think that's the mystery solved - I'll let you decide the right fix!

Hugh
