Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYKBQwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYKBQwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYKBQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:52:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:62957 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbYKBQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:52:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kFm9AK1oOWF02WQlxFEeVm/jJcN9f+czXHMNVtXcvnVgrP+JGeRQXeoitGc4v22yH4
         Nm9Pb2YDauiCVTUn+rv0PapZC3Bey7Rd6p0bZGeFhXm2u9xhmThFHX3Io3NQMev5tHft
         ulukVa5gDjc4+6uy+ZGD2Aknkc42venD5C5Y4=
Message-ID: <c62985530811020852q1807ddc7ide08bac3630d9ff@mail.gmail.com>
Date: Sun, 2 Nov 2008 17:52:02 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: Tracing framework regressions in 2.6.28-rc2
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081102183534.1bdc6779@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081102183534.1bdc6779@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka!

2008/11/2 Pekka Paalanen <pq@iki.fi>:
> Hi all,
>
> I finally had the time to check how mmiotrace works in 2.6.28-rc2.
> On the first try I didn't find any mmiotrace problems, I traced the
> Nouveau DRM driver just fine, but the file /debug/tracing/current_tracer
> has started to misbehave.
>
> I think it is due to this patch:
>
> commit c2931e05ec5965597cbfb79ad332d4a29aeceb23
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Sat Oct 4 22:04:44 2008 +0200
>
>    ftrace: return an error when setting a nonexistent tracer
>
>    When one try to set a nonexistent tracer, no error is returned
>    as if the name of the tracer was correct.
>    We should return -EINVAL.
>
>    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>    Acked-by: Steven Rostedt <srostedt@redhat.com>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> Now, whatever I echo to current_tracer, I get EINVAL.
> What's more confusing, if I do
> echo mmiotrace > /debug/tracing/current_tracer
> then I see the EINVAL error *and* mmiotrace is activated!
>
> The problem is with newlines, with 'echo -n' it works as it should.
>
> I'm starting to think the patch itself is fine, but it exposes an
> assumption in the write fop: a single write call contains all the
> data. I suspect there are actually two write calls in case of 'echo':
> one with 'mmiotrace' and one with '\n'. I don't see how else I could
> get the behaviour I get.


A patch has been applied for this in the mainline, the issue will be
fixed for rc3:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=60063a66236c15f5613f91390631e06718689782

> Another issue is the disappeared 'none' pseudo-tracer, which seems
> to be replaced with the 'nop' real tracer. Is using 'nop' now equivalent
> to the previous 'none' tracer?

Yes. A nop tracer has been released to have a kind of pattern to write
new tracers, and to have a tracer that does
nothing but is able to show user marks for example.
Since it does nothing, we replaced the none tracer by this one.

> I mean, when the 'nop' tracer is current, are all tracing calls no-ops and
> nothing will ever get into the ring buffer?
> I have to update the mmiotrace documentation about disabling tracing.

Hhm not really, you can receive pseudo entries like user marks. But
you can disable all the tracing by setting 0 to
tracing_enabled.
