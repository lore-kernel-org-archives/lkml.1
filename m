Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbZEGW7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbZEGW7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZEGW7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:59:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZEGW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:59:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ka9SOR3zJBtKNacnzvhxg+s2Fg0Q+kJ0Wd8JLW7TUma4i5K1fvpHZ0ZLkUwuxDitJ
	AUUV2HXeUF2DLDe9zd9pg==
Date: Thu, 7 May 2009 15:59:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: rjw@sisk.pl, fengguang.wu@intel.com, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <20090507154502.a7f51dd9.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905071554490.10759@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com> <200905072238.14558.rjw@sisk.pl> <20090507135615.e7db550d.akpm@linux-foundation.org>
 <alpine.DEB.2.00.0905071417160.24417@chino.kir.corp.google.com> <20090507145041.9b59f4eb.akpm@linux-foundation.org> <alpine.DEB.2.00.0905071508190.2164@chino.kir.corp.google.com> <20090507154502.a7f51dd9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Andrew Morton wrote:

> The setting and clearing of that thing looks gruesomely racy..
> 

It's not racy currently because zone_scan_lock ensures ZONE_OOM_LOCKED 
gets test/set and cleared atomically for the entire zonelist (the clear 
happens for the same zonelist that was test/set).

Using it for hibernation in the way I've proposed will open it up to the 
race I earlier described: when a kthread is in the oom killer and 
subsequently clears its zonelist of ZONE_OOM_LOCKED (all other tasks are 
frozen so they can't be in the oom killer).  That's perfectly acceptable, 
however, since the system is by definition already oom if kthreads can't 
get memory so it will end up killing a user task even though it's stuck in 
D state and will exit on thaw; we aren't concerned about killing 
needlessly because the oom killer becomes a no-op when it finds a task 
that has already been killed but hasn't exited by way of TIF_MEMDIE.
