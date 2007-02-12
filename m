Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbXBLFoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbXBLFoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXBLFoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:44:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:57387 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbXBLFoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lag0Eh+rZ10Buoh3zjgpCvFV6a2TtOUtCOACTYnsNr4xRlVzpC/bmoobU22vLNdA8CGAaJIbnGjBn566MDGsbpbxWfeDzSM/FQca9LI3y6lNsDzLosuKBiOJTTAe9Gd1cWd4XAM6GuBk9O3ZmsUIv2k7l+2EO6ElK2sGn8QQWb8=
Message-ID: <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
Date: Mon, 12 Feb 2007 16:44:22 +1100
From: "Con Kolivas" <kernel@kolivas.org>
To: "Vassili Karpov" <av1474@comtv.ru>
Subject: Re: CPU load
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070212T063225-663@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20070212T063225-663@post.gmane.org>
X-Google-Sender-Auth: 6c06800b3f352215
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/07, Vassili Karpov <av1474@comtv.ru> wrote:
> Hello,
>
> How does the kernel calculates the value it places in `/proc/stat' at
> 4th position (i.e. "idle: twiddling thumbs")?
>
> For background information as to why this question arose in the first
> place read on.
>
> While writing the code dealing with video acquisition/processing at
> work noticed that what top(1) (and every other tool that uses
> `/proc/stat' or `/proc/uptime') shows some very strange results.
>
> Top claimed that the system running one version of the code[A] is
> idling more often than the code[B] doing the same thing but more
> cleverly. After some head scratching one of my colleagues suggested a
> simple test that was implemented in a few minutes.
>
> The test consisted of a counter that incremented in an endless loop
> also after certain period of time had elapsed it printed the value of
> the counter.  Running this test (with priority set to the lowest
> possible level) with code[A] and code[B] confirmed that code[B] is
> indeed faster than code[A], in a sense that the test made more forward
> progress while code[B] is running.
>
> Hard-coding some things (i.e. the value of the counter after counting
> for the duration of one period on completely idle system) we extended
> the test to show the percentage of CPU that was utilized. This never
> matched the value that top presented us with.
>
> Later small kernel module was developed that tried to time how much
> time is spent in the idle handler inside the kernel and exported this
> information to the user-space. The results were consistent with our
> expectations and the output of the test utility.
>
> Two more points.
>
> a. In the past (again video processing context) i have witnessed
>    `/proc/stat' claiming that CPU utilization is 0% for, say, 20
>    seconds followed by 5 seconds of 30% load, and then the cycle
>    repeated. According to the methods outlined above the load is
>    always at 30%.
>
> b. In my personal experience difference between `/proc/stat' and
>    "reality" can easily reach 40% (think i saw even more than that)
>
> The module and graphical application that uses it, along with some
> short README and a link to Usenet article dealing with the same
> subject is available at:
> http://www.boblycat.org/~malc/apc

The kernel looks at what is using cpu _only_ during the timer
interrupt. Which means if your HZ is 1000 it looks at what is running
at precisely the moment those 1000 timer ticks occur. It is
theoretically possible using this measurement system to use >99% cpu
and record 0 usage if you time your cpu usage properly. It gets even
more inaccurate at lower HZ values for the same reason.

--
-ck
