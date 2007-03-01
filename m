Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXCANNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXCANNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCANNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:13:00 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:55593 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbXCANM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:12:59 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 1 Mar 2007 14:12:50 +0100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <200703011228.01144.dada1@cosmosbay.com> <20070301114731.GA20773@2ka.mipt.ru>
In-Reply-To: <20070301114731.GA20773@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TFt5FQIfTw7yHXj"
Message-Id: <200703011412.51256.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TFt5FQIfTw7yHXj
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 01 March 2007 12:47, Evgeniy Polyakov wrote:
>
> Could you provide at least remote way to find it?
>

Sure :)

> I only found the same problem at
> http://lkml.org/lkml/2006/10/27/3
>
> but without any hits to solve the problem.
>
> I will try CVS oprofile, if it works I will provide details of course.
>

# cat CVS/Root
CVS/Root::pserver:anonymous@oprofile.cvs.sourceforge.net:/cvsroot/oprofile

# cvs diff >/tmp/oprofile.diff

Hope it helps

--Boundary-00=_TFt5FQIfTw7yHXj
Content-Type: text/x-diff;
  charset="koi8-r";
  name="oprofile.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="oprofile.diff"

Index: libop/op_alloc_counter.c
===================================================================
RCS file: /cvsroot/oprofile/oprofile/libop/op_alloc_counter.c,v
retrieving revision 1.8
diff -r1.8 op_alloc_counter.c
14a15,16
> #include <ctype.h>
> #include <dirent.h>
133c135
< 			return 0;
---
> 			continue;
145a148,183
> /* determine which directories are counter directories
>  */
> static int perfcounterdir(const struct dirent * entry)
> {
> 	return (isdigit(entry->d_name[0]));
> }
> 
> 
> /**
>  * @param mask pointer where to place bit mask of unavailable counters
>  *
>  * return >= 0 number of counters that are available
>  *        < 0  could not determine number of counters
>  *
>  */
> static int op_get_counter_mask(u32 * mask)
> {
> 	struct dirent **counterlist;
> 	int count, i;
> 	/* assume nothing is available */
> 	u32 available=0;
> 
> 	count = scandir("/dev/oprofile", &counterlist, perfcounterdir,
> 			alphasort);
> 	if (count < 0)
> 		/* unable to determine bit mask */
> 		return -1;
> 	/* convert to bit map (0 where counter exists) */
> 	for (i=0; i<count; ++i) {
> 		available |= 1 << atoi(counterlist[i]->d_name);
> 		free(counterlist[i]);
> 	}
> 	*mask=~available;
> 	free(counterlist);
> 	return count;
> }
152a191
> 	u32 unavailable_counters = 0;
154c193,195
< 	nr_counters = op_get_nr_counters(cpu_type);
---
> 	nr_counters = op_get_counter_mask(&unavailable_counters);
> 	if (nr_counters < 0) 
> 		nr_counters = op_get_nr_counters(cpu_type);
162c203,204
< 	if (!allocate_counter(ctr_arc, nr_events, 0, 0, counter_map)) {
---
> 	if (!allocate_counter(ctr_arc, nr_events, 0, unavailable_counters,
> 			      counter_map)) {

--Boundary-00=_TFt5FQIfTw7yHXj--
