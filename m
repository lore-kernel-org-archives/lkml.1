Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZKNAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZKNAIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbZKNAIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:08:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbZKNAIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:08:48 -0500
Date: Sat, 14 Nov 2009 01:08:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       gerald.schaefer@de.ibm.com, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow memory hotplug and hibernation in the same kernel
Message-ID: <20091114000849.GG30880@basil.fritz.box>
References: <20091113105944.GA16028@basil.fritz.box> <20091113155102.3480907f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113155102.3480907f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 03:51:02PM -0800, Andrew Morton wrote:
> > ...
> >
> > +extern struct mutex pm_mutex;
> 
> Am a bit worried by the new mutex.

It's not a new mutex, just the existing one already used by suspend.
I only extended it's coverage to two more code paths.

> 
> > -extern struct mutex pm_mutex;
> > +static inline void lock_hibernation(void) {}
> > +static inline void unlock_hibernation(void) {}
> > +
> > +#else
> > +
> > +/* Let some subsystems like memory hotadd exclude hibernation */
> > +
> > +static inline void lock_hibernation(void)
> > +{
> > +	mutex_lock(&pm_mutex);
> > +}
> > +
> > +static inline void unlock_hibernation(void)
> > +{
> > +	mutex_unlock(&pm_mutex);
> > +}
> > +#endif
> 
> Has this been carefully reviewed and lockdep-tested to ensure that we
> didn't introduce any ab/ba nasties?

It's a "outer" global mutex for both, so I don't expect ABBA issues.

I tested hotadd/hotremove with lockdep and nothing showed up.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
