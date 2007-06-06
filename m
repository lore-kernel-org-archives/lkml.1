Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbXFFH5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbXFFH5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbXFFH5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:57:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46517 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbXFFH5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:57:05 -0400
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
	globally
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.99.0706060042550.15316@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	 <1181110846.7348.154.camel@twins>
	 <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
	 <1181113753.7348.164.camel@twins>
	 <alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
	 <20070606003421.1107a8bf.pj@sgi.com>
	 <alpine.DEB.0.99.0706060042550.15316@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 09:56:53 +0200
Message-Id: <1181116613.7348.169.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 00:48 -0700, David Rientjes wrote:
> On Wed, 6 Jun 2007, Paul Jackson wrote:
> 
> > Seems like that mlock code is able then to get great globs of memory
> > without returning to user space ... perhaps that's where the fix
> > should be ... that code should quit chewing up memory if it's
> > marked MEMDIE or some such?
> > 
> 
> That's one case.  Are there others?
> 
> The TIF_MEMDIE exception in cpuset_zone_allowed_softwall() allowed this 
> problem in mlock().  If it had not been allowed to allocate anywhere 
> based simply on the zonelist ordering, the mlock iteration would break 
> because it could not handle the fault.
> 
> Thus, at the least, we should make sure that memory is not allocated 
> outside of a task's mems_allowed unless we do sanity checks against 
> gfp_mask in the TIF_MEMDIE case via cpuset_zone_allowed_softwall() to make 
> sure a rouge application doesn't cause the same trouble.  That is, unless 
> you can guarantee this type of problem will not happen again through any 
> other means.  The logic needs to be with the TIF_MEMDIE exception to grant 
> access to memory outside the cpuset only when it is relevant to the OOM 
> killed task's prompt exit.

I don't think your patch alone would have been sufficient. With it it
would have depleted the local reserves and then jumped onwards to other
nodes (since the ALLOC_NO_WATERMARKS allocation doesn't have
ALLOC_CPUSET).

Unless there was a mem-policy restricting the zonelist (not sure if
cpusets and mem-policies are independent like that)

But your point stands.

