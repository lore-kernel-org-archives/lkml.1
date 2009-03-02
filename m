Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZCBOdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZCBOdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZCBOck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:32:40 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:51561 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZCBOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bap6h+XLPR7Xo+1eIRprm8rNSrPHhZxAzU9USL3UQqUoF6o0f5wa5EJHPqjOiO5wqJ
         WtEesfZy1jr/ofEI2EbxY4f/Z1CAt7gVSLlv/O7rY5CQ1BNHWQyvXgnKib5MqG+anmqj
         o+im9lKAglQkHYraTFhoh9GEB3u/4fdUShMmA=
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1235216636.7025.1023.camel@andreas-laptop>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 15:32:33 +0100
Message-Id: <1236004353.10055.49.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have finished testing parallel module loading. It looks like a small
kernel with a minimal initramfs and running several instances of insmod
or modprobe in parallel has the best complexity to performance ratio.

Testing shows that a megamodule is slightly slower than parallel
insmods, so it's not really an option anymore.

A monolithic kernel with parallelized initcalls is better - about 200 ms
faster than parallel insmods on my test system. However, it comes with a
fairly large set of changes:

* First, you need a 200-line patch in init/main.c (do_initcalls() and
friends)

* Then the built-in module dependencies must be calculated properly, eg
with a modified depmod, and added to the build process.

* Finally "soft" dependencies, i.e dependencies that are not implied by
symbol use, have to be formalized and moved into the kernel somehow.
Right now they're only defined in "install" commands in modprobe.conf.

So, what do you think, should I keep going? IMHO, the slower userspace
implementation is acceptable since it's so much simpler.

Thanks,
Andreas

------------------------

Here are the test results:

Setup:

HP Pavillion DV6300 laptop. AMD Turion TL-56 @ 1.8GHz CPU. In a
benchmark at Tomshardware, the CPU have scores similar to an Intel core
duo T2300.
http://www.tomshardware.com/reviews/dual-core-notebook-cpus-explored,1553-11.html

Results:

   Configuration                    |   T    | stddev (n = 10)
------------------------------------+--------+--------
[1] Serial monolithic kernel        | 3.08 s |  0.08
[2] Megamodule, serial initcalls    | 3.26 s |  0.05
[3] Megamodule, parallel initcalls  | 2.27 s |  0.01
[4] Parallel insmods w/ mutex patch | 2.20 s |  0.01 <- best choice
[5] Parallel monolithic kernel      | 2.02 s |       <- estimate only

T = Time from kernel startup until all module initcalls have
    executed, i.e when init can mount the root filesystem.

[1] Monolithic 2.6.29-rc5 with fastboot cmdline option. No initramfs.

[2] 94 modules linked into one megamodule. The megamodule executed
    module initcalls sequentially. All files were on a minimal
    initramfs. The kernel had fastboot enabled.

[3] 94 modules inserted with custom insmod, in parallel.
    (Dependencies were accounted for.) Minimal initramfs, fastboot.

[4] Like [2], but initcalls ran in parallel.
    (Dependencies were accounted for.) Minimal initramfs, fastboot.
    Rusty's module loader mutex-patch is applied.

[5] This is an estimation based on how much faster [3] would be if
    load_module() took no time at all. T5 = T3 - (T2 - T1).
    That is, I assume T2-T1 is the time spent in load_module().

Note:

By minimal initramfs, I mean one such that it, plus small kernel, is
roughly the same size as the equivalent monolithic kernel. The only
executable on it is init, written in C. There are no shell scripts,
busybox, progress bars or unused modules.


