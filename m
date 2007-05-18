Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbXERPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbXERPXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXERPXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:23:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:25564 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbXERPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XHqGQ87gVR6iZHe8Efeo/PE2SOj1m0G06oEkVROLvpCuq+WLguxlM5Mu9/pPIPPsbcb3qTKWCFXN7P7HJxdqGvWqVJrL/wSW4VPbsVhTHgaZsOsPbq5SbWz4bxiQ7Idlq2TWfhHIZqDKhHAPZlEDPPnCgvH+kUIPWnL0LYgk/zA=
Message-ID: <b3ece790705180823s3cb5c093j709d8d299f397892@mail.gmail.com>
Date: Fri, 18 May 2007 08:23:35 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: mcelog tolerant level cleanup
Cc: "Tim Hockin" <thockin@google.com>, vojtech@suse.cz, akpm@google.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705181435.01562.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070516202956.GA27184@google.com> <200705181435.01562.ak@suse.de>
X-Google-Sender-Auth: e26411adb0e99256
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Andi Kleen <ak@suse.de> wrote:

> >      * If RIPV is set it is not safe to restart, so set the 'no way out'
> >        flag rather than the 'kill it' flag.
>
> Why? It is not PCC. We cannot return of course, but killing isn't returning.

My understanding is that the absence of RIPV indicates that it is not
safe to restart, period.  Not that the running *task* is not safe* but
that the IP on the stack is not valid to restart at all.

> >      * Don't panic() on correctable MCEs.
>
> The idea behind this was that if you get an exception it is always a bit risky
> because there are a few potential deadlocks that cannot be avoided.
> And normally non UC is just polled which will never cause a panic.
> So I don't quite see the value of this change.

It will still always panic when tolerant == 0, and of course you're
right correctable errors would skip over the panic() path anyway.  I
can roll back the "<0" part, though I don't see the difference now :)

> > This patch also calls nonseekable_open() in mce_open (as suggested by akpm).
>
> That should be a separate patch

Andrew already sucked it into -mm - do you want me to break it out,
and re-submit?

> > +             0: always panic on uncorrected errors, log corrected errors
> > +             1: panic or SIGBUS on uncorrected errors, log corrected errors
> > +             2: SIGBUS or log uncorrected errors, log corrected errors
>
> Just saying SIGBUS is misleading because it isn't a catchable
> signal.

should I change that to "kill" ?

> Why did you remove the idle special case?

Because once the other tolerant rules are clarified, it's redundant
for tolerant < 2, and I think it's a bad special case for tolerant ==
2, and it's definately wrong for tolerant == 3.

Shall I re-roll?
