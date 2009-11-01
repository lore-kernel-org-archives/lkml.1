Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZKARTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZKARTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 12:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZKARTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 12:19:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbZKARTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 12:19:09 -0500
Date: Sun, 1 Nov 2009 09:18:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
In-Reply-To: <200911010936.10409.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0911010914100.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010010.07394.rjw@sisk.pl> <200911010024.12081.rjw@sisk.pl> <200911010936.10409.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Nov 2009, Rafael J. Wysocki wrote:
> 
> If people don't object, I'll push it through the suspend-2.6 tree along 
> with a few other bug fixes.

No objections, but a cleanup request:

> +static int socket_early_resume(struct pcmcia_socket *skt)
> +{
> +	if (skt->state & SOCKET_SUSPEND)
> +		socket_start_resume(skt);
> +
> +	return 0;
> +}
> +
> +static int socket_late_resume(struct pcmcia_socket *skt)
> +{
> +	if (!(skt->state & SOCKET_SUSPEND))
> +		return 0;

As far as I can tell, that "SOCKET_SUSPEND" test is totally pointless. 
That socket _is_ going to be suspended, and testing for it here just seems 
to confuse things. 

So I'd remove it from both early_resume and late_resume, and only keep it 
in the case of the legacy user-requested suspend/resume (do we even do 
that any more?).

The SOCKET_SUSPEND flag itself is still relevant, of course, since the 
state change handling will test it (in order to avoid insert/remove 
handlign while we have the suspend flag set). It's just that the suspend 
code shouldn't _test_ it, since the suspend code is what sets it in the 
first place.

		Linus
