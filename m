Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZBRN6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZBRN6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZBRN6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:58:02 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:52793 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZBRN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <200902182227.14686.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <200902182227.14686.rusty@rustcorp.com.au>
Date: Wed, 18 Feb 2009 14:57:58 +0100
Message-ID: <ac3eb2510902180557p3b65fad5i933eed9d3e3d0b3b@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 12:57, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wednesday 18 February 2009 19:45:21 Kay Sievers wrote:

>> The current load_module() wraps ~400 lines of pretty heavy code in
>> stop_machine(), if we could possibly make that window smaller, so that
>> multiple instances could prepare some of the work in parallel, and
>> only a fraction of the current work would need to be serialized?
>
> Module load doesn't use stop_machine (on non-error).

I see, right. It's only the mutex serializing all module loading work.

> I'm not sure where the code is spending time.  We could shuffle things around
> so most of load_module doesn't run under the lock, but before that can you tell
> me if we still lose 2-3 seconds on a UP kernel?

I tried only my dual core laptop with my "small" kernel and 50
modules, not the crazy distro setup.

I've added stuff like:
   ktime_t in, delta;
   unsigned long long duration;

   in = ktime_get();

   ...

   delta = ktime_sub(ktime_get(), in);
   duration = (unsigned long long) delta.tv64 >> 10;
   printk("XXX: loading %p (%Ld usecs)\n", umod, duration);

across init_module() and some modules wait for 200-500 milliseconds to
get the lock released, some larger modules spend 50 milliseconds in
load_module(), many of them around 20 milliseconds.

> If so, it's not locking, I'd guess it's probably modprobe userspace and reading in
> the modules from disk, not sys_init_module at all.

Bootcharts suggest that it's not I/O bound. We also see this on fast
SSDs and with pre-loading files into RAM. Older modprobe versions did
some heavy fnmatch() over an insanely large distro module.alias file,
which was very CPU expensive, but that got changed recently.

Thanks,
Kay
