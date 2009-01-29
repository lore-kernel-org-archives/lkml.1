Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZA2Nkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZA2Nkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZA2Nkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:40:32 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:50327 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZA2Nkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=blhTl40pSKeW+ok9XXxkjBhwdwBIl/oY4fHygjIompczO+2QUeQ8oe7eib6UTFO+j2
         fED3DcloQsJvwx2FT6K7SkPQ1J+eyXCFaOS/QrqwtwiXatBzU3daRe9eaIz5iPOTn2q9
         vGN234EAjQGtejk1SCMT2Cfm7zO75pp8rIadA=
MIME-Version: 1.0
In-Reply-To: <c62985530901290539r38b5fb7fr32132782e69356c7@mail.gmail.com>
References: <497F69A4.2070007@intel.com>
	 <20090127205137.GD15877@ghostprotocols.net>
	 <20090127211452.GA5850@nowhere> <4980D6A0.9030004@intel.com>
	 <20090129004510.GH627@ghostprotocols.net>
	 <c62985530901290539r38b5fb7fr32132782e69356c7@mail.gmail.com>
Date: Thu, 29 Jan 2009 14:40:28 +0100
Message-ID: <c62985530901290540i4a87c514nc7d48268b55d2bd9@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "srostedt@redhat.com" <srostedt@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "Kok, Auke" <auke@foo-projects.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2009/1/29 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
>> hey, hey, your patch just illustrated that we need a subtype facility.
>>
>> I'm (as all the other people in some shape or form involved in pushing
>> some sort of common tracing infrastructure into the kernel, I guess)
>> excited about more developers using what is being put in place :-)
>
>
> Indeed :-)
>
> About these subtypes. I've thought about what can be intuitive for
> developers who
> will use it.
>
> I think the struct trace_event can be reused by just adding a subtype
> event inside:
>
> + int (*find_subtype_func) (struct trace_iterator *);


Sorry: forgot the typedef there...

>
>  struct trace_event {
>        struct hlist_node       node;
>        int                     type;
>        trace_print_func        trace;
>        trace_print_func        latency_trace;
>        trace_print_func        raw;
>        trace_print_func        hex;
>        trace_print_func        binary;
> +      struct trace_event *subevent_array;
> +      find_subtype_func find_subtype;
>  };
>
> And then I shall implement an event internal hlist for each global event.
> All a tracer developer just have to do is:
>
> _ implement a general trace_event for his global event type
> _ implement each trace subevent as an array, one will have to define
> its own set of values for the types, they will
>  not conflict with those used by global event types since they are
> isolated and depend on one global event type.
> _ implement find_subtype callback. When a new trace has to be printed,
> this callback is called to find the subtype
>  value corresponding to a trace. If the tracer returns a positive
> value, the matching subevent is searched on the subevent_array
>  and the appropriate trace_print_func is called.
>  Otherwise if find_subtype is NULL or returns -EINVAL, then the
> appropriate trace_print_func of the current global event is called, as
>  usual.
>
> We can even make it recursive, letting one crazy tracer beeing able to
> have subtypes of subtypes :-)
>
> Hm? If you are ok, I shall start it.
>
>
>>> In all it was not productive to write a giant trace facility just to get
>>> sreadahead one tracer type. Now that the code works and the benefit is proven, I'm
>>> happy to see if we can work on making a decent long-term non-specialistic solution.
>>
>> That is the spirit!
>>
>> - Arnaldo
>>
>
