Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXIUEV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXIUEV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 00:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbXIUEVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 00:21:51 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45003 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXIUEVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 00:21:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Remove broken netfilter binary sysctls from bridging code
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070921020554.GE31759@nineveh.local>
Date: Thu, 20 Sep 2007 22:21:25 -0600
In-Reply-To: <20070921020554.GE31759@nineveh.local> (Joseph Fannin's message
	of "Thu, 20 Sep 2007 22:05:54 -0400")
Message-ID: <m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jfannin@gmail.com (Joseph Fannin) writes:

> The netfilter sysctls in the bridging code don't set strategy routines:
>
>  sysctl table check failed: /net/bridge/bridge-nf-call-arptables .3.10.1 Missing
> strategy
>  sysctl table check failed: /net/bridge/bridge-nf-call-iptables .3.10.2 Missing
> strategy
>  sysctl table check failed: /net/bridge/bridge-nf-call-ip6tables .3.10.3 Missing
> strategy
>  sysctl table check failed: /net/bridge/bridge-nf-filter-vlan-tagged .3.10.4
> Missing strategy
>  sysctl table check failed: /net/bridge/bridge-nf-filter-pppoe-tagged .3.10.5
> Missing strategy
>
>     These binary sysctls can't work. The binary sysctl numbers of
> other netfilter sysctls with this problem are being removed.  These
> need to go as well.
>
> Signed-off-by: Joseph Fannin <jfannin@gmail.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>
>    This *really* needs to be reviewed by someone who knows what this
>    is all about.  I've simply extended the removal of netfilter binary
>    sysctl numbers so I could load bridge.ko.  I don't particularly
>    care if I get attributed for this fix or any of that.
>
>    It Works For Me.

Hmm.  This is an interesting case.  The proc method is forcing
the integer to be either 0 or 1 in a racy fashion.  But none of the
users appear to depend upon that.

So this is the least broken set of binary sysctls I have seen caught
by my check.

A really good fix would be to remove the binary side and then to
modify brnf_sysctl_call_tables to allocate a temporary ctl_table and
integer on the stack and only set ctl->data after we have normalized
the written value.  But since in practice nothing cares about
the race a better fix probably isn't worth it.

Eric
