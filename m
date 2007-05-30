Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXE3Mo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXE3Mo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXE3Mov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:44:51 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:58268 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbXE3Mou convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:44:50 -0400
Date: Wed, 30 May 2007 14:44:49 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: =?ISO-8859-1?B?Qmr2cm4=?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ian Kumlien <iank@bredband.net>, Linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-Id: <20070530144449.36811a4d.dada1@cosmosbay.com>
In-Reply-To: <20070530113825.GA5203@atjola.homenet>
References: <1180474738.22497.25.camel@pi.pomac.com>
	<6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
	<1180478288.20546.39.camel@chaos>
	<20070530113825.GA5203@atjola.homenet>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 13:38:25 +0200
Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> On 2007.05.30 00:38:08 +0200, Thomas Gleixner wrote:
> > On Wed, 2007-05-30 at 00:24 +0200, Michal Piotrowski wrote:
> > > Hi Ian,
> > > 
> > > (Thomas "The Wizard of Time" added to CC :))
> > 
> > Added more wizards :)
> > 
> > > On 29/05/07, Ian Kumlien <iank@bredband.net> wrote:
> > > > Hi,
> > > >
> > > > As the daystar sets, i try to play some with my new would be
> > > > firewall/server, but since this will be running for quite some time i
> > > > have been experimenting with powertop to find out what i can do to limit
> > > > it's power usage.
> > > >
> > > > But, if i run powertop for too long or a few times to many... this
> > > > happens:
> > > > http://pomac.netswarm.net/pics/kernel_panic.jpg
> > 
> > This was reported before. It's incredibly hard to reproduce.
> 
> OK, second try, this time with a patch. In timer_stats_update_stats,
> input is allocated on the stack, so it is uninitialized, in particular
> the "next" field is random. Now in tstat_lookup, the new entry "curr" is
> initialized with the values from "input" (passed as "entry") and "next"
> is set to NULL _after_ it is added to the list, so if a second CPU is
> running the fastpath lookup while we're inserting the new element, it
> might get the garbage value in "next". The patch below fixes that.
> 
> Björn
> 
> 
> 
> Initialize the "next" field of a timer stats entry before it is inserted
> into the list to avoid a race with the fastpath lookup.
> 
> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> ---
> diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> index 868f1bc..5bc8f91 100644
> --- a/kernel/time/timer_stats.c
> +++ b/kernel/time/timer_stats.c
> @@ -202,12 +202,12 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
>  	if (curr) {
>  		*curr = *entry;
>  		curr->count = 0;
> +		curr->next = NULL;
>  		memcpy(curr->comm, comm, TASK_COMM_LEN);
>  		if (prev)
>  			prev->next = curr;
>  		else
>  			*head = curr;
> -		curr->next = NULL;
>  	}
>   out_unlock:
>  	spin_unlock(&table_lock);
> 

Your analysis might be right, not the fix.

You *cannot* assume curr->next = NULL will be done before insert.

You probably also need a memory barrier.

	curr->next = NULL;
	memcpy(curr->comm, comm, TASK_COMM_LEN);

	smp_mb(); /* commit all writes to curr before insert */

	if (prev)
		prev->next = curr;
	else
		*head = curr;
