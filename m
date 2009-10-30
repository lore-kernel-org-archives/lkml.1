Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZJ3TsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZJ3TsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZJ3TsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:48:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbZJ3TsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:48:04 -0400
Date: Fri, 30 Oct 2009 12:47:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
In-Reply-To: <200910301948.24473.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.EqH.Nse5KB@chimera> <200910301948.24473.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Oct 2009, Rafael J. Wysocki wrote:
> 
>
> 1) Resume works if pcmcia_socket_dev_resume(dev) is moved to the "regular"
>    resume phase, after resume_device_irqs().

Hmm. We really probably shouldn't call pcmcia_socket_dev_resume() in 
early_resume. It takes mutexes etc, and it calls "socket_resume()", which 
sleeps etc. That per se should be ok these days (since we don't actualyl 
disable CPU irq's, just device irqs), but it also does that whole card 
insertion events etc. And _that_ code I wouldn't trust at all.

The PCMCIA code is better than it used to be a long time ago, but some of 
it is still pretty crazy. 

I get the feeling that we should just revert that commit 0c570cdeb, and 
instead always do PCMCIA suspend as a "eject" event. That way we have no 
driver behind it to resume at resume time - and we'll see any plugged-in 
device as just a new insertion. 

		Linus
