Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYKZPpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYKZPpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKZPpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:45:00 -0500
Received: from www.tglx.de ([62.245.132.106]:45275 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYKZPo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:44:59 -0500
Date: Wed, 26 Nov 2008 16:44:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
Subject: Re: [patch 06/24] perfmon: generic x86 definitions (x86)
In-Reply-To: <7c86c4470811260619y5c4c788er61c8704a5c62d17e@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811261628290.3325@localhost.localdomain>
References: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>  <alpine.LFD.2.00.0811261440330.3325@localhost.localdomain> <7c86c4470811260619y5c4c788er61c8704a5c62d17e@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Wed, 26 Nov 2008, stephane eranian wrote:
> The goal of the TIF flag is to force the thread to go do some extra work on
> kernel exit. There are two situations where this is necessary, there is one
> in the current patchset, the other is related to sampling (not yet provided).
> 
> With per-thread monitoring, a tool is monitoring another thread, possibly in
> another process. The monitored process and the tool may not be parent
> of each other.
> 
> What happens if the tool dies BEFORE it can cleanly close the
> monitoring session?
> 
> There are 2 scenarios:
>   1- the monitored process also had the perfmon file descriptor open,
> e.g., inherited
>      on fork/exec. In that case the monitored thread will keep on
> running to completion
>      with an attached perfmon context.

So no TIF work for this case, right ?
 
>   2- the monitoring had the last reference to the file descriptor. In
> that case, we have a
>      perfmon context attached to a thread but no mean to get to it
> from userland. This is
>      the case where we declare the context as ZOMBIE.
> 
>      I think Andi confused it with the meaning of ZOMBIE for the
> process. In this situation,
>      we want to cleanup the context and make sure monitoring is stopped.
>
>      That has to be done by the monitored thread. The issue is that
> the thread may notice
>      the context is ZOMBIE during context switch in. At this level, we
> run with interrupts
>      disabled, and it is not possible to free certain resources. So
> instead, we set the TIF
>      flag, and let the thread clean things up at a much higher level
> in the kernel execution
>      somewhere where we know we can safely call certain kernel APIs, e.g, kfree.

There is no harm, when the context is kept around, right ?
 
> Another possible solution (which is not implemented):
>      - just let the context attached and run the thread to completion.
> If another tool wants to
>        attach to the same thread, it will detect there is already a
> context attached, and that it is
>        marked ZOMBIE, so it will clean it up. This is a lazy cleanup approach.

Looks like ctx is a couple of hundred bytes, so just keep it around
until thread exit time or until the other tool does the cleanup
possibly by recycling the context.

Thanks,

	tglx

