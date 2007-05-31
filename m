Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbXEaW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbXEaW7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXEaW7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:59:25 -0400
Received: from mxfep01.bredband.com ([195.54.107.70]:46127 "EHLO
	mxfep01.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXEaW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:59:24 -0400
Subject: Re: [BUG] Something goes wrong with timer statistics.
From: Ian Kumlien <iank@bredband.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070531152709.GA18775@atjola.homenet>
References: <1180474738.22497.25.camel@pi.pomac.com>
	 <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
	 <1180478288.20546.39.camel@chaos> <20070530113825.GA5203@atjola.homenet>
	 <20070530144449.36811a4d.dada1@cosmosbay.com>
	 <20070530131458.GA5432@atjola.homenet>
	 <20070531102047.GG19272@pomac.netswarm.net>
	 <20070531142522.GA16690@atjola.homenet>
	 <20070531171007.5780e5e6.dada1@cosmosbay.com>
	 <20070531152709.GA18775@atjola.homenet>
Content-Type: text/plain; charset=utf-8
Date: Fri, 01 Jun 2007 00:59:11 +0200
Message-Id: <1180652361.30698.11.camel@pi.pomac.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On tor, 2007-05-31 at 17:27 +0200, Björn Steinbrink wrote:
> On 2007.05.31 17:10:07 +0200, Eric Dumazet wrote:
> > Well... :) , there is still a memory barrier missing it seems.
> > 
> > Another cpu might see a bad value if 'active=1' is set before tstat_hash_table is really cleared.
> 
> Hm, that even makes the assumption in my first try valid ;-)
> Just for the record, this time I thought that the barrier from the
> spinlock in timer_stats_update_stats (right before the check for active)
> would be enough, but that's obviously running on the wrong cpu if we
> race... *sigh*
> 
> Thanks,
> Björn
> 
> 
> 
> Fix two races in the timer stats lookup code. One by ensuring that the
> initialization of a new entry is finished upon insertion of that entry.
> The other by cleaning up the hash table when the entries array is
> cleared, so that we don't have "pre-inserted" entries.
> 
> Thanks to Eric Dumazet for reminding me of the memory barriers.

Fix the comment below and you can add:
Signed-off-by: Ian Kumlien <pomac@vapor.com>

It's currently been running for the longest period ever, ie, 11 minutes
=)

I'm gonna leave it running during the night and send a status update
when the evil daystar reaches it's peak CET. (i haven't been able to
stop since linus mentioned it... damn it... =))

> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> ---

> @@ -360,6 +364,7 @@ static ssize_t tstats_write(struct file *file, const char __user *buf,
>  		if (!active) {
>  			reset_entries();
>  			time_start = ktime_get();
> +			smb_mb();

smb? you mean smp =)

>  			active = 1;
>  		}
>  		break;

-- 
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net
