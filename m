Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYCKI3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYCKI3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYCKI2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:28:53 -0400
Received: from n11.bullet.mail.mud.yahoo.com ([209.191.125.210]:21677 "HELO
	n11.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752590AbYCKI2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:28:51 -0400
X-Yahoo-Newman-Id: 245464.81849.bm@omp404.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=L2cMsnIYB1LI6MzmvUO01GGZmeAU2TR9PhOUxpYfM0dcFoSEY9H/SUL8EKNr/BCyhQMJ9WXxQ1UbzidFVG9ZhHynMWPVD6qgeX3+yqLS2qPTH5rD3Xh+E8wDy7rJwCFWCRboUzTg6RyhNDDOG1SYH3F9IOq/FjOQdhkDKA1oDyM=  ;
X-YMail-OSG: 4KVlA14VM1njhVUDyIHNITZ_7kdKPC_SIGKX1lNQhc3amXTuj9ODJIF4DIm10KK_1X4tXoIvyQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Tue, 11 Mar 2008 19:28:19 +1100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <20080311075845.GA13758@elte.hu>
In-Reply-To: <20080311075845.GA13758@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803111928.20043.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 18:58, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > PostgreSQL is different. It has zero idle time when running this
> > workload. It actually scaled "super linearly" on my system here, from
> > single threaded performance to 8 cores (giving an 8.2x performance
> > increase)!
> >
> > So PostgreSQL performance profile is actually much more interesting.
> > To my dismay, I found that Linux 2.6.25-rc5 performs really badly
> > after saturating the runqueues and subsequently increasing threads.
> > 2.6.22 drops a little bit, but basically settles near the peak
> > performance. With 2.6.25-rc5, throughput seems to be falling off
> > linearly with the number of threads.
>
> thanks Nick, i'll check this

Thanks.


> - and i agree that this very much looks 
> like a scheduler regression.

I'd say it is. Quite a nasty one too: if your server gets nudged over
the edge of the cliff, it goes into a feedback loop and goes splat at
the bottom somewhere ;)


> Just a quick suggestion, does a simple 
> runtime tune like this fix the workload:
>
>   for N in /proc/sys/kernel/sched_domain/*/*/flags; do
>      echo $[`cat $N`|16] > N
>   done
>
> this sets SD_WAKE_IDLE for all the nodes in the scheduler domains tree.
> (doing this results in over-agressive idle balancing - but if this fixes
> your testcase it shows that we were balancing under-agressively for this
> workload.) Thanks,

It doesn't change anything.

There is no idle time for this workload, btw.

