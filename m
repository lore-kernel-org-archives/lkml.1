Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbXHZQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbXHZQ71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXHZQ7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:59:02 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49422 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbXHZQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:59:00 -0400
Date: Sun, 26 Aug 2007 18:58:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Fred Tyler <fredty8@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260949i3b9d1c32ia8b1869196689247@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708261851240.15614@fbirervta.pbzchgretzou.qr>
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com> 
 <466ad3f90708260851u5d8ac58duc4072b71ebf78fc8@mail.gmail.com> 
 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr> 
 <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com> 
 <Pine.LNX.4.64.0708261828540.15614@fbirervta.pbzchgretzou.qr>
 <466ad3f90708260949i3b9d1c32ia8b1869196689247@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 12:49, Fred Tyler wrote:
>>
>> So I guess you are not seeing any memory leak at all, but just the regular
>> caching?
>
>I certainly hope that is the case, but until I try it on the
>production machine tonight I won't know for sure.

Note that not all kernels have the 'drop_caches' control file.
So there is not much you can do there.

>If this is indeed a
>leak, it's pretty slow, and it takes a week or so before you can even
>start noticing it on the graphs

Well if it helps, you can accelerate the 'problem', by issuing, for example:

(1)
	dd_rescue /dev/sda /dev/null -m $[4*1048576*1024]

for reading 4 GB from disk straight and populating 'buffers'.

(2)
	cat /some/big/big/big/file >/dev/null

for reading X GB from disk and populating 'cache'.

and then you'll see.  Also note that a kernel leak will eventually lead 
to very low buffers/cached values (the ones to the far right) even when 
large amounts of data are read (using either dd_rescue/cat as mentioned 
above), because, of course, the leak clogs up memory.

             total       used       free     shared    buffers     cached
Mem:        775792     493724     282068          0          8     308416
-/+ buffers/cache:     185300     590492
Swap:       795136         60     795076


>I can say with absolute certainty that something very similar was
>happening in 2.6.12 (compare the graphs in my original email), and in
>2.6.12 it would inevitably lead to the server running entirely out of
>memory, to the point where applications could no longer allocate
>memory and the server would have to be rebooted.

>The symptoms were almost identical in that case: I'd shut down
>virtually every application on the server, but the memory would still
>be almost entirely in use. I understand there's kernel caching, but if
>the kernel caching occurs at the expense of any other applications
>being able to access memory, then there's a real problem. (I actually
>still have one 2.6.12 machine running, but drop_caches doesn't appear
>to exist on it so I can't test it there. Is there an analogue?)

If you see an Out Of Memory notice in dmesg, you'll know there is a 
leak even if everything was shut down.

>
>Anyway, I'll post the results from the 2.6.20 server as soon as I have
>them. Should be late tonight.
>
>Thanks.
>

	Jan
-- 
