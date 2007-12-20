Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXLTUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXLTUBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbXLTUBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:01:03 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:61827 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbXLTUBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:01:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VDrBAtBpovzpJyAAG3/TaMTbkJlVtBm1FUf6hg7hzTMvUgY48xmEds1a9qpsRwv4Fct48gSDuai8CMWBC+3PGv8jnxCYW77RYV2QtCC05o65cy5iyiSo386dDgMQkLL5lCnWfrZySTBCu2Ff8YhCPXAr5cpDCI+5OrHUYDcauG0=
Message-ID: <82e4877d0712201200h7b994175u841d1efa047cefff@mail.gmail.com>
Date: Thu, 20 Dec 2007 15:00:59 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] sky2: Use deferrable timer for watchdog
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <476AC105.9090206@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712182008160.3616@mini.warudkars.net>
	 <20071220091603.0d69b045@deepthought>
	 <823114761-1198171803-cardhu_decombobulator_blackberry.rim.net-937108990-@bxe019.bisx.prod.on.blackberry>
	 <20071220095121.7859c023@deepthought> <476ABDDF.8080607@intel.com>
	 <476ABE7D.60901@linux.intel.com> <476AC105.9090206@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 2:22 PM, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> ok, that's just bad and if there's no user-defineable limit to the deferral I
> definately don't like this change.
>
> Can I safely assume that any irq will cause all deferred timers to run?

I think even other causes for wakeup like process related ones will
cause the CPU to go busy and run the timers.
This, coupled with the fact that no one is yet able to reach 0 wakeups
per second makes it pretty unlikely that deferrable timers will be
deferred indefinitely.

>
> If this is the case then for e1000 this patch is still OK since the watchdog needs
> to run (1) after a link up/down interrupt or (2) to update statistics. Those
> statistics won't increase if there is no traffic of course...
>

I think it is reasonable for Network driver watchdogs to use a
deferrable timer - if the machine is 100% IDLE there is no one needing
the network to be up. If there is something running even on the other
CPU - that is going to cause an IPI, reschedule, TLB invalidation etc.
which will make it very likely in practice that each CPU will be
interrupted in reasonable amount of time.

Of course there are theoretical cases where we could land into a
situation where a CPU in a multiprocessor machine is IDLE infinitely
and that causes the watchdog that happens to be bound to run on the
same CPU to not run. To take care of these unlikely cases I think the
timer mechanism should have a reasonable limit on how long a CPU can
go IDLE if there are deferrable timers.

Parag
