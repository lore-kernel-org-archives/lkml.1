Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZBULoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZBULoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 06:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZBULoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 06:44:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:31443 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZBULn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 06:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T1HDTkG9FEgQlvXfHEwgN5yq60mFJYfApfJjRD9KGvkWGxpbNfi6n9BGtM4gTJj4hd
         kiMr5YtvHeX6WVxHgeQpQ6Dorrnd9lHw8cHWPqK+dtEQB2JPgeV3TPRbEktniBOiqv1T
         9Zr4y4g9wmX7d51umVnzFCw8ZfmglF8UMUOo0=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Feb 2009 12:43:56 +0100
Message-Id: <1235216636.7025.1023.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 02:55 +0100, Kay Sievers wrote:
> On Fri, Feb 20, 2009 at 01:37, Andreas Robinson <andr345@gmail.com> wrote:

[...]

> > So, what's missing or been done wrong here? I expected the difference
> > between monolithic and modular to be greater to be honest.
> 
> How do you compare the monolithic kernel? What are the 6.27 seconds
> here? The time to boot into /sbin/init without any module load?

It is a wall-time comparison testing how long it takes until all drivers
are initialized.

The last driver to be initialized is a dummy module that merely prints a
timestamp in its init function. That's where the 6.27 seconds come from.

So, the initramfs should have no impact on the monolithic case as it is
not accessed until after the initcalls.

> I wouldn't be surprised if you just wait in the kernel for some
> hardware, driven by a built-in module, to init. Do you use current git
> and the "fastboot" commandline option?

Current git, yes. Fastboot, no, I didn't know it existed! Adding
fastboot, there are dramatic improvements; monolithic boot time is now
3.08 seconds, megamodule is 3.37 and insmod list 3.85. So you are right
to not be surprised. :)

> I don't think the megamodule will help us much, unless we change the
> kernel to parallelize something here, or save some other overhead. It
> should not be different from the serial insmods, if the data is not
> sprinkled over the disk, which an initramfs isn't. And the
> fragmentation problem should not be solved with a mega-module. :)
> 
> The general problem is that todays distros start like 100 modprobes in
> 2 seconds, which does not really compare to a sequential insmod test.
> 
> I'm pretty sure, for real-world numbers we need to load them in
> parallel, and look at the kernel side, if we can minimize the locked
> code area, so we can do as much as possible in parallel.
> 
> Only if that is addressed, I think, we can get useful numbers how much
> time we really spend in in-kernel linking and can start evaluating if
> pre-linking modules would make sense, or not.

Understood. I will parallelize things, add Rusty's patch and see where
we end up!

Cheers,
Andreas

> 
> Thanks,
> Kay

