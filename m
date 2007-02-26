Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXBZQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXBZQAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXBZQAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:00:49 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbXBZQAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:00:48 -0500
Date: Mon, 26 Feb 2007 07:51:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Uwe Bugla <uwe.bugla@gmx.de>, akpm@linux-foundation.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
In-Reply-To: <45E2F8C5.3080905@gmail.com>
Message-ID: <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com>
 <45E2F8C5.3080905@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Feb 2007, Jiri Slaby wrote:
> 
> Ok, this commit is the culprit:
> Commit: 2ff2d3d74705d34ab71b21f54634fcf50d57bdd5
> Author: Stephane Eranian <eranian@hpl.hp.com> Tue, 13 Feb 2007 13:26:22 +0100
> 
>     [PATCH] i386: add idle notifier

Interesting. It doesn't touch floppy at all, but it *does* seem to play 
around with irq state. 

In particular, the floppy uses IRQF_DISABLED (which means that it doesn't 
want interrupts enabled when in the irq handler), and I get the feeling 
that the poll_idle() stuff made that not work.

That said, the only thing that *really* seems to change (as far as a 
floopy driver could notice) is the added "exit_idle()" in the do_IRQ() 
sequence, and I'm not seeing that one enabling interrupts. 

But the idle sequence definitely does (ie now we disable/enable interrupts 
in cpu_idle(). I'm not seeing why that should matter, though.

Stephane, any ideas?

		Linus
