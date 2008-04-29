Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYD2ISN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYD2ISN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYD2IR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:17:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45444 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYD2IR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:17:58 -0400
Date: Tue, 29 Apr 2008 17:17:32 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Subject: [PATCH] on memoryless node, /proc/pagetypeinfo is displayed slightly funny output.  take2
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4816D881.8060005@cn.fujitsu.com>
References: <20080429162859.3540.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4816D881.8060005@cn.fujitsu.com>
Message-Id: <20080429171457.3543.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: b/mm/vmstat.c
> > ===================================================================
> > --- a/mm/vmstat.c       2008-04-29 16:48:58.000000000 +0900
> > +++ b/mm/vmstat.c       2008-04-29 16:58:33.000000000 +0900
> > @@ -638,6 +638,10 @@ static int pagetypeinfo_show(struct seq_
> >  {
> >         pg_data_t *pgdat = (pg_data_t *)arg;
> > 
> > +       /* check memoryless ndoe*/
> 
> ndoe -> node ?

Agghhh!
you are right ;-)

fixed version is here.


=================================================================
on memoryless node, /proc/pagetypeinfo is displayed slightly funny output.
this patch fix it.


output example (header is outputed, but no data is outputed)
--------------------------------------------------------------
Page block order: 14
Pages per block:  16384

Free pages count per migrate type at order       0      1      2      3      4      5    \
  6      7      8      9     10     11     12     13     14     15     16

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve      Isolate
Page block order: 14
Pages per block:  16384

Free pages count per migrate type at order       0      1      2      3      4      5    \
  6      7      8      9     10     11     12     13     14     15     16


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Mel Gorman <mel@csn.ul.ie>
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

+       /* check memoryless node */
+       if (!node_state(pgdat->node_id, N_HIGH_MEMORY))
+               return 0;
+
        seq_printf(m, "Page block order: %d\n", pageblock_order);
        seq_printf(m, "Pages per block:  %lu\n", pageblock_nr_pages);
        seq_putc(m, '\n');


