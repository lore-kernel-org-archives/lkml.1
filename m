Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbXEIWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbXEIWSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbXEIWRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:17:55 -0400
Received: from gw.goop.org ([64.81.55.164]:36764 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759900AbXEIWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:17:54 -0400
Message-ID: <46424896.8080506@goop.org>
Date: Wed, 09 May 2007 15:17:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509215538.GK11115@waste.org>
In-Reply-To: <20070509215538.GK11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
>> Mercurial uses a strictly append-only model for updating its repo files,
>> but it looks like maybe an append operation didn't stick.
>>     
>
> (Unless you're using the mq extension, which regularly truncates
> files. But you're definitely the first person to run into this sort of
> thing in any case.)
>   

Which I am, extensively, but not on the repo that got damaged.  That's
why I was wondering about the nlink issues.  If I qpop a bunch of
patches after just pushing them, won't it simply truncate the file?

The repo which got damaged is the one I pull kernel.org/linux-2.6 into,
and use it as a source for clone/pull into my actual working repos.

> I think if the files are identical up to the truncation point, we can
> rule out nlink concerns. If for some reason Mercurial's COW logic got
> fooled, the result would be a bit of a jumble at the end. And you'd be
> unlikely to hit any sort of race as a single user on a laptop.
>   

OK.  It looks

> Can you use hg debugindex to determine if the truncation point
> corresponds with a whole delta or whether it's in the middle of a
> delta? 
>   

Appears to be on a delta boundary, exactly 47 revisions short:

 55547  201166570      72  55486   55561 fec059c8328e 4edafd81aa44 000000000000
 55548  201166642      72  55486   55562 96c054b45299 fec059c8328e 000000000000
 55549  201166714     108  55486   55563 93316f167674 96c054b45299 000000000000

vs

 55594  201568678      78  55486   55608 38c05617f083 5fe2b556c548 000000000000
 55595  201568756      68  55486   55609 4b89463f4bdd 38c05617f083 000000000000
 55596  201568824      81  55486   55610 bcdb471d4ba1 4b89463f4bdd 000000000000


> For noninterleaved revlogs like your manifest above, the .i file is an
> index build of a collection of 64-byte entries. It's pretty hard to
> imagine how you'd lose 8 bytes since all I/O is done in multiples of
> 64-bytes. Oh, I'm misreading that - they differ by 3008 bytes, which
> is 47 * 64. 
>   

Yep.

    J

