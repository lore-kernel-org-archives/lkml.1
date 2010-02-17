Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0BQKov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:44:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55096 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609Ab0BQKoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:44:39 -0500
Date: Wed, 17 Feb 2010 10:43:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100217104343.0a1d6813@lxorguk.ukuu.org.uk>
In-Reply-To: <201002171316.49165@zigzag.lvk.cs.msu.su>
References: <201002161520.26700@zigzag.lvk.cs.msu.su>
	<87r5ok5gl2.fsf@basil.nowhere.org>
	<201002171316.49165@zigzag.lvk.cs.msu.su>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For example, have a "last error" string associated with task_struct, that:
> - will clean on each syscall entry,
> - while syscall is running, may be filled with printf-style routines,
> - may be accessible from userspace with additional syscall [that obviously 
> should not reset error]?
> 
> This will give driver writers a common interface for extended error 
> reporting...

Thats probably overkill. For almost any ioctl type interface the only
thing you *need* to make more sense is the address of the field that was
deemed invalid.

So in your ioctl handler you'd do something like

	get_user(v, &foo->wombats);
	if (v < 5) {
		error_addr(&oo->wombats);
		return -EINVAL;
	}

returning text is all very well, and printk can help debug, but neither
actually help application code or particularly help interpreters to dig
into the detail and act themselves to fix a problem or understand it. It
also costs material amounts of unswappable memory and also disk storage
for the kernel image on embedded devices.

Two other problems text returns bring up or ambiguity and translations -
its almost impossible to keep them unique even within a big module. It's
also possible to get things like typos in the returned text or
mis-spellings that you then can't fix because some other app now has

	if (strcmp(returned_err, "No such wombat evalueted")==0) {
		...
	}

in it. (HTTP 'referer' being a dark warning from history ...)

A lot of other systems keep message catalogues often indexed by
module:error. Text lookups in userspace (easy to do with existing
interfaces), and the OS providing generic, specific, and identifying
module info.

I guess the Linux extension to that would end up as

	extended_error(&foo->wombats, E_NOT_A_VALID_BREEDING_POPULATION);

and internally expand to include THIS_MODULE and extract the module name.

There's another related problem here too - Unix style errors lack the
ability of some OS systems to report "It worked but ....." which leads to
interface oddities like termios where it reports "Ok" but you have to
inpsect the returned structure to see if you got what you requested.

Doesn't look too hard to add some of this or something similar as you
suggest and while it would take a long time to get coverage you have to
start somewhere.

Alan
