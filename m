Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYFJQi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYFJQi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFJQiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:38:20 -0400
Received: from smtp2.riverbed.com ([206.169.144.7]:35704 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYFJQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:38:19 -0400
Date: Tue, 10 Jun 2008 09:38:00 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>
Subject: Re: on static kobjects and double frees...
Message-ID: <20080610163800.GA28572@ajones-laptop.nbttech.com>
References: <20080610155848.GS26334@ajones-laptop.nbttech.com> <20080610162341.GA13538@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080610162341.GA13538@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, ...

On Tue, Jun 10, 2008 at 09:23:41AM -0700, Greg KH wrote:
> On Tue, Jun 10, 2008 at 08:58:50AM -0700, Arthur Jones wrote:
> > Hi Greg,  The edac pci sysfs generic layer uses a static
> > kobject as a placeholder parent where edac pci drivers
> > are inserted.
> 
> Hm, stop right there.
> 
> kobjects are not supposed to be static, bad things happen if you do that
> (including the kernel itself will warn you about them, unless you gave
> it an empty release function, and if so, then see
> Documentation/kobject.txt and prepare to be mocked...)

OK, I wondered about this, but I didn't see anything
in Documentation/kobject.txt that said that kobjects
can not be static.  But now that I've fixed the double
free bug, I'm seeing the warning you mentioned above...

I don't know how the current code came to be, so I
can't speak to your issues below.  But, with these
pointers, I think I can get things cleaned up properly.

Thank you!

Arthur

> > An atomic count is used to know when to kobject_init_add_add or
> > kobject_put the static kobject.
> 
> No, the kobject itself should handle stuff like this.
> 
> > The issue with this is that the name gets double freed
> > on the second module load as edac does not clear it, and
> > kobject_cleanup does not clear it.
> 
> Yup, that's because you should not be doing this :)
> 
> > The quick fix was to clear the static kobj name before
> > calling kobject_init, but that seems a bit fragile as it
> > involves knowing the internals of kobject_put.  Perhaps
> > the name should be cleared before calling the kobject
> > release method?  Something like this (not even compile
> > tested):
> 
> No, please just dynamically create your kobject.  It's easier than ever
> to do this today (just one function call!).
> 
> >
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 718e510..7dfe906 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -552,6 +552,9 @@ static void kobject_cleanup(struct kobject *kobj)
> >       if (t && t->release) {
> >               pr_debug("kobject: '%s' (%p): calling ktype release\n",
> >                        kobject_name(kobj), kobj);
> > +
> > +             /* avoid double free with static kobjects... */
> > +             kobj->name = NULL;
> >               t->release(kobj);
> >       }
> >
> > What do you think?  I'm happy to implement and test whatever
> > you think is best...
> >
> > The edac code in question is drivers/edac/edac_pci_sysfs.c,
> > the static kobject is called edac_pci_top_main_kobj...
> 
> In looking at that code, I really don't understand what you are trying
> to do with this "tracking" kobject.  Why do that at all, and not just
> create a kobject and hang things off of it if you want to have that.
> The whole lifetime of it will be properly handled automatically if you
> do that.
> 
> thanks,
> 
> greg k-h
