Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXIQTAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXIQTAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXIQTAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:00:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47512 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541AbXIQTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:00:07 -0400
Date: Mon, 17 Sep 2007 12:00:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org, pj@sgi.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] cpuset dirty limits
In-Reply-To: <20070914161540.5b192348.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709171153010.27542@schroedinger.engr.sgi.com>
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com>
 <46E743F8.9050206@google.com> <20070914161540.5b192348.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Andrew Morton wrote:

> > +	mutex_lock(&callback_mutex);
> > +	*cs_int = val;
> > +	mutex_unlock(&callback_mutex);
> 
> I don't think this locking does anything?

Locking is wrong here. The lock needs to be taken before the cs pointer 
is dereferenced from the caller.

> > +	return 0;
> > +}
> > +
> >  /*
> >   * Frequency meter - How fast is some event occurring?
> >   *
> > ...
> > +void cpuset_get_current_ratios(int *background_ratio, int *throttle_ratio)
> > +{
> > +	int background = -1;
> > +	int throttle = -1;
> > +	struct task_struct *tsk = current;
> > +
> > +	task_lock(tsk);
> > +	background = task_cs(tsk)->background_dirty_ratio;
> > +	throttle = task_cs(tsk)->throttle_dirty_ratio;
> > +	task_unlock(tsk);
> 
> ditto?

It is required to take the task lock while dereferencing the tasks cpuset 
pointer.
