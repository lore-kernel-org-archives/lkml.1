Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbYJ3KDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbYJ3KDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYJ3KC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:02:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbYJ3KC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:02:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=GzaqyNs/7ETkfldnz7flKXPsznR1lHkopV/sE8kYXFRvGoLLJ1+oaXwn2vBgeSmtE
	aSJOgMmMevkSl4GfQX79A==
Date: Thu, 30 Oct 2008 03:02:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
In-Reply-To: <1225359256.7803.52.camel@twins>
Message-ID: <alpine.DEB.2.00.0810300255290.16350@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>  <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>  <1225356285.7803.7.camel@twins>  <alpine.DEB.2.00.0810300154040.29917@chino.kir.corp.google.com>
 <1225359256.7803.52.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Peter Zijlstra wrote:

> > > > +/*
> > > > + * Determine the dirty ratios for the currently active cpuset
> > > > + */
> > > > +void cpuset_get_current_dirty_ratios(int *background, int *throttle)
> > > > +{
> > > > +	mutex_lock(&callback_mutex);
> > > > +	task_lock(current);
> > > > +	*background = task_cs(current)->dirty_background_ratio;
> > > > +	*throttle = task_cs(current)->cpuset_dirty_ratio;
> > > > +	task_unlock(current);
> > > > +	mutex_unlock(&callback_mutex);
> > > > +
> > > > +	if (*background == -1)
> > > > +		*background = dirty_background_ratio;
> > > > +	if (*throttle == -1)
> > > > +		*throttle = vm_dirty_ratio;
> > > > +}
> > > 
> > > That's rather an awful lot of locking to read just two integers.
> > > 
> > 
> > As far as I know, task_lock(current) is required to dereference 
> > task_cs(current) and callback_mutex is required to ensure its the same 
> > cpuset.
> 
> Since we read these things for every evaluation, getting it wrong isn't
> too harmful.
> 
> So I would suggest just enough locking to ensure we don't reference any
> NULL pointers and such.
> 
> IIRC the cpuset stuff is RCU freed, so some racy read should be
> possible, no?
> 

Ah, that sounds reasonable.  We'll no longer require callback_mutex if we 
accept races when current attaches to another cpuset here.  We'll need 
rcu_read_lock() to safely dereference task_cs(current) unless it's 
top_cpuset, but that's much better than callback_mutex and spinning on 
task_lock(current).

Thanks!
