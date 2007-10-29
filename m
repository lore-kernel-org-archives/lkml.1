Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXJ2VWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXJ2VWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXJ2VWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:22:46 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:20504 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbXJ2VWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:22:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Mon, 29 Oct 2007 22:22:41 +0100
User-Agent: KMail/1.9.7
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <200710122231.50739.elendil@planet.nl> <200710292133.48125.borntraeger@de.ibm.com> <20071029204116.GA13026@elte.hu>
In-Reply-To: <20071029204116.GA13026@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292222.42688.elendil@planet.nl>
X-OriginalArrivalTime: 29 Oct 2007 21:22:43.0278 (UTC) FILETIME=[D7B6FEE0:01C81A71]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007, Ingo Molnar wrote:
> * Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > > -	return clock_t_to_cputime(utime);
> > > +	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> > > +	return p->prev_utime;
> > >  }
> >
> > [...]
> >
> > I dont think it will work. It will make utime monotic, but stime can
> > still decrease. For example let sum_exec_runtime increase by a tiny
> > little bit while utime will get a full additional tick. stime is
> > sum-utime. So stime can still go backwards. So I think that we need
> > this kind of logic for stime as well, no?
>
> yeah, probably. Peter?

Yes, definitely :-)

With this patch stime is still all over the place.

Oct 29 22:12:39 314 64
Oct 29 22:12:40 392 68
Oct 29 22:12:41 408 67  <--
Oct 29 22:12:42 410 67
Oct 29 22:12:43 416 68
Oct 29 22:12:44 420 68
Oct 29 22:12:45 424 68
Oct 29 22:12:46 426 68
Oct 29 22:12:47 430 70
Oct 29 22:12:48 430 70
Oct 29 22:12:49 430 70
Oct 29 22:12:50 432 68  <--
Oct 29 22:12:51 432 69
Oct 29 22:12:52 432 69
Oct 29 22:12:53 432 69
Oct 29 22:12:54 432 69
Oct 29 22:12:55 432 69
Oct 29 22:12:56 433 70
Oct 29 22:12:57 434 69  <--
Oct 29 22:12:58 443 71

utime looks OK now, though I'd like to test it a bit more (when stime is 
fixed too) before giving a final verdict on that.
