Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYKYL4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYKYL4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYKYLzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:55:52 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:65371 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYKYLzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:55:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oE8aPoAVWRERcwXomLY1Vu4TU7ApA32vlj6n6MlD2sL9X4ZL0kQsBSGuUVhcwE0ZFe
         9R8Slv+Fwc3ufA6hkNsXKiMXauo/+Aub4+A/m3cuqM+/Cn2nzpNU1H4HzM1/bxOyvTcL
         l6Sf+YyFrCStkRGrYUDyf7uc0Czs29McK6tbE=
Message-ID: <c62985530811250355r6e1510fdv1a63ef89e6c06c94@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:55:48 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081124232720.59312c0d@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	 <20081123212430.4f6700e9@daedalus.pq.iki.fi>
	 <20081123193413.GB2794@elte.hu>
	 <20081124221849.33c91bcf@daedalus.pq.iki.fi>
	 <c62985530811241230x601a27e1w504b0564b9513a13@mail.gmail.com>
	 <20081124232720.59312c0d@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Pekka Paalanen <pq@iki.fi>:
> On Mon, 24 Nov 2008 21:30:24 +0100
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
>
>> 2008/11/24 Pekka Paalanen <pq@iki.fi>:
>> >
>> > Oh right, the busylooping bug when echoing into trace_marker,
>> > I already forgot about that, since I couldn't reproduce it.
>> > I guess there's nothing to do, until someone finds a way to
>> > reproduce it.
>>
>>
>> Hi Pekka.
>>
>> Are you talking about this old bug that broke the pipe?
>> If so, you fixed it yourself partially with a patch that corrected
>> tracing_read_pipe.
>> Another origin was the none tracer that set tracer_enabled to 0.
>> But i has been fixed with the nop tracer.
>>
>> Perhaps you are talking of something else?
>
> Yeah, I'm talking about the shell spinning 90% in kernel and 10% in
> user, I tried to explain it in the part you left out from the quote.
> That is, doing 'echo foo > trace_marker' makes the shell/echo spin.
> And this doesn't seem to be deterministic, or the exact triggering
> sequence is too complex. I didn't notice any other adverse effects
> than the shell getting stuck.
>
> Maybe a corner case related to having only a single page in the
> ring buffer... nah, more likely something unexpected under
> trace_marker callbacks. Returning zero instead of error on
> write(2) maybe... something that makes 'echo' retry again and
> again, never succeeding or really failing.
>
> --
> Pekka Paalanen
> http://www.iki.fi/pq/
>


Perhaps that:

int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
{
     ......
     if (tracing_disabled)
		return 0;
