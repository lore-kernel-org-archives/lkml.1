Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbYJRWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYJRWe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYJRWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:34:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4948 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYJRWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gh5OPo28Y50HG3WNboeSsxMmIfA5QD0MPnYgF8kqUrS+60HvSqAq0qgzaqH2KfaX7c
         sJvM56MfFmpOlnsmgjzoeWgw8En8aDXj/1PK1ymeIxQssohwvJbXiVJmPVANKaRpJedb
         MIuyC+VfdhH+q8dO+SwHUZyJWSFz40ZR5GY+8=
Message-ID: <c62985530810181534l32d338fdp4fb84e8f3182878c@mail.gmail.com>
Date: Sun, 19 Oct 2008 00:34:16 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: [PATCH 4/5] tracing/fastboot: Add a time field on the sched_switch entry
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <48F91FE1.6030902@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F10A9D.3030705@gmail.com>
	 <alpine.DEB.1.10.0810111644440.19507@gandalf.stny.rr.com>
	 <c62985530810111358o10e33becw8ce9c83c46733f3b@mail.gmail.com>
	 <alpine.DEB.1.10.0810111947120.19507@gandalf.stny.rr.com>
	 <c62985530810120429u774c7eefm44bef7d8b4199115@mail.gmail.com>
	 <c62985530810130110r5ba73d04wec70e597abd48126@mail.gmail.com>
	 <48F91FE1.6030902@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Tim Bird <tim.bird@am.sony.com>:
> I may have lost context here, but what's the purpose of the
> extra timestamp again?  If it's just to have zero-based
> timestamps on the ultimate output, can't you just put a single
> special "start" timestamp in the trace log.  Then that can
> be subtraced from all tracer-generated stamps in post-processing.
> I'm not familiar enough with the tracer to know if the
> post-processing is done in kernel space.  But in any event
> you could use something like scripts/show_delta to get
> relative timestamps (in user space).  Right now, scripts/show_delta
> doesn't act like a filter - I'll have to look at that.

Actually the problem is not really to have a zero-based timestamp but I need
to have a timestamp which is the same than the one used by the boot tracer.

If the boot tracer had only to capture one time per entry, I would use
the internal
timestamp of the ring-buffer. But the boot tracer must capture two
times: the call
time of an initcall and the time it returns.

At the same time I want to know the schedule events that occur during
the initcalls
and then the latency they raise. For that I need to have the same
timestamp than the boot
tracer to have a consistent view of these schedule events inside the initcalls.

But you just gave me a new idea :-)
If I split the initcall in two parts: the call and the return, I will
be able to drop these
boot-tracer-specific timestamps and just use the ring-buffer timestamp used
when an entry is appended into the buffer.
And so I can use the usual sched_switch events whithout additional field.

Seems to me really better.

But there is one thing that changes with this new way. It seems that
the ring buffer's timestamp
is based on the sched-clock and so I guess that's why it doesn't start
when the cpu boot but some
times after.

Arjan would you agree with this new time capture system?
