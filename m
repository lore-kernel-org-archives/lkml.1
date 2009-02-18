Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZBRL51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZBRL51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 06:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZBRL5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 06:57:19 -0500
Received: from ozlabs.org ([203.10.76.45]:56046 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZBRL5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 06:57:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Wed, 18 Feb 2009 22:27:14 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <200902181528.29697.rusty@rustcorp.com.au> <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
In-Reply-To: <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182227.14686.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 19:45:21 Kay Sievers wrote:
> On Wed, Feb 18, 2009 at 05:58, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Tuesday 17 February 2009 22:23:25 Kay Sievers wrote:
> >> Monolithic versus modular kernels usually
> >> make about 2+ seconds difference on a recent laptop.
> >
> > Thanks for the fact injection.  How about a megamodule then?
> 
> Sounds interesting. The ability to load multiple modules with a single
> call may help, if such a call could be handled faster than individual
> calls. Modprobe's modules added by dependencies of the requested
> module, or modprobe -a could probably use such a facility.

Naah, just create the megamodule in userspace.  It's not terribly hard:
you create a new init which calls all the individual inits, and rename
the module.  You don't supply an "exit" so it can't be unloaded, and for
bonus points remove the .exit sections which will never be used.

I'm handwaving a little, but it would get you all the benefits with no
kernel changes.

Andreas is definitely capable of creating such a thing: it's easier than
what he did with linking in modules!

> The current load_module() wraps ~400 lines of pretty heavy code in
> stop_machine(), if we could possibly make that window smaller, so that
> multiple instances could prepare some of the work in parallel, and
> only a fraction of the current work would need to be serialized?

Module load doesn't use stop_machine (on non-error).  I'm not sure where the code is spending time.  We could shuffle things around so most of load_module doesn't run under the lock, but before that can you tell me if we still lose 2-3 seconds on a UP kernel?

If so, it's not locking, I'd guess it's probably modprobe userspace and reading in the modules from disk, not sys_init_module at all.

Cheers,
Rusty.
