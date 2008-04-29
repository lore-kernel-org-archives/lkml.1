Return-Path: <linux-kernel-owner+w=401wt.eu-S1761878AbYD2Kn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878AbYD2Kn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761836AbYD2KnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:43:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54514 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521AbYD2KnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:43:21 -0400
Date: Tue, 29 Apr 2008 11:43:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] on memoryless node, /proc/pagetypeinfo is displayed slightly funny output.  take2
Message-ID: <20080429104318.GA9622@csn.ul.ie>
References: <20080429162859.3540.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4816D881.8060005@cn.fujitsu.com> <20080429171457.3543.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080429171457.3543.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/04/08 17:17), KOSAKI Motohiro didst pronounce:
> > > Index: b/mm/vmstat.c
> > > ===================================================================
> > > --- a/mm/vmstat.c       2008-04-29 16:48:58.000000000 +0900
> > > +++ b/mm/vmstat.c       2008-04-29 16:58:33.000000000 +0900
> > > @@ -638,6 +638,10 @@ static int pagetypeinfo_show(struct seq_
> > >  {
> > >         pg_data_t *pgdat = (pg_data_t *)arg;
> > > 
> > > +       /* check memoryless ndoe*/
> > 
> > ndoe -> node ?
> 
> Agghhh!
> you are right ;-)
> 
> fixed version is here.
> 

I see what you mean. The headers for a node with no populated zones looks
a bit odd. I was briefly thrown by the check for N_HIGH_MEMORY wondering
why it was not a check for N_NORMAL_MEMORY. A double-check showed that
N_NORMAL_MEMORY only has meaning on CONFIG_HIGHMEM machines and a check for
"any memory on the node" should use N_HIGH_MEMORY which is what you do.

So, your patch looks correct but unfortunately it is whitespace-damaged
and would not apply as-is. I included a whitespace-fixed version below for
convenience with a slightly clearer leader which I have acked.

Thanks

==========
On memoryless node, /proc/pagetypeinfo outputs headers for nodes with no
populated zones. This is confusing as shown in the following example.

>>>
Page block order: 14
Pages per block:  16384

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10     11     12     13     14     15     16

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
Page block order: 14
Pages per block:  16384

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10     11     12     13     14     15     16
<SNIP>
<<<

Note the headers with no zone information. This patch checks if the node
has any memory before outputting anything.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmstat.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c       2008-04-29 16:48:58.000000000 +0900
+++ b/mm/vmstat.c       2008-04-29 16:58:33.000000000 +0900
@@ -638,6 +638,10 @@ static int pagetypeinfo_show(struct seq_
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;

+	/* check memoryless node */
+	if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+		return 0;
+
 	seq_printf(m, "Page block order: %d\n", pageblock_order);
 	seq_printf(m, "Pages per block:  %lu\n", pageblock_nr_pages);
 	seq_putc(m, '\n');

