Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZCKSOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZCKSOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZCKSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:14:13 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24615 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZCKSOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:14:12 -0400
Date: Wed, 11 Mar 2009 12:14:09 -0600
From: Alex Chiang <achiang@hp.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
	per kobj
Message-ID: <20090311181409.GB23138@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <gregkh@suse.de>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, tj@kernel.org,
	linux-kernel@vger.kernel.org
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com> <20090311153228.GA21217@suse.de> <20090311184729.110761e4@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311184729.110761e4@gondolin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Wed, 11 Mar 2009 08:32:28 -0700,
> Greg KH <gregkh@suse.de> wrote:
> 
> > Why can't you use device_unregister()?  Or, you could use device_del(),
> > which lets you rely on the fact that the device structure is still
> > around for a bit, but it will disappear from sysfs.  Just don't forget
> > to do the final put_device() on it to free the memory and "really"
> > release it.
> > 
> > Or am I missing something else here?
> 
> You can't unregister a device from one of its attribute callbacks, it
> locks up in sysfs (removing the sysfs dir waits for all active
> references to be dropped, but the reference obtained before calling
> ->store won't be dropped until after ->store returned...)
> device_schedule_callback() was introduced to solve exactly that problem.

Yes, that is exactly why I used device_schedule_callback.

> (For the original oops, I'd rather solve the problem by making sure the
> caller doesn't trigger removal several times - should probably be less
> code than the proposed patch?)
 
The scsi stuff [sdev_store_delete()] is susceptible to exactly
the same problem.

I could put the "only allow one removal per kobj" code into my
specific code path, but I think it makes more sense to put it in
the common code.

Thanks.

/ac

