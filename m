Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYF3JIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYF3JIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYF3JIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:08:04 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:29150 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYF3JIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:08:01 -0400
Date: Mon, 30 Jun 2008 11:07:44 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>
References: <20080619161949.GA11062@osiris.ibm.com> <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com> <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 12:16:56AM +0200, Dmitry Adamushko wrote:
> Hello,
> 
> 
> it seems to be related to migrate_dead_tasks().
> 
> Firstly I added traces to see all tasks being migrated with
> migrate_live_tasks() and migrate_dead_tasks(). On my setup the problem
> pops up (the one with "se == NULL" in the loop of
> pick_next_task_fair()) shortly after the traces indicate that some has
> been migrated with migrate_dead_tasks()). btw., I can reproduce it
> much faster now with just a plain cpu down/up loop.
> 
> [disclaimer] Well, unless I'm really missing something important in
> this late hour [/desclaimer] pick_next_task() is not something
> appropriate for migrate_dead_tasks() :-)
> 
> the following change seems to eliminate the problem on my setup
> (although, I kept it running only for a few minutes to get a few
> messages indicating migrate_dead_tasks() does move tasks and the
> system is still ok)
> 
> [ quick hack ]
> 
> @@ -5887,6 +5907,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
>                 next = pick_next_task(rq, rq->curr);
>                 if (!next)
>                         break;
> +               next->sched_class->put_prev_task(rq, next);
>                 migrate_dead(dead_cpu, next);
> 
>         }

Thanks Dmitry! With your patch I cannot reproduce the bug anymore.
