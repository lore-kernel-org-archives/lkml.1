Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYE1WGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYE1WGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYE1WFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:05:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33837 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbYE1WFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:05:41 -0400
Date: Thu, 29 May 2008 00:05:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Fausto Richetti Blanco <fausto.blanco@gmail.com>
cc: linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: Pipe buffers' limit of 16 * 4K
In-Reply-To: <d8d698ae0805281422i212ef0c3ocd8b28ccd9e0b70d@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805290000400.19264@fbirervta.pbzchgretzou.qr>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>  <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>  <20080523205630.444fe2b9@bree.surriel.com>  <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
 <d8d698ae0805281422i212ef0c3ocd8b28ccd9e0b70d@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-05-28 23:22, Fausto Richetti Blanco wrote:
>>
>>    It works very well, except when the input has more than 4K (or 16
>> * 4K in more recent kernels) because the restore_input() blocks at
>> this limit.
>>
>>    I kwow there are other solutions to my problem (e.g: using a
>> thread, moving our decisions to the lib, etc...) by I'm wondering if
>> making the pipe buffers' limit adjustable is not a good idea. Maybe it
>> should be helpful for another things too (like Jan Engelhardt said in
>> his email).
>>
>>    In fact, I didn't find any way of restoring the input (with the
>> input being the 'read side' of a pipe) other than using pipes. That's
>> because I've decided to ask this in the linux-kernel list. Is there a
>> reason for this limit not to be an adjustable parameter ?

You could have a look at the tee(2) system call and see whether it helps
you a bit. Something along the lines of:

	int pfd[2];
	pipe(pfd); /* tee() wants an fd... */
	tee(STDIN_FILENO, pfd[1], len, SPLICE_F_NONBLOCK);
	read(pfd[0], ..., also in nonblock-mode)

Of course this also has a certain drawback, namely that the pipe will
only give you as much bytes as it carries, and no more than that,
because the write side of the pipe at STDIN_FILENO is currently
blocking exactly because the pipe is full.
In other words, at most "4K" to be read with tee().

Alternatively, if you need to consume an unspecified amount, it is
probably best to go the thread way.
