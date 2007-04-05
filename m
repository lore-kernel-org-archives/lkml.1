Return-Path: <linux-kernel-owner+w=401wt.eu-S965972AbXDEKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972AbXDEKUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 06:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966017AbXDEKUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 06:20:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42095 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965972AbXDEKU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 06:20:29 -0400
Date: Thu, 5 Apr 2007 15:49:00 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 2/8] Make process freezer reentrant
Message-ID: <20070405101900.GA16173@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402053741.GB12962@in.ibm.com> <20070405095301.GB609@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405095301.GB609@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 01:53:01PM +0400, Oleg Nesterov wrote:
> On 04/02, Gautham R Shenoy wrote:
> >
> >  int freeze_processes(unsigned long freeze_event)
> >  {
> >  	unsigned int nr_unfrozen;
> > -
> > +	int ret = 0;
> > +	mutex_lock(&freezer_mutex);
> > +	if (system_freeze_event_mask & freeze_event)
> > +		goto done;
> 
> I am not sure this is correct. Suppose that system_freeze_event_mask == FE_SUSPEND,
> now freeze_processes(FE_ALL) returns success. Shouldn't we return an error?

Hmm, may be we are getting confused with the word 'reentrant' here.
The idea behind this API was to freeze the system for one event
only at any given time.

However, we can have nested freeze_processes() call for different events.

Something like 
freeze_processes(FE_SUSPEND);

/* Do something */

	freeze_processes(FE_HOTPLUG_CPU);

	/* hotplug cpus */

	thaw_processes(FE_HOTPLUG_CPU);

/* Do something more */

thaw_processes(FE_SUSPEND);

So ideally no one is supposed to make a call like
freeze_processes(FE_SUSPEND | FE_HOTPLUG_CPU);
OR
freeze_processes(FE_ALL);

I guess I should also put a check for a valid freeze event.

> 
> Oleg.
> 

Thanks
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
