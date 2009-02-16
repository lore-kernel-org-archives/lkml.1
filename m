Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZBPBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZBPBka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 20:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZBPBkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 20:40:21 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51492 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbZBPBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 20:40:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JefeF62Q2Py3O/4fWZdpTXcL0GWhEN8raVdh9sUzeTRKq2VAouEgTVYU/6rJxgJXnD
         fzpKv1gVtpQgAYbr4izPRzVU+K93LzpS0kzpVJ1tUg/1S0zy5CUl/FuVYqWzHKOWS4Yh
         8M2J/Nrw7AvxSuAMehi83mKhAhfq4wf6M58Xc=
Date: Mon, 16 Feb 2009 02:40:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rusty@rustcorp.com.au
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Message-ID: <20090216014015.GC5790@nowhere>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <20090215170214.GK5835@nowhere> <883216.75749.qm@web110607.mail.gq1.yahoo.com> <20090215194147.GB5790@nowhere> <690182.5203.qm@web110608.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690182.5203.qm@web110608.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 01:02:15PM -0800, Sitsofe Wheeler wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> > 
> > On Sun, Feb 15, 2009 at 11:24:41AM -0800, Sitsofe Wheeler wrote:
> > > > Could you please enable the CONFIG_DETECT_SOFTLOCKUP option in your kernel?
> > > 
> > > > It's on Kernel Hacking > Detect Soft Lockups.
> > > > With some chances you will have a relevant stacktrace of the lockup, in case
> > > > I couldn't reproduce it.
> > > 
> > > I'll try (the kernel I'm currently using is jam packed with with debug 
> > options) but I'm unconvinced it will unfreeze enough for anything useful...
> > 
> > No need to actually, I guess we found it...
> 
> That's good news - the only way I could have reported the soft lockup stack trace would have been by taking a photo of the screen. The stack trace was pretty much what is seen inside <http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6> anyway. The thing that I'm curious about is why did it show up as an oops last time and as a complete lockup this time?


I don't know :-)

> 
> My one thought is that this is actually a parameter that was not intended to be changed and shouldn't have accepted being written to.


I guess there aren't any module string parameter which expect to be changed like that,
just by changing the pointer value.
Usually, when you have a string parameter, you parse it at load time, and keep the value as an integer.
So it makes only sense to change such values at runtime through a callback given by the module. And that's
what mac80211 does through debugfs.

> However one wonders how the syfs framework was supposed to work in other cases. 


Actually, what I can see is that in case of module_param() with char * types, the permission
of the file is often 0444 or 0, so it is safe.

There are exceptions however:

$ git-grep -E "charp, 04?[123567]+"
arch/um/drivers/hostaudio_kern.c:module_param(dsp, charp, 0644);
arch/um/drivers/hostaudio_kern.c:module_param(mixer, charp, 0644);
drivers/misc/lkdtm.c:module_param(cpoint_name, charp, 0644);
drivers/misc/lkdtm.c:module_param(cpoint_type, charp, 0644);
drivers/net/wireless/libertas/if_sdio.c:module_param_named(helper_name, lbs_helper_name, charp, 0644);
drivers/net/wireless/libertas/if_sdio.c:module_param_named(fw_name, lbs_fw_name, charp, 0644);
drivers/net/wireless/libertas/if_usb.c:module_param_named(fw_name, lbs_fw_name, charp, 0644);
drivers/net/wireless/libertas_tf/if_usb.c:module_param_named(fw_name, lbtf_fw_name, charp, 0644);
drivers/video/vt8623fb.c:module_param(mode_option, charp, 0644);
net/mac80211/rate.c:module_param(ieee80211_default_rc_algo, charp, 0644);

I'm preparing a patchset to set them only readable, it doesn't fix this module bug,
but anyway, such string params writable at runtime don't make any sense.

>It sounds like there is a very
>small window for making your own private copy of whatever sysfs passes to you and under the current system who 
>throws away old strings (given that it looks like pointers are being swapped)? Are they refcounted or something?

When you register a module param, its address is stored inside a struct kernel_param.
Once you change the value of the param, it's totally fine for int/long/boolean...
since no memory is allocated for that, only the integer value is changed on the static memory, though
a module must deal with this asynchronous event given the fact it let it writable by the
user, and I guess it's not always a good idea.

So for an integer called a, you will put a module_param(a, int, ...) which will
allocate a struct kernel_param, and store &a inside.

For params such as strings, its very different, since you register a char *p,
its address is stored in, say,  pp (as a char **).
and later the equivalent of the following is done:

open: tmp = kzalloc(PAGE_SIZE, GFP_KERNEL);
write: fill(pp);
      *(char **)pp = tmp;
release: kfree(tmp)
read: read(**pp) => crash

And no there is no refcounting. But that would be perhaps too much for that.
Really I think a callback registered on module_param() would be better, not only
for appropriate allocation but for event handling too.

