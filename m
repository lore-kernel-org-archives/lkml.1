Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYKKQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYKKQmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYKKQmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:42:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54216 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYKKQmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:42:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Date: Tue, 11 Nov 2008 17:47:27 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20081109140726.GB1786@ucw.cz> <200811111520.22386.rjw@sisk.pl> <20081111150342.GB1648@ucw.cz>
In-Reply-To: <20081111150342.GB1648@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111747.28347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Pavel Machek wrote:
> 
> > > > It is.  However, the problem is 100% reproducible on any 32-bit single-node
> > > > system with CONFIG_NUMA set, from what I can tell.
> > > > 
> > > > It doesn't happen if the kernel is booted with highmem=0, so it looks like
> > > > the code that saves highmem causes the problem to happen.  However, this
> > > > same code works well for all of the !CONFIG_NUMA cases and practically only
> > > > the only non-open-coded it uses is kmap_atomic().
> > > > 
> > > > > One possibility would be to bisect if it ever worked?
> > > > 
> > > > Not sure it did, probably not. :-(
> > > 
> > > Well, interesting point would be just before this commit:
> > > 
> > > 
> > > commit 8357376d3df21b7d6f857931a57ac50da9c66e26 
> > > tree daf2c369e9b79d24c1666323b3ae75189e482a4a 
> > > parent bf73bae6ba0dc4bd4f1e570feb34a06b72725af6 
> > > author Rafael J. Wysocki <rjw@sisk.pl> Wed, 06 Dec 2006 20:34:18 -0800 
> > > committer Linus Torvalds <torvalds@woody.osdl.org> Thu, 07 Dec 2006
> > > 08:39:27 -0800 
> > > 
> > >     [PATCH] swsusp: Improve handling of highmem
> > >     
> > >     Currently swsusp saves the contents of highmem pages by copying
> > > them to the
> > >     normal zone which is quite inefficient (eg.  it requires two
> > > normal pages
> > >     to be used for saving one highmem page).  This may be improved by
> > > using
> > >     highmem for saving the contents of saveable highmem pages.
> > > 
> > > ...highmem handling was way simpler in those good old days ;-)
> > 
> > Please stop kidding, this is a serious issue.
> > 
> > The hibernation code _works_ with all kinds of highmem when CONFIG_NUMA is
> > unset.
> 
> And it does not work with single highmem page when NUMA is set... I
> went through the highmem saving code, and it depends on highmem not
> changing from  under it (right?) and is generally quite tricky ('if
> they are both in highmem do this, else if one of them is do that, else
> do something else')

It actually is quite simple, if you know the idea.

> and it changes page protections on the fly, etc. 

No, it doesn't do that, at least for pages it hasn't allocated itself.  I don't
think it changes anything like page protections at all, though.

> I'm not saying the bug is in that code, but before that commit we had
> very stupid --- but very robust -- code. I'll try if that one works
> with config_numa, perhaps we can get some debug info that way.

if you can do that, it actually may be valuable information.

Thanks,
Rafael
