Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYKMKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYKMKCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYKMKCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:02:07 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:61228 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKMKCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VWLyg4qFDZNgq9BaHvvgLKchPx3eiykDA2UuKJg3WEcoJvz5dFrAU6hUUmK1+KSnLu
         E4HnwnN9oM0OlqrFwsQRiL5Isiwy2S8SKeE9qTinBGOAbGTBTGVkWwTC01SgpHfToPOl
         1ftzDbbq251kc8xnVQGEkJnyIasW26Ryp3FsE=
Message-ID: <c62985530811130202r7721c927w58beb34ec92c34f7@mail.gmail.com>
Date: Thu, 13 Nov 2008 11:02:04 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return by registers
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081113091454.GH25479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>
	 <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
	 <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
	 <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
	 <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
	 <20081113085949.GG25479@elte.hu> <20081113091454.GH25479@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
> on a related note.
>
> Frederic, it would be nice to fine-tune the tracer output to convey
> the callgraph information more clearly. Here's a mockup of a good
> default output:
>
>  getnstimeofday() {
>   set_normalized_timespec() {
>    clocksource_read() {
>     acpi_pm_read()                     ( 1547 ns)
>    } clocksource_read()                ( 1951 ns)
>   } set_normalized_timespec()          ( 2200 ns)
>  } getnstimeofday()                    ( 2354 ns)
>
>  [...]


Oh yes. That would be fine. I thought such thing would be better to do
in post-processing.
But I wonder a bit about this, I explain why below.

> Such output would be _very_ nice and intuitive to have. Developers
> would love it instantly. Note its C-ish syntax - that is obviously the
> easiest to parse for kernel developers.


That's right, it's much more better for the eyes. I didn't want to
output such a disposition from the kernel
because I thought that would result in too much strings work from
kernel-space. But actually, as you suggest,
 if I append a depth field in the trace that could be easy and not so
costly. I just have a last thought about
post-processing parsing. Would it make it harder for that?
Why not a flag that could be set through iter_ctrl (which has changed
its name yesterday) and that could let
the user to choose its output? That's where I renew my proposition to
make the tracers able to propose custom
flags for this file with a new callback such as tracer_ctrl, or tracer_opt.

After all perhaps an indented output would be better to build a tree
of calls from parsing. And the current
output would be better to build stats about return values and/or cost.

> and note how natural it will be in the future to embellish certain
> function calls in the above trace, for example with function
> arguments:
>
>    clocksource_read("acpi_pm") {
>
> i'd suggest to hide the offset bit of the ksym (like the mockup does
> it - unless a tracing_option is set for more verbose symbol output).
> For these traces it's almost always useless and the context tells us
> in 99% of the cases where a function got called.

I think it remains useful when a function calls one other in
differents code paths.
But as you say, why not set it through a flag.

> Easiest would be to add a depth field to the trace entry as well, to
> make sure we get the right depth in the end, even if we somehow mix up
> the trace entries.


Yeah, that's good! I will just have to output "\t" * depth to have the
correct indentation.

> We could also trace function entry and exit separately, and
> post-process the call stack (and the cost) during trace output
> formatting - not during tracing.
>
> Hm?


Yes I thought about that. But with a bit post-processing, we could
retrieve the result of the normal function tracing through
the "return tracing" traces... I guess...
