Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYFDTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYFDTBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYFDTBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:01:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53977 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbYFDTBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:01:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ICfmfXiMwkRiJDphtxX9eSseXghYYAKcD74yQcHildouaHIuu/xKfqCuFAv8LfT75
	FL/hoWDTAYr17bt8ibqNQ==
Date: Wed, 4 Jun 2008 12:01:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Paul Menage <menage@google.com>, miaox@cn.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and mems_allowed
 after CPU/NODE offline/online
In-Reply-To: <20080604122227.a092e70e.pj@sgi.com>
Message-ID: <alpine.DEB.1.10.0806041149560.21323@chino.kir.corp.google.com>
References: <4845F864.8060102@cn.fujitsu.com> <6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com> <6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com> <20080604122227.a092e70e.pj@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Paul Jackson wrote:

> Do we need a new PF_* flag for this?  Perhaps one can test for this
> by examining the currently available properties of tasks.  Would it
> be sufficient to look for kernel threads (NULL mm_struct) whose
> cpus_allowed is a strict subset of the online CPUs?
> 

That would only identify kthreads that have been created with a subsequent 
call to set_cpus_allowed() or kthread_bind().

The PF_CPU_BOUND change targets only the latter since there are kthreads, 
such as kstopmachine, that can continue to manipulate their cpus_allowed 
during their lifetime.

Other kthreads such as the scheduler migration thread and soft lockup 
watchdog thread, however, always stay bound to a single cpu by use of 
kthread_bind().  These are the tasks that get the PF_CPU_BOUND flag and 
cannot be rebound via set_cpus_allowed() because of their negative 
effects.

		David
