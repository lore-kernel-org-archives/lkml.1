Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYCST1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYCST1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYCSTY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:24:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbYCSTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:50 -0400
Date: Tue, 18 Mar 2008 20:56:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <alpine.LFD.1.00.0803182013090.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803182042430.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803190221.58968.bzolnier@gmail.com> <alpine.LFD.1.00.0803181814170.3020@woody.linux-foundation.org> <200803190424.30971.bzolnier@gmail.com>
 <alpine.LFD.1.00.0803182013090.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Mar 2008, Linus Torvalds wrote:
> 
> But the absolute first thing we should do is to make the code at least as 
> robust as it used to be, and preferably aim _higher_ in robustness rather 
> than lower!

An example of this "aim higher", I think that we obviously should complete 
the command if the controller says it's done with it (like the old 
"drive_cmd_intr()" code used to do), but we might decide that printing a 
warning would be the proper way to then also inform the user about the 
fact that we expected the command to want more data, but it never did.

That way, the code not only handles the unexpected situation gracefully, 
but the very fact that it was unexpected also gets logged.

[ And at that point your patch to make the specific SMART subcommands have 
  strict logic about the data direction will actually matter - although 
  maybe it turns out that there are _other_ tools that send other 
  commands, and we decide that the warning isn't useful after all! ]

The thing is, I know for a fact that some system vendors use Linux for 
burn-in and testing/setup of their components, and I would not be in the 
least surprised if some of them use HDIO_DRIVE_CMD to do some 
vendor-specific stuff.

And I think it's a fine thing to try to use just one set of code (the 
taskfile code) to drive all these special commands, but the fact is, the 
old HDIO_DRIVE_CMD interface fundamentally doesn't even _have_ the 
capability to specify the total taskfile state.

So we simply know as a fact that
 (a) people do use an interface that used to work (HDIO_DRIVE_CMD)
and
 (b) it will fundamentally *never* have complete taskfile state, so we 
     *have* to live with the fact that some of our commands simply don't 
     have the full state that the taskfile code may have historically 
     depended on but the old ide_drive_cmd() code didn't and cannot depend 
     on.

Your patch tries to fix (b), but we also know that it fundamentally simply 
*cannot* fix it for all cases. So even trying to is really pretty futile, 
I think (although we can obviously hope that nobody uses HDIO_DRIVE_CMD 
any more for anything but SMART and really simple commands, but that 
sounds rather unlikely).

		Linus
