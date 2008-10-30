Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYJ3JeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYJ3JeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYJ3Jdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:33:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYJ3Jdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:33:55 -0400
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0810300154040.29917@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>
	 <1225356285.7803.7.camel@twins>
	 <alpine.DEB.2.00.0810300154040.29917@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 10:34:16 +0100
Message-Id: <1225359256.7803.52.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 02:03 -0700, David Rientjes wrote:
> On Thu, 30 Oct 2008, Peter Zijlstra wrote:
> 
> > On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:
> > 
> > > +/*
> > > + * Determine the dirty ratios for the currently active cpuset
> > > + */
> > > +void cpuset_get_current_dirty_ratios(int *background, int *throttle)
> > > +{
> > > +	mutex_lock(&callback_mutex);
> > > +	task_lock(current);
> > > +	*background = task_cs(current)->dirty_background_ratio;
> > > +	*throttle = task_cs(current)->cpuset_dirty_ratio;
> > > +	task_unlock(current);
> > > +	mutex_unlock(&callback_mutex);
> > > +
> > > +	if (*background == -1)
> > > +		*background = dirty_background_ratio;
> > > +	if (*throttle == -1)
> > > +		*throttle = vm_dirty_ratio;
> > > +}
> > 
> > That's rather an awful lot of locking to read just two integers.
> > 
> 
> As far as I know, task_lock(current) is required to dereference 
> task_cs(current) and callback_mutex is required to ensure its the same 
> cpuset.

Since we read these things for every evaluation, getting it wrong isn't
too harmful.

So I would suggest just enough locking to ensure we don't reference any
NULL pointers and such.

IIRC the cpuset stuff is RCU freed, so some racy read should be
possible, no?
