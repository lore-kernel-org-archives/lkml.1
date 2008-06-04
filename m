Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbYFDUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbYFDUDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbYFDUDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:03:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbYFDUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:03:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=kshVi3c0T6WIsAncPeLOlgQCxnQ6a4BBD7SYmu0tUHu/S3J2JFQBmHC3c1leJIliX
	TuAfZQfMokPXWppOl9QvA==
Date: Wed, 4 Jun 2008 13:02:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: menage@google.com, miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and mems_allowed
 after CPU/NODE offline/online
In-Reply-To: <20080604144221.de09b709.pj@sgi.com>
Message-ID: <alpine.DEB.1.10.0806041249390.23189@chino.kir.corp.google.com>
References: <4845F864.8060102@cn.fujitsu.com> <6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com> <6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com> <20080604122227.a092e70e.pj@sgi.com> <alpine.DEB.1.10.0806041149560.21323@chino.kir.corp.google.com>
 <20080604142540.6fa2bcc3.pj@sgi.com> <alpine.DEB.1.10.0806041232190.22192@chino.kir.corp.google.com> <20080604144221.de09b709.pj@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Paul Jackson wrote:

> How about also adding this check (NULL mm and struct subset cpus)
> to sched_setaffinity?
> 
> Granted, this pair of checks, in cpusets and sched_setaffinity,
> is getting to be a little more work than the PF_* flag.
> 

Yes, an alterative to the PF_CPU_BIND flag is to prevent calls to 
set_cpus_allowed() for kthreads that should not change affinity.

> I guess one question would be how hard we want to work to avoid
> consuming another PF_* flag.  I thought they were scarce, but I
> might be wrong.
> 

I think we both agree that in terms of the code itself, adding the flag 
and doing the check in set_cpus_allowed() is the optimal solution.  It can 
simply return -EINVAL for PF_CPU_BIND threads and the threads don't get 
moved.

It's debatable whether allocating an additional PF_* flag for this purpose 
is worthwhile.

I usually don't advocate against adding such bits that have a clear and 
defined purpose for the sole reason that perhaps later we will need 
additional bits that can't be worked around so easily as this one.  It's 
helpful to be conservative in allocating new flags but not at the expense 
of the code itself, especially when loopholes can easily be introduced 
that would have been otherwise prevented.

So I'll repost the patch and see where it goes.

		David
