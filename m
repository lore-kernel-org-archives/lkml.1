Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZKQLDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZKQLDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZKQLDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:03:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34942 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZKQLDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:03:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/5] vmscan: Have kswapd sleep for a short interval and double check it should be asleep
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20091114154636.GR29804@csn.ul.ie>
References: <2f11576a0911140134u21eafa83t9642bb25ccd953de@mail.gmail.com> <20091114154636.GR29804@csn.ul.ie>
Message-Id: <20091117141638.3DCB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 20:03:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for the long delay.

> On Sat, Nov 14, 2009 at 06:34:23PM +0900, KOSAKI Motohiro wrote:
> > 2009/11/14 Mel Gorman <mel@csn.ul.ie>:
> > > On Sat, Nov 14, 2009 at 03:00:57AM +0900, KOSAKI Motohiro wrote:
> > >> > On Fri, Nov 13, 2009 at 07:43:09PM +0900, KOSAKI Motohiro wrote:
> > >> > > > After kswapd balances all zones in a pgdat, it goes to sleep. In the event
> > >> > > > of no IO congestion, kswapd can go to sleep very shortly after the high
> > >> > > > watermark was reached. If there are a constant stream of allocations from
> > >> > > > parallel processes, it can mean that kswapd went to sleep too quickly and
> > >> > > > the high watermark is not being maintained for sufficient length time.
> > >> > > >
> > >> > > > This patch makes kswapd go to sleep as a two-stage process. It first
> > >> > > > tries to sleep for HZ/10. If it is woken up by another process or the
> > >> > > > high watermark is no longer met, it's considered a premature sleep and
> > >> > > > kswapd continues work. Otherwise it goes fully to sleep.
> > >> > > >
> > >> > > > This adds more counters to distinguish between fast and slow breaches of
> > >> > > > watermarks. A "fast" premature sleep is one where the low watermark was
> > >> > > > hit in a very short time after kswapd going to sleep. A "slow" premature
> > >> > > > sleep indicates that the high watermark was breached after a very short
> > >> > > > interval.
> > >> > > >
> > >> > > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > >> > >
> > >> > > Why do you submit this patch to mainline? this is debugging patch
> > >> > > no more and no less.
> > >> > >
> > >> >
> > >> > Do you mean the stats part? The stats are included until such time as the page
> > >> > allocator failure reports stop or are significantly reduced. In the event a
> > >> > report is received, the value of the counters help determine if kswapd was
> > >> > struggling or not. They should be removed once this mess is ironed out.
> > >> >
> > >> > If there is a preference, I can split out the stats part and send it to
> > >> > people with page allocator failure reports for retesting.
> > >>
> > >> I'm sorry my last mail didn't have enough explanation.
> > >> This stats help to solve this issue. I agreed. but after solving this issue,
> > >> I don't imagine administrator how to use this stats. if KSWAPD_PREMATURE_FAST or
> > >> KSWAPD_PREMATURE_SLOW significantly increased, what should admin do?
> > >
> > > One possible workaround would be to raise min_free_kbytes while a fix is
> > > being worked on.
> > 
> > Please correct me, if I said wrong thing.
> 
> You didn't.
> 
> > if I was admin, I don't watch this stats because kswapd frequently
> > wakeup doesn't mean any trouble. instead I watch number of allocation
> > failure.
> 
> The stats are not tracking when kswapd wakes up. It helps track how
> quickly the high or low watermarks are going under once kswapd tries to
> go back to sleep.

Umm, honestly I'm still puzlled. probably we need go back one step at once.
 kswapd wake up when memory amount less than low watermark and sleep
when memory amount much than high watermask. We need to know 
GFP_ATOMIC failure sign.

My point is, kswapd wakeup only happen after kswapd sleeping. but if the system is
under heavy pressure and memory amount go up and down between low watermark
and high watermark, this stats don't increase at all. IOW, this stats is strong related to
high watermark.

Probaby, min watermark or low watermark are more useful for us.

# of called wake_all_kswapd() is related to low watermark. and It's conteniously
increase although the system have strong memroy pressure. I'm ok.
KSWAPD_NO_CONGESTION_WAIT is related to min watermark. I'm ok too..
# of page allocation failure is related to  min watermark too. I'm ok too.

IOW, I only dislike this stat stop increase strong memory pressure (above explanation).
Can you please tell me why you think kswapd slept time is so important?



