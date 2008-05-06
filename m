Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbYEFGjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbYEFGjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYEFGjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:39:25 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:40834 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYEFGjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FqtS4gIhqaAblFi4Or0fgrwoprgycJfC0ACbYZdRH0iYvutLHYpX0Yp/FlQcXkx9puTbJ8dVlcMupFuj4Z50q7URYLAbs6avMGdl1cwMw4Svx52n5xzLUWrCUP2DYNC0Gsg99n2LQaI1SDSxmU+H6/gjOoIhayA/mbgQzxlN/xM=
Message-ID: <7c86c4470805052339t3a15d470l5b5629b1252a5dc8@mail.gmail.com>
Date: Tue, 6 May 2008 08:39:23 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [patch] x86, ptrace: in-kernel BTS interface
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
In-Reply-To: <20080505230318.F3AF126FA20@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430135440.A359@sedona.ch.intel.com>
	 <20080503014342.3882226FA07@magilla.localdomain>
	 <029E5BE7F699594398CA44E3DDF5544401D11191@swsmsx413.ger.corp.intel.com>
	 <20080505230318.F3AF126FA20@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 6, 2008 at 1:03 AM, Roland McGrath <roland@redhat.com> wrote:
>  > Who should pay for this memory?
>  [...]
>
>  My first point about this is that it is not the ds.c layer's problem.
>  I don't have anything to offer vis a vis PEBS right now.  For BTS, the
>  buffer allocation has a lot to do with how we work out the multiplexing.
>
I would let the upper layer handle this. Perfmon2 takes care of this today.
But the consumer may be the kernel, so you could not charge this onto
the current/asking task.

>
>  > Given the vast memory consumption, I would only consider circular
>  > buffers. [...]
>
>  Firstly, this is not a decision for the ds.c layer.  It is

Exactly!


>  If both the PEBS code and the BTS code turn out to have similar needs,
>  nothing says they can't both call the same code for their buffer
>  allocation.  That's just not the ds.c layer's business if they do.
>
In Perfmon2, we want to keep control of the buffer allocation. Thus we want
to be able to pass the buffer base address and size, that's all. Perfmon2
does allow the buffer to be remapped to user level.

>
>  > The model was to allow a single owner of the BTS and PEBS configurations
>  > to prevent different users from overwriting their settings.
>  > The first task to make a ds_request() for BTS or PEBS, would own the
>  > respective configuration until it ds_release()s it.
>  > This is essentially a BTS/PEBS resource allocator.
>
>  The simple mutual exclusion is the right thing to have in the ds.c
>  layer--it's just that it should not be implicitly tied to calling task.

I agree. I think I have discussed this with Markus already because I
ran into some
issue when experimenting with ds.c for perfmon PEBS support.

>  > PEBS would still need something like that, though. I wonder whether a
>  > multiplexing model makes sense for PEBS, at all.

I am not sure I undertstand what you mean by multiplexing?
Are you talking about per-thread vs. system-wide?
Perfmon2 does support both modes incl. for PEBS, although in system-wide
mode, there is not enough information saved in the PEBS buffer to determine
which task generated the sample.

>
>  My discussion about multiplexing referred only to the BTS layer.  I have
>  not discussed PEBS at all, except that the DS layer should provide the
>  same trivially simple interface to control it.  For this discussion, I'm
>  assuming that PEBS is in the hands of perfmon2 and leaving it at that.
>

The interest for using ds for perfmon2 is:
    - hides the details about the DS layout (different from P4 to Intel Core)
    - ensures mutual exclusion on the DS/PEBS resource
    - manages DS save/restore on context switch

So it removes a lot of code.

But perfmon2 does not use:
    - buffer allocation
    - PEBS record abstraction
    - BTS (not yet)
