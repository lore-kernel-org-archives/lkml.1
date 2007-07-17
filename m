Return-Path: <linux-kernel-owner+w=401wt.eu-S1761829AbXGQTpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829AbXGQTpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760608AbXGQTog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:44:36 -0400
Received: from kukmak.uni-mb.si ([164.8.100.3]:56340 "EHLO kukmak.uni-mb.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578AbXGQTof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:44:35 -0400
Date: Tue, 17 Jul 2007 21:44:32 +0200
From: Domen Puncer <domen.puncer@telargo.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717194432.GO2400@nd47.coderock.org>
References: <20070717080248.GK4375@moe.telargo.com> <20070717130230.GB24780@uranus.ravnborg.org> <s5htzs3ulpf.wl%tiwai@suse.de> <20070717151432.GA25939@uranus.ravnborg.org> <s5hodibukle.wl%tiwai@suse.de> <20070717153236.GB25939@uranus.ravnborg.org> <s5hir8jujhc.wl%tiwai@suse.de> <20070717164846.GB26953@uranus.ravnborg.org> <s5habtvufns.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5habtvufns.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07 19:02 +0200, Takashi Iwai wrote:
> At Tue, 17 Jul 2007 18:48:46 +0200,
> Sam Ravnborg wrote:
> > 
> > On Tue, Jul 17, 2007 at 05:40:15PM +0200, Takashi Iwai wrote:
> > > At Tue, 17 Jul 2007 17:32:36 +0200,
> > > Sam Ravnborg wrote:
> > > > 
> > > > On Tue, Jul 17, 2007 at 05:16:13PM +0200, Takashi Iwai wrote:
> > > > > At Tue, 17 Jul 2007 17:14:32 +0200,
> > > > > Sam Ravnborg wrote:
> > > > > > 
> > > > > > On Tue, Jul 17, 2007 at 04:52:12PM +0200, Takashi Iwai wrote:
> > > > > > > At Tue, 17 Jul 2007 15:02:30 +0200,
> > > > > > > Sam Ravnborg wrote:
> > > > > > > > 
> > > > > > > > On Tue, Jul 17, 2007 at 10:02:48AM +0200, Domen Puncer wrote:
> > > > > > > > > Introduce __init_exit, which is useful ie. for drivers that call
> > > > > > > > > cleanup functions when they fail in __init functions.
> > > > > > > > 
> > > > > > > > This is wrong.
> > > > > > > > On arm (just one example of several) the __exit section are discarded
> > > > > > > > at buildtime so any reference from __init to __exit will cause the
> > > > > > > > linker to error out.
> > > > > > > 
> > > > > > > Hmm, from what I see, it adds __init to the function.  There is no
> > > > > > > reference to __exit.
> > > > > > 
> > > > > > The cleanup functions are marked __exit in the referenced case.
> > > > > 
> > > > > My understanding is that it's the very purpose of this patch --
> > > > > change the mark from __exit to __init_exit for such clean-up
> > > > > functions.
> > > > 
> > > > And that is wrong.
> > > 
> > > You misunderstood.  What I meant is the case like this:
> > > 
> > > static void __init_exit cleanup()
> > > {
> > > 	...
> > > }
> > > 
> > > static void __init foo_init()
> > > {
> > > 	if (error)
> > > 		cleanup();
> > > }
> > > 
> > > static void __exit foo_exit()
> > > {
> > > 	cleanup();
> > > }
> > > 
> > > Currently, there is no proper way to mark cleanup().  Neither __init,
> > > __exit, __devinit nor __devexit can be used there.
> > 
> > Then you get the annotation sorted out so cleanup() get discarded in the
> > built-in case. But you leave no room for automated tools to detect this.
> > 
> > If this is really necessary (and I daught) then a specific section should be
> > dedicated for this usage.
> > 
> > We have lot of issues with current __init/__exit, __devinit/__devexit, __cpuint/__cpuexit
> > and introducing more of the kind does not help it.
> > So even if it saves a few bytes in some odd cases the added complaxity is IMHO not worth it.
> 
> Well, I don't think it's a few bytes and not so odd, but I agree that
> this solution isn't the best way.  And, I now remember that this won't
> work anyway, too.  Calling __init from __exit also causes error...

I made this patch because I saw __init calling __exit in yet another
driver (gianfar). Guess I'll just send the old way fix, and remove __exit.


As for calling __init_exit from __exit:
1 - in kernel, there's no __exit => no problem
2 - module, __init_exit is a no-op => no problem

the code in question again:
>  #ifdef MODULE
>  #define __exit               __attribute__ ((__section__(".exit.text")))
> +#define __init_exit
>  #else
>  #define __exit               __attribute_used__ __attribute__ ((__section__(".exit.text")))
> +#define __init_exit  __init
>  #endif

Or maybe it's the name that is confuzing, but it makes sense to me:
__init_exit - you can call it from __init or __exit.
__init_or_exit?


	Domen
