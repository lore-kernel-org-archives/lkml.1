Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXGBLon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXGBLon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXGBLof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:44:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:10101 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXGBLof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JAcjo8Lifr4JdziiA0DVymznPfsfKD4XkQ2kWTOKPcELgBizYmrdvf+lrlQS8ss7YGU0/HuqVahcXfnF0VqVtQDo/vDvUe6BHrIuyj0wiEcjAXUqFTTC9TZzBKD4mR1LckhjgquHvXTZJ3CjIj14a4nZbzUduIFDiUceXQBKhuI=
Message-ID: <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
Date: Mon, 2 Jul 2007 13:44:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070622220202.GA16872@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 6/23/07, Ingo Molnar <mingo@elte.hu> wrote:
> i'm pleased to announce release -v18 of the CFS scheduler patchset.

> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome!

I have been running cfs-v18 for a couple of days now, and today I
stumbled upon a rather strange problem. Consider the following short
program:

while(1)
        printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);

Running this in an xterm makes the xterm totally unresponsive. Ctrl-C
takes about two seconds to terminate the program, during which the
program will keep running. In fact, it seems that the longer it runs,
the longer it takes to terminate (towards 5 seconds after running for
a couple of minutes). This is rather surprising, as the rest of the
system is quite responsive (even remarkably so). I think this is also
in contrast with the expected behaviour, that Ctrl-C/program
termination should be prioritized somehow.

Some other observations: X.Org seems to be running at about 75% CPU on
CPU 1, the xterm at about 45% on CPU 0, and a.out at about 20% on CPU
0. (HT processor)

Killing with -2 or -9 from another terminal works immediately. Ctrl-Z
takes the same time as Ctrl-C.

Another thing to note is that simply looping with no output retains
the expected responsiveness of the xterm. Printing i++ is somewhere
halfway in between.

Is this behaviour expected or even intended? My main point is that
Ctrl-C is a safety fallback which suddenly doesn't work as usual. I
might even go so far as to call it a regression.

I'd also like to point out that Folding@Home seems to draw more CPU
than it should. Or, at least, in top, it shows up as using 50% CPU
even though other processes are demanding as much as they can get. The
FAH program should be running with idle priority. I expect it to fall
to near 0% when other programs are running at full speed, but it keeps
trotting along. And I am pretty sure that this is not due to SMP/HT (I
made sure to utilize both CPUs).

Lastly, I'd like to mention that I got BUGs (soft lockups) with -v8,
though it has not been reproducible with -v18, so I suppose it must
have been fixed already.

Otherwise, I am satisfied with the performance of CFS. Especially the
desktop is noticably smoother. Thanks!

Kind regards,
Vegard Nossum
