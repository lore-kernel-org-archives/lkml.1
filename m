Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYJ3JES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYJ3JES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYJ3JED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:04:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYJ3JEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:04:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=uxKhXWk9f82TJB5O6YO7BPD405NVEEBNOQ1gcK2IRAoJNm9T2JTNXwoW0sQNkIu+w
	Cr6bsXtFqk8T/K5ATnXxg==
Date: Thu, 30 Oct 2008 02:03:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
In-Reply-To: <1225356285.7803.7.camel@twins>
Message-ID: <alpine.DEB.2.00.0810300154040.29917@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>  <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com> <1225356285.7803.7.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Peter Zijlstra wrote:

> On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:
> 
> > +/*
> > + * Determine the dirty ratios for the currently active cpuset
> > + */
> > +void cpuset_get_current_dirty_ratios(int *background, int *throttle)
> > +{
> > +	mutex_lock(&callback_mutex);
> > +	task_lock(current);
> > +	*background = task_cs(current)->dirty_background_ratio;
> > +	*throttle = task_cs(current)->cpuset_dirty_ratio;
> > +	task_unlock(current);
> > +	mutex_unlock(&callback_mutex);
> > +
> > +	if (*background == -1)
> > +		*background = dirty_background_ratio;
> > +	if (*throttle == -1)
> > +		*throttle = vm_dirty_ratio;
> > +}
> 
> That's rather an awful lot of locking to read just two integers.
> 

As far as I know, task_lock(current) is required to dereference 
task_cs(current) and callback_mutex is required to ensure its the same 
cpuset.
