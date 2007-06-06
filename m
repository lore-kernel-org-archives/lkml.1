Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbXFFHtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbXFFHtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXFFHt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:49:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbXFFHt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:49:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=guUxS8RsJFAVRPXaBKbpZDGIzalUQwithCyw6QBTbdk/wPIBJok+lc4aAq19/q2tA
	A7gQUQO5y/S+LnygdptyA==
Date: Wed, 6 Jun 2007 00:48:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: peterz@infradead.org, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
In-Reply-To: <20070606003421.1107a8bf.pj@sgi.com>
Message-ID: <alpine.DEB.0.99.0706060042550.15316@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
 <1181110846.7348.154.camel@twins> <alpine.DEB.0.99.0706052334280.30783@chino.kir.corp.google.com>
 <1181113753.7348.164.camel@twins> <alpine.DEB.0.99.0706060012260.15316@chino.kir.corp.google.com>
 <20070606003421.1107a8bf.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Paul Jackson wrote:

> Seems like that mlock code is able then to get great globs of memory
> without returning to user space ... perhaps that's where the fix
> should be ... that code should quit chewing up memory if it's
> marked MEMDIE or some such?
> 

That's one case.  Are there others?

The TIF_MEMDIE exception in cpuset_zone_allowed_softwall() allowed this 
problem in mlock().  If it had not been allowed to allocate anywhere 
based simply on the zonelist ordering, the mlock iteration would break 
because it could not handle the fault.

Thus, at the least, we should make sure that memory is not allocated 
outside of a task's mems_allowed unless we do sanity checks against 
gfp_mask in the TIF_MEMDIE case via cpuset_zone_allowed_softwall() to make 
sure a rouge application doesn't cause the same trouble.  That is, unless 
you can guarantee this type of problem will not happen again through any 
other means.  The logic needs to be with the TIF_MEMDIE exception to grant 
access to memory outside the cpuset only when it is relevant to the OOM 
killed task's prompt exit.

		David
