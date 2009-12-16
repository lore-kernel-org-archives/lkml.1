Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZLPFnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZLPFnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZLPFnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:43:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:50824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752887AbZLPFnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:43:49 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Hdb0FGRbH7ZvKLc9UxX/J21hjvnwJ7JqxM3mOSN
	0qKr9Fx17JrnkS
Subject: Re: [PATCH 4/8] Use prepare_to_wait_exclusive() instead
 prepare_to_wait()
From: Mike Galbraith <efault@gmx.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091216093533.CDF1.A69D9226@jp.fujitsu.com>
References: <1260855146.6126.30.camel@marge.simson.net>
	 <4B27A417.3040206@redhat.com> <20091216093533.CDF1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 06:43:44 +0100
Message-Id: <1260942224.5766.57.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 09:48 +0900, KOSAKI Motohiro wrote:
> > On 12/15/2009 12:32 AM, Mike Galbraith wrote:
> > > On Tue, 2009-12-15 at 09:45 +0900, KOSAKI Motohiro wrote:
> > >>> On 12/14/2009 07:30 AM, KOSAKI Motohiro wrote:
> > >>>> if we don't use exclusive queue, wake_up() function wake _all_ waited
> > >>>> task. This is simply cpu wasting.
> > >>>>
> > >>>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> > >>>
> > >>>>    		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
> > >>>>    					0, 0)) {
> > >>>> -			wake_up(wq);
> > >>>> +			wake_up_all(wq);
> > >>>>    			finish_wait(wq,&wait);
> > >>>>    			sc->nr_reclaimed += sc->nr_to_reclaim;
> > >>>>    			return -ERESTARTSYS;
> > >>>
> > >>> I believe we want to wake the processes up one at a time
> > >>> here.
> > 
> > >> Actually, wake_up() and wake_up_all() aren't different so much.
> > >> Although we use wake_up(), the task wake up next task before
> > >> try to alloate memory. then, it's similar to wake_up_all().
> > 
> > That is a good point.  Maybe processes need to wait a little
> > in this if() condition, before the wake_up().  That would give
> > the previous process a chance to allocate memory and we can
> > avoid waking up too many processes.
> 
> if we really need wait a bit, Mike's wake_up_batch is best, I think.
> It mean
>  - if another CPU is idle, wake up one process soon. iow, it don't
>    make meaningless idle.

Along those lines, there's also NEWIDLE balancing considerations.  That
idle may result in a task being pulled, which may or may not hurt a bit.

'course, if you're jamming up on memory allocation, that's the least of
your worries, but every idle avoided is potentially a pull avoided.

Just a thought.

	-Mike

