Return-Path: <linux-kernel-owner+w=401wt.eu-S934583AbZHEQAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbZHEQAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934305AbZHEQAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:00:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934294AbZHEQAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:00:34 -0400
Message-ID: <4A79AD2A.4060308@suse.de>
Date: Thu, 06 Aug 2009 01:02:50 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A7951B0.10208@suse.de>	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>	<4A796C94.5040301@suse.de>	<20090805134823.4409e197@lxorguk.ukuu.org.uk>	<4A799392.3000108@suse.de> <20090805152942.42e785f3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805152942.42e785f3@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
> I would suggest you read the code for the others. OSS is probably the
> easy one to kill but the others create objects for platform wide sysfs
> files and the like (as indeed OSS once did for a proc file) so in the
> general case CUSE needs to work through them.

I don't think it's wise for CUSE to try to emulate all those.  CUSE
provides emulation for a character device file and that's it.  It's a
building block not a complete solution.  In many cases information
provided via sysfs or proc doesn't matter to much for individual apps
and there's no reason to try to emulate them.  For other cases, those
nodes would need to be emulated using other building blocks - tmpfs or
fuse overlay mount maybe.

>>  * OSS compatibility as seen from userland apps : relevant
>>
>>  * doing everything right by sound_core.c which basically is only used
>>    by in-kernel emulation : not so much
> 
> So instead of weird config magic why not send both messages.

It's weird but simple and the alternative behavior of only acquiring
existent devices shouldn't hurt anyone who's using anything remotely
modern.  The only thing that changes is the module alias kernel
requests after all.  Oh well...

> Initially soundcore can generate both requests for sound-slot-foo
> and also fake up its own char requests. It's easy to do, it doesn't
> put any code into the kernel we'll be stuck with for years with
> weird config options. It doesn't require the user choose a magic
> kernel option - it just works.
> 
> It's not much code either - just another request call in soundcore_open -
> one line extra to write, a year to wait (4 releases ?) and then the old
> stuff can go away, ALSA can then avoid soundcore and soundcore can vanish.
> 
> Much cleaner, and I believe one line of code ?

Hmm... the problem is that the old stuff claims the whole chrdev
region.  I was thinking about adding support for alternative module
alises at the chrdev layer if this is that essential and changing
sound_core to claim only the devices which actually exist.  That way
we can continue to use the same module aliases and allo OSS emulation
and ossp to occupy the same kernel.

I don't see how I would be able to achieve the latter with one liner.
Can you please elaborate a little bit?

Thanks.

-- 
tejun
