Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbXBZDpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbXBZDpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 22:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933747AbXBZDpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 22:45:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59911 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321AbXBZDpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 22:45:54 -0500
Date: Sun, 25 Feb 2007 19:45:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
Subject: Re: Make sure we populate the initroot filesystem late enough
In-Reply-To: <1172452660.3971.33.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0702251940500.12485@woody.linux-foundation.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> 
 <1172448057.3971.9.camel@shinybook.infradead.org> 
 <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org>
 <1172452660.3971.33.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Feb 2007, David Woodhouse wrote:
> 
> I'm inclined to agree that it _shouldn't_ be a problem. Nevertheless,
> even this hack seems sufficient to 'fix' it:

Ok. Clearly something is using that memory. That said, I *suspect* that 
the commit that you bisected to is just showing the problem indirectly. 
The ordering shouldn't make any difference, but it can obviously make a 
huge difference in various allocation patterns etc, thus just showing a 
pre-existing problem more clearly..

Can you try adding something like

	memset(start, 0xf0, end - start);

to before the return? That might give a better idea of exactly what is 
using it after it's free'd, hopefully by having the user trigger some more 
spectacular oops..

It is, of course, also entirely possible that the rootfs unpacking change 
really *was* buggy, and I am just missing something totally obvious. The 
memset() might still make it more obvious, though. Maybe.


>         if (start < end)
> -               printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
> +               printk ("NOT Freeing initrd memory: %ldKiB would be freed\n", (end - start) >> 10);

.. so adding the "memset()" here would be what I'm suggesting ..

> +       return;

.. and you might as well leave the return there, so that nobody else comes 
along and re-uses the memory. That should just improve on the chances of 
the memset() hopefully catching the problem..

		Linus "I don't see anything wrong" Torvalds
