Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbYKCBRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbYKCBRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 20:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYKCBRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 20:17:37 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:49515 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYKCBRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 20:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sRcr9VsoE7UDMEZ2Rq74wL3yBpoxqMwCNE4PBldolKYY5EhME5S3aOH/2Ng39208I7
         2PH0WTlerldXencFMQ4EPeu53eL5+Sug7CNFNGmo5lHxM0+q+Sy0+kd7d7epToDvNp04
         v09o5oD6MQLG5D0RmDe2bU/dnz+Qw9X5VXYdI=
Message-ID: <c62985530811021717w169111dah4574efaf124707c2@mail.gmail.com>
Date: Mon, 3 Nov 2008 02:17:35 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490E3F73.1000405@gmail.com>
	 <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Steven Rostedt <rostedt@goodmis.org>:
> Frederic,
>
> Ingo has been very adamant about not using raw_spin_locks in the ring
> buffers. My original code did this, and he nacked it. The reason being
> (and he eventually convinced me) was that by using raw, we not only do not
> trace the locking, we also remove the lock checking. This code can easily
> produce deadlocks, so we do not want the lock checking removed.

Ok. I understand...

> The real fix is to find a way in your tracer to detect the recursion, and
> be able to prevent it. Like the atomic disables I use in ftrace. It does
> the same thing. It leaves the lockdep checking on its own locks, but can
> also detect if the lock checking caused it to recurse. When the recusion
> is detected, the tracer itself will not trace.

You mean this part in function_trace_call?

disabled = atomic_inc_return(&data->disabled);
if (likely(disabled == 1))
		trace_function(tr, data, ip, parent_ip, flags, pc);

atomic_dec(&data->disabled);

That's a good idea. Since it applies on one cpu_data specific and
preempt and irq are disabled, the function
tracer doesn't risk to loose a trace. I think I will apply the same method.

Thanks!

> [ I hope this makes sense, I'm writing this on 3 hours of sleep ]

Yes, don't worry :-)
