Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYCLUJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYCLUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYCLUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:09:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:13163 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbYCLUJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Sg6jEvUntyRDNxjl+1FfVqP8Z53mszI7bmQ4AwDca53PYjZgca0+rlArnumUpfwkPHl8Mz+kx94vD6ZnV/wkNgLASo+1ZT2ius9CJHo5Q0kYzc/9Xa1oLvbQn0HiiQNpxWXc7VTHDYDMMxJbvO8OwXhvKPyYdb6LFUWe1X/R3Jo=
Message-ID: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com>
Date: Wed, 12 Mar 2008 21:09:04 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: linux+glibc memory allocator, poor performance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 19:14:06 +0100, Xose Vazquez Perez wrote:
> hi,
>
> More tests from FreeBSD people <http://people.freebsd.org/~kris/scaling/smp.html>
>
> Poor performance with 2.6.24 linux kernel and glibc 2.7 provided by Fedora 8:
>
> *Memory allocation performance on FreeBSD and Linux with ebizzy (Mar 2008)*
> <http://people.freebsd.org/~kris/scaling/ebizzy.html>
>
> -thanks-
>
> regards,
> --
> so much to do, so little time.

Assume a SMP system that has 8 CPUs. The main problem of requesting
pages is the BKL (Big Kernel Lock) in this SMP system used for mutual
exclusion of the shared resource (the memory).

To solve this major problem, i propose you freely to allocate 8 local caches
of (e.g.) 2 MiB each CPU (total 2MiB x 8 CPUs = 16 MiB) acting as
8 producer buffers for globally many consumer tasks (e.g. >= 20).

When the some producer buffer is empty then it does unfrequently BKL to
allocate another 2 MiB more from the shared resource (the memory).

In the reverse, it's simple, return back the unused pages to the local buffer
of the producer, and when this full then to do BKL too to unallocate its half
to the shared resource (the memory).

   Sincerely, J.C.Pizarro
