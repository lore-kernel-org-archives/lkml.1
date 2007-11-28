Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXK1SMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXK1SMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXK1SMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:12:12 -0500
Received: from gw.goop.org ([64.81.55.164]:38935 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXK1SMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:12:10 -0500
Message-ID: <474DAF78.8040300@goop.org>
Date: Wed, 28 Nov 2007 10:12:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: "hwcap 0 nosegneg" doesnt work with paravirt_ops xen as of 2.6.23.9
References: <200711281829.25532.andres@anarazel.de>
In-Reply-To: <200711281829.25532.andres@anarazel.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Freund wrote:
> after converting a host from using a ubuntu patched 2.6.22 domU to using 
> 2.6.23 xen via paravirt_ops (no configuration change except devicename change 
> in fstab, and another getty running) ldconfig no longer picks up the nosegneg 
> libc leading to segfaults for some programs.
>   

It shouldn't ever lead to segfaults.  At worst, you should get poor
performance because the hypervisor emulates the -ve segment offset.


> /etc/ld.so.conf.d/xen.conf:
> hwcap 0 nosegneg
>   

This looks OK.  If this doesn't work, then it suggests there's something
wrong with the kernel vdso which is not exporting the nonegseg
(pseudo-)hardware capability.  But we've gone over this several times
now, and I was fairly sure we'd finally got it right - works for me, at
least.

The alternative is that there's some bug on the userspace side in your
version of Ubuntu...

Roland?

> On ubuntu's 2.6.22-xen:
> ldd /usr/bin/perl
>         linux-gate.so.1 =>  (0xf57fe000)
>         libdl.so.2 => /lib/tls/i686/nosegneg/libdl.so.2 (0xb7f90000)
>         libm.so.6 => /lib/tls/i686/nosegneg/libm.so.6 (0xb7f6b000)
>         libpthread.so.0 => /lib/tls/i686/nosegneg/libpthread.so.0 (0xb7f53000)
>         libc.so.6 => /lib/tls/i686/nosegneg/libc.so.6 (0xb7e05000)
>         libcrypt.so.1 => /lib/tls/i686/nosegneg/libcrypt.so.1 (0xb7dd7000)
>         /lib/ld-linux.so.2 (0xb7f9d000)
>
> On selfcompiled 2.6.23.9:
> ldd /usr/bin/perl
>         linux-gate.so.1 =>  (0xf57fc000)
>         libdl.so.2 => /lib/tls/i686/cmov/libdl.so.2 (0xb7f3b000)
>         libm.so.6 => /lib/tls/i686/cmov/libm.so.6 (0xb7f16000)
>         libpthread.so.0 => /lib/tls/i686/cmov/libpthread.so.0 (0xb7efe000)
>         libc.so.6 => /lib/tls/i686/cmov/libc.so.6 (0xb7db3000)
>         libcrypt.so.1 => /lib/tls/i686/cmov/libcrypt.so.1 (0xb7d85000)
>         /lib/ld-linux.so.2 (0xb7f46000)
>
>
> I now discover, that after some playing around (during discovering what the 
> problem is) i must have changed something, because ldd still shows the use of 
> the i686/cmov libraries, but applications reliably causing crashes earlier, 
> dont do so anymore.
>   

As I said, you shouldn't be seeing crashes either way.  If you are, it
suggests a hypervisor bug.  Does "xm dmesg" show anything?

> Perhaps Im all wrong, and paravirt_ops doesnt need the nosegneg versions and 
> just a ldconfig or so (which seems strange because the result before and 
> after the ldconfig were the same).
>   

nosegneg is still necessary, and it should still be working as it did
before.

> PS: I did this conversion mainly, because I was getting quite random crashes 
> inside the domU. I guess, as this was a vendor kernel + xensource xen kernel, 
> this isnt appropriate for lkml? As well as the crashes of the Dom0 (ubuntu 
> again)?
>   

Yeah, anything which isn't 2.6.18-xen isn't officially "Xen project",
but its worth reporting the bugs to xen-devel (and Ubuntu, of course). 
And to me, for that matter.  I won't be able to help directly, but the
crashes may highlight things we need to be careful about in the pvops
Xen support.

    J
