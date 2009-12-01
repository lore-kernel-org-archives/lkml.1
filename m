Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZLAVwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZLAVwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZLAVww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:52:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZLAVwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:52:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
Date: Tue, 1 Dec 2009 22:53:08 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4B1575AC.6080904@tuffmail.co.uk> <20091201214529.GA1457@csn.ul.ie>
In-Reply-To: <20091201214529.GA1457@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912012253.08522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 December 2009, Mel Gorman wrote:
> On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
> > Hi
> >
> > Suspend to disk is (sometimes) hanging for me in 2.6.32-rc.  I finally  
> > got around to bisecting it, which blamed the following commit by Mel:
> >
> > 5f8dcc2 "page-allocator: split per-cpu list into one-list-per-migrate-type"
> >
> > I was able to confirm this by reverting the commit, which fixed the  
> > hang.  I had to revert one other commit first to avoid a conflict:
> >
> > a6f9edd "page-allocator: maintain rolling count of pages to free from  
> > the PCP"
> >
> 
> Which RC kernel? Specifically, are the commits
> 
> cc4a6851466039a8a688c843962a05689059ff3b always wake kswapd when restarting an allocation attempt
> 9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 Do not allow interrupts to use ALLOC_HARDER
> 
> applied?
> 
> The latter one in particular might make a difference if s2disk is
> pushing the system far below the watermarks. I don't suppose you know
> where it's hanging? i.e. is it hanging in the allocator itself?
> 
> If those patches are applied, then one difference that 5f8dcc2 makes is
> that pages on the PCP lists but not of the right migratetype are not
> used. Prior to that commit, an allocation might succeed even if the
> buddy lists were empty because one of the other PCP page types would be
> used.
> 
> > -- detail --
> >
> > When I suspend my EeePc 701 to disk, it sometimes hangs after writing  
> > out the hibernation image.  The system is still able to resume from this  
> > image (after working around the hang by pressing the power button). 
> >
> > This is specific to s2disk from the uswsusp package (which is now  
> > installed by default on debian unstable).  It doesn't happen if I  
> > uninstall uswsusp and use the in-kernel suspend instead.
> >
> 
> This leads me to believe that uswsusp is able to push available pages
> far below what is expected. It's a total guess though, I have no idea
> how uswsusp is implemented or how it differs from what is in kernel.

It doesn't differ at all in that respect.  Actually, it uses the same code, but
the distro configuration may be such that it leaves fewer available pages
than the default in-kernel hibernation.

Thanks,
Rafael
