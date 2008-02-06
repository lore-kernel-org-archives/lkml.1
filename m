Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYBFP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYBFP6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYBFP6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:58:07 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:33315 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751808AbYBFP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:58:05 -0500
X-YMail-OSG: yayoLW8VM1nhcn7RqN7BC0WUUNZ4P31eMIi39AIs7ENJJ1MpMEtuv9_.pWQF6IL7WzNqwfo5lg--
X-RocketYMMF: rancidfat
Date: Wed, 6 Feb 2008 07:58:00 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [bisected] Re: [bug] networking broke, ssh: connect to port 22: Protocol error
To: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20080206133506.GA21202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <657224.72762.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > yeah, although various other upstream breakages prevented real long 
> > randconfig series in the past 2-3 days. I'd say it's either in this 
> > pull from your tree:
> 
> ok, i have bisected it down but the result made no sense, so i 
> double-checked it and noticed that the .config mutated during the test.
> 
> the diff below is the diff between the 'good' and 'bad' .config, with 
> this notable detail:
> 
>  @@ -2336,7 +2350,7 @@ CONFIG_SECURITY_NETWORK=y
>   CONFIG_SECURITY_CAPABILITIES=y
>   # CONFIG_SECURITY_FILE_CAPABILITIES is not set
>   # CONFIG_SECURITY_ROOTPLUG is not set
>  -# CONFIG_SECURITY_SMACK is not set
>  +CONFIG_SECURITY_SMACK=y
>   CONFIG_XOR_BLOCKS=m
>   CONFIG_ASYNC_CORE=m
>   CONFIG_ASYNC_MEMCPY=m
> 
> so i disabled CONFIG_SECURITY_SMACK, and viola, just 2 hours of hard 
> work later networking works on my testbox again :-/
> 
> And we have this 1 day old commit:
> 
>   commit e114e473771c848c3cfec05f0123e70f1cdbdc99
>   Author: Casey Schaufler <casey@schaufler-ca.com>
>   Date:   Mon Feb 4 22:29:50 2008 -0800
> 
>       Smack: Simplified Mandatory Access Control Kernel
> 
> that adds SMACK.
> 
> So unlike some other security modules like SELINUX, enabling SMACK 
> breaks un-aware userspace and breaks TCP networking?
> 
> I dont think that's expected behavior - and i'd definitely like to 
> enable SMACK in automated tests to check for regressions, etc.

As Stephen mentions later, Smack uses CIPSO. sshd does not like
any IP options because of traceroute, and must be built with that
check disabled with the current Smack version. I have been looking
at using unlabeled packets for the "ambient" label, it appears that
doing so would make life simpler. I will get right on it.

Application behavior in the presence of IP options isn't
always what I think it ought to be.


Casey Schaufler
casey@schaufler-ca.com
