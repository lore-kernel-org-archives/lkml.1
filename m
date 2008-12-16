Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759451AbYLPXrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbYLPXrZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYLPXqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:46:50 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:9699 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbYLPXqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v32zm0YfPSKx3sVKsBmmIiMi0An0Z57gh5W5z0JloEnnqgTZhJeTsSYnUdnySNmZic
         kyds5tYbDZ5gf5roalQc2TM5vIQwYKFQ9Qvujz7OS7YeXblRW7mG50RZ5NaLNTdCk/hE
         5Oz1y0PYIGjLzoTqPJKcXmPfSVr84kB/OacpY=
Message-ID: <c62985530812161546j69bef7bcm5c495feb1a9c5458@mail.gmail.com>
Date: Wed, 17 Dec 2008 00:46:46 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Cc: "Vladislav Bolkhovitin" <vst@vlnb.net>,
        "Steven Rostedt" <srostedt@redhat.com>,
        "Sam Ravnborg" <sam@ravnborg.org>, linux-scsi@vger.kernel.org,
        "James Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        "Mike Christie" <michaelc@cs.wisc.edu>,
        "Jeff Garzik" <jeff@garzik.org>, "Boaz Harrosh" <bharrosh@panasas.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
        "Bart Van Assche" <bart.vanassche@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
In-Reply-To: <20081216222203.GI14787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <49400ACD.3070502@vlnb.net> <49414DBE.6070801@vlnb.net>
	 <20081211210917.GB27010@uranus.ravnborg.org>
	 <4942BA85.3070408@vlnb.net>
	 <1229118607.24995.18.camel@localhost.localdomain>
	 <4943CAAB.4050008@vlnb.net>
	 <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
	 <20081216214926.GU14787@elte.hu>
	 <c62985530812161413j59fc0fdy31024a540bf0c197@mail.gmail.com>
	 <20081216222203.GI14787@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/16 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2008/12/16 Ingo Molnar <mingo@elte.hu>:
>> >
>> > * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>> >
>> >> > All the above functionality is almost what we need. The only thing
>> >> > left, which I forgot to mention, is possibility to log also functions
>> >> > return value on exit. This is what TRACE_EXIT_RES() in SCST does. Is
>> >> > it possible to add those?
>> >>
>> >> I want to add that on the function graph tracer. That can be done pretty
>> >> easily. The only problem comes with the type of the return value. Would
>> >> this tracer be supposed to always return a 64 bits value regardless of
>> >> the real typ of the value? There would be some pointless bytes on most
>> >> return values. I don't know how to proceed for this problem.
>> >
>> > Things like mov ...,%eax are zero-extend so they'll zap the high 32 bits.
>>
>>
>> That's right, but the problem occurs under 32 bits. The return values
>> for 64 bits are in eax and edx. And most of the time, the high part
>> (edx) will be junk.
>
> for wider types i'd suggest to just print the low bits. Most of the
> interesting return types fit into machine word.
>
>> > The real problem are byte return values generated via things like:
>> >
>> >   movb $1, %al
>> >
>> > those wont zero-extend, so you could get garbage in the output. One
>> > approach would be to try a quick hack just to see how common a problem
>> > this is.
>>
>>
>> Yes, I will try something.
>>
>> > We could extract the return type from the debuginfo, hash it in a
>> > read-mostly table and then look it up, but that seems complex both in
>> > terms of build overhead and in terms of runtime overhead.
>>
>> I thought about it too and as you say it's rather complex. And thinking
>> about non primitive types (like pid_t....) that would require a second
>> pass of analysis to retrieve the corresponding primitive...
>
> structure returns would be rather evil to handle, agreed.
>
> Unrelated:
>
> it would be really nice if we could extend ftrace to trace system calls
> and their parameters and return values. We used to have that in the
> latency-tracer in -rt, and it was rather useful. Controlled by a
> trace_option i guess - and blendable into any of the tracer outputs
> (function tracer most notably).
>
> Explicit calls in the entry.S files would be OK for this - but maybe we
> can get this via the tricky use of a TIF_ flags as well, to force the code
> into the ptrace callbacks and then divert it for ftrace's pleasure?
>
>        Ingo
>

I recently thought about making a syscalls tracer and only thought
about the tracepoints. But that could be better to
trace them and all the function they call with the function graph
tracer. I think about the "graph" one because time of execution
measure could be useful for the -rt development.

I think that putting new calls on entryxx.S would be an overload and
would overlap what already does ptrace on syscall entry/exit.
So I like the idea of using the ptrace callbacks by manipulating the TIF_ flags.

Yeah that's interesting. I will do that for 2.6.30 :-)
