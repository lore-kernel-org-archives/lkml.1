Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZIAHY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZIAHY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZIAHY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:24:57 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:35613 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZIAHY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=c1uNpaUV3VMRIy17TwqOOd5Od8PeDg4kFtc67uGYPwl2Ct69uZK3atLOIQFuXbmVlU
         Q2T/5VbVDz904bNtAaOJ/sw83uZYpi7NxVLi79dj4J0eGQJzVnobbQLZ8abvfPfRc3mx
         6wNl+cJYqk1Z1mBThlz0AL17cmv60/CURcBUc=
Date: Tue, 1 Sep 2009 16:24:19 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH mmotm] Fix NUMA accounting in numastat.txt
Message-Id: <20090901162419.a4a6c80e.minchan.kim@barrios-desktop>
In-Reply-To: <20090901161721.f104c476.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090901135321.f0da4715.minchan.kim@barrios-desktop>
	<20090901161721.f104c476.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Tue, 1 Sep 2009 16:17:21 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 1 Sep 2009 13:53:21 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > 
> > In Documentation/numastat.txt, it confused me.
> > For example, there are nodes [0,1] in system.
> > 
> > barrios:~$ cat /proc/zoneinfo | egrep 'numa|zone'
> > Node 0, zone	DMA
> > 	numa_hit	33226
> > 	numa_miss	1739
> > 	numa_foreign	27978
> > 	..
> > 	..
> > Node 1, zone	DMA
> > 	numa_hit	307
> > 	numa_miss	46900
> > 	numa_foreign	0
> > 
> > 1) In node 0,  NUMA_MISS means it wanted to allocate page
> > in node 1 but ended up with page in node 0
> > 
> > 2) In node 0, NUMA_FOREIGN means it wanted to allocate page
> > in node 0 but ended up with page from Node 1.
> > 
> > But now, numastat explains it oppositely about (MISS, FOREIGN).
> > Let's fix up with viewpoint of zone. 
> > 
> 
> I'm confused....documentation is really bad ?
> Implementation isn't ?

At that time, I though of it. 
But I knew code is right since zone_stat_item said follwing as. 
NUMA_MISS is rather unclear but NUMA_FOREIGN is clear, I think.

        NUMA_MISS,              /* allocated in non intended node */
        NUMA_FOREIGN,           /* was intended here, hit elsewhere */

Also I am worry about legacy tools related to NUMA but I don't know it.
Code change will break them.

> Hmm, this function ?
> ==
> void zone_statistics(struct zone *preferred_zone, struct zone *z)
> {
>         if (z->zone_pgdat == preferred_zone->zone_pgdat) {
>                 __inc_zone_state(z, NUMA_HIT);
>         } else {
>                 __inc_zone_state(z, NUMA_MISS);
>                 __inc_zone_state(preferred_zone, NUMA_FOREIGN);
>         }
>         if (z->node == numa_node_id())
>                 __inc_zone_state(z, NUMA_LOCAL);
>         else
>                 __inc_zone_state(z, NUMA_OTHER);
> }
> ==
> I wonder
> ==
> void zone_statistics(struct zone *preferred_zone, struct zone *z)
> {
>         if (z->zone_pgdat == preferred_zone->zone_pgdat) {
>                 __inc_zone_state(z, NUMA_HIT);
>         } else {
>                 __inc_zone_state(preferred_zone, NUMA_MISS);
>                 __inc_zone_state(z, NUMA_FOREIGN);
>         }
>         if (z->node == numa_node_id())
>                 __inc_zone_state(z, NUMA_LOCAL);
>         else
>                 __inc_zone_state(z, NUMA_OTHER);
> }
> ==
> Is correct fix ....
> 
> Thanks,
> -Kame
> 
> 
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  Documentation/numastat.txt |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/numastat.txt b/Documentation/numastat.txt
> > index 80133ac..9fcc9a6 100644
> > --- a/Documentation/numastat.txt
> > +++ b/Documentation/numastat.txt
> > @@ -7,10 +7,10 @@ All units are pages. Hugepages have separate counters.
> > 
> >  numa_hit			A process wanted to allocate memory from this node,
> >  					and succeeded.
> > -numa_miss			A process wanted to allocate memory from this node,
> > -					but ended up with memory from another.
> > -numa_foreign		A process wanted to allocate on another node,
> > -				    but ended up with memory from this one.
> > +numa_miss			A process wanted to allocate memory from another node,
> > +					but ended up with memory from this node.
> > +numa_foreign		A process wanted to allocate on this node,
> > +				    but ended up with memory from another one.
> >  local_node			A process ran on this node and got memory from it.
> >  other_node			A process ran on this node and got memory from another node.
> >  interleave_hit 		Interleaving wanted to allocate from this node
> > --
> > 1.5.4.3
> > 
> > 
> > 
> > -- 
> > Kind regards,
> > Minchan Kim
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> > 
> 


-- 
Kind regards,
Minchan Kim
