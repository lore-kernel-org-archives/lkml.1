Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYE2NAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYE2NAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYE2NAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:00:40 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:58446 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYE2NAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VQH2AZhqfCACYuAvzUOqyZIzSiYhrwQTaGmCbkHpSaVybjdQoc7nPvheyF+MeFeOf64bsN49IMxPqdMRsyXBP0SCa0Lr0ElyuQJPziSLnATWTRGU29wxDknB9JNCD0ISGVYdFqPesiG45rjmfhH1Y5g56+M8H+f2K1wq6qbyhTU=
Message-ID: <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com>
Date: Thu, 29 May 2008 10:00:36 -0300
From: "Fausto Richetti Blanco" <fausto.blanco@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Pipe buffers' limit of 16 * 4K
Cc: riel@redhat.com, jengelh@medozas.de, fausto.blanco@gmail.com
In-Reply-To: <alpine.LNX.1.10.0805290000400.19264@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
	 <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
	 <20080523205630.444fe2b9@bree.surriel.com>
	 <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
	 <d8d698ae0805281422i212ef0c3ocd8b28ccd9e0b70d@mail.gmail.com>
	 <alpine.LNX.1.10.0805290000400.19264@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I need an unspecified amount (it is the data content of a HTTP POST).

The tee system call appeared in the 2.6.17 (I'm using 2.6.9). That's
because I did my implementation using a buffer and copying it using
write. Unfortunately, both solutions suffer from the kernel buffer
limitation.

As I said, there's a lot of other solutions to my specific problem.
I'll problably move my solution inside the lib =/ But I decided to
write to this list to ask for dynamically adjustable sizes for the
pipes' buffers. Is there any good reason for this not to be pushed to
the kernel head ?

On Wed, May 28, 2008 at 7:05 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Wednesday 2008-05-28 23:22, Fausto Richetti Blanco wrote:
>>>
>>>    It works very well, except when the input has more than 4K (or 16
>>> * 4K in more recent kernels) because the restore_input() blocks at
>>> this limit.
>>>
>>>    I kwow there are other solutions to my problem (e.g: using a
>>> thread, moving our decisions to the lib, etc...) by I'm wondering if
>>> making the pipe buffers' limit adjustable is not a good idea. Maybe it
>>> should be helpful for another things too (like Jan Engelhardt said in
>>> his email).
>>>
>>>    In fact, I didn't find any way of restoring the input (with the
>>> input being the 'read side' of a pipe) other than using pipes. That's
>>> because I've decided to ask this in the linux-kernel list. Is there a
>>> reason for this limit not to be an adjustable parameter ?
>
> You could have a look at the tee(2) system call and see whether it helps
> you a bit. Something along the lines of:
>
>        int pfd[2];
>        pipe(pfd); /* tee() wants an fd... */
>        tee(STDIN_FILENO, pfd[1], len, SPLICE_F_NONBLOCK);
>        read(pfd[0], ..., also in nonblock-mode)
>
> Of course this also has a certain drawback, namely that the pipe will
> only give you as much bytes as it carries, and no more than that,
> because the write side of the pipe at STDIN_FILENO is currently
> blocking exactly because the pipe is full.
> In other words, at most "4K" to be read with tee().
>
> Alternatively, if you need to consume an unspecified amount, it is
> probably best to go the thread way.
