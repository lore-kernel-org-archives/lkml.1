Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXK1U0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXK1U0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXK1U0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:26:08 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:35072 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXK1U0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:26:07 -0500
From: darnok@68k.org
Date: Wed, 28 Nov 2007 16:24:32 -0400
To: Greg KH <greg@kroah.com>
Cc: darnok@68k.org, linux-kernel@vger.kernel.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com,
       hpa@zytor.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071128202432.GC6736@andromeda.dapyr.net>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <200711262323.35416.konrad@darnok.org> <20071127052955.GB777@kroah.com> <20071127180950.GA6736@andromeda.dapyr.net> <20071127190919.GA10686@kroah.com> <20071128192140.GB6736@andromeda.dapyr.net> <20071128194543.GA2469@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128194543.GA2469@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I didn't realize an external file, outside of your changes, needed this
> > > function.  If it does, then perhaps you need to just place it elsewhere.
> > 
> > The fundamental problem is that 'find_ibft' ought to be available
> > from anywhere (or at least from the iscsi_ibft.c) so that the iscsi_ibft
> > module can be loaded on any platform. But on x86, it needs to be called
> >  from setup_[32|64].c because the IBFT can be located anywhere
> > between 512KB and 1MB - and the E820 does not neccesarily have to
> > exclude that region. Hence the patch I proposed implements a
> > 'reserve_ibft_region' code which would reserve the region of memory
> > found by 'find_ibft' so that it can be preserved when iscsi_ibft
> > module is actually loaded.
> > 
> > It ends up that there are three consumers of 'find_ibft':
> >  a) the module itself (iscsi_ibft.c)
> >  b) setup_32.c
> >  c) setup_64.c
> > 
> > The first choice, which looked the most flexible, was to have it
> > in iscsi_ibft.h file.
> > The second one, which would inhibit the user from making iscsi_ibft
> > a module, would be to move it to iscsi_ibft.c and make it
> > EXPORT_SYMBOL(), but that seems wasteful from a memory foot-print
> > look.
> > A third option was to put in /lib, but that doesn't seem right - this
> > 'find_ibft' code is specific to this module.
> > 
> > Of all the options, the cleanest looks to be the first choice :-(
> > (I am not trying to be obstinate here - I just can't think of any
> > other reasonable place).
> 
> If you insist on putting it in a .h file, it needs to be marked "inline"
> at the least.

Ok.

> But, why not just put it in a separate file, that is built in if the
> user wants iscsi support?  That way the setup code can call it properly
> if needed.

In what directory should I put that file? It can't be in the arch/*
directories b/c the iscsi_ibft.c wouldn't build on all platforms.
Should I put it in drivers/firmware ?

