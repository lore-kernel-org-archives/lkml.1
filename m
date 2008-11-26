Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbYKZQCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbYKZQCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYKZQCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:02:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:63717 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbYKZQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=wTKtg+mzYZ7+5NLZ2wHgVDyDf7E8xriHl3gbshrMlEzzZZ8Ox2JS/2CrSINn8z/qFX
         7q/3FoolQAj7WwAsjbo7SvJag/0rUDWP/NxTSbvxykHedoLhvTiZyZLeICKPtJ43wHv+
         TjKXMz2GrgKPm4fQv9wwyXZwrphXmdxFL9NBo=
Message-ID: <7c86c4470811260802x13df92b4wb40922f199691161@mail.gmail.com>
Date: Wed, 26 Nov 2008 17:02:15 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 06/24] perfmon: generic x86 definitions (x86)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <7c86c4470811260750n4e6737c7h4518d89269f59ecb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>
	 <alpine.LFD.2.00.0811261440330.3325@localhost.localdomain>
	 <7c86c4470811260619y5c4c788er61c8704a5c62d17e@mail.gmail.com>
	 <alpine.LFD.2.00.0811261628290.3325@localhost.localdomain>
	 <7c86c4470811260750n4e6737c7h4518d89269f59ecb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wed, Nov 26, 2008 at 4:50 PM, stephane eranian
<eranian@googlemail.com> wrote:
>>>   2- the monitoring had the last reference to the file descriptor. In
>>> that case, we have a
>>>      perfmon context attached to a thread but no mean to get to it
>>> from userland. This is
>>>      the case where we declare the context as ZOMBIE.
>>>
>>>      I think Andi confused it with the meaning of ZOMBIE for the
>>> process. In this situation,
>>>      we want to cleanup the context and make sure monitoring is stopped.
>>>
>>>      That has to be done by the monitored thread. The issue is that
>>> the thread may notice
>>>      the context is ZOMBIE during context switch in. At this level, we
>>> run with interrupts
>>>      disabled, and it is not possible to free certain resources. So
>>> instead, we set the TIF
>>>      flag, and let the thread clean things up at a much higher level
>>> in the kernel execution
>>>      somewhere where we know we can safely call certain kernel APIs, e.g, kfree.
>>
>> There is no harm, when the context is kept around, right ?
>>
>
> Well, there are possibly PMU interrupts. If the monitored thread is
> active on the CPU
> by the time the tool dies, then it will keep on running with
> monitoring on, until it is
> context switched out or dies.
>
> With the approach currently implemented, the TIF bit will be set and
> as soon as the thread
> leaves the kernel for any reason,  it will execute the cleanup
> function which will stop
> monitoring and free the context.
>
To follow-up on that, worst case scenario is you get one more PMU interrupt.
The interrupt handler will notice the ZOMBIE state and will not reactivate
monitoring. The context will remain, but there will be no further cost to the
context switch because nothing will be saved or restored anymore.
