Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbXK1T2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbXK1T2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbXK1T2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:28:25 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60892 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbXK1T2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:28:25 -0500
From: darnok@68k.org
Date: Wed, 28 Nov 2007 15:21:40 -0400
To: Greg KH <greg@kroah.com>
Cc: darnok@68k.org, linux-kernel@vger.kernel.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com,
       hpa@zytor.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071128192140.GB6736@andromeda.dapyr.net>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <200711262323.35416.konrad@darnok.org> <20071127052955.GB777@kroah.com> <20071127180950.GA6736@andromeda.dapyr.net> <20071127190919.GA10686@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127190919.GA10686@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 11:09:19AM -0800, Greg KH wrote:
> On Tue, Nov 27, 2007 at 02:09:50PM -0400, darnok@68k.org wrote:
> > On Mon, Nov 26, 2007 at 09:29:55PM -0800, Greg KH wrote:
> > > On Mon, Nov 26, 2007 at 11:23:31PM -0500, Konrad Rzeszutek wrote:
> > > > On Monday 26 November 2007 22:31:38 Greg KH wrote:
> > > > > > +#if defined(CONFIG_ISCSI_IBFT) || defined(CONFIG_ISCSI_IBFT_MODULE)
> > > > ..snip..
> > > > > > +static ssize_t find_ibft(void)
> > > > > > +{
> > > > ..snip..
> > > > > > +}
> > > > >
> > > > > What is a function (not even an inline one) doing in a .h file?
> > > > 
> > > > I was not sure where to put it. This function (find_ibft) is used by the 
> > > > setup_[32|64].c and the iscsi_ibft.c code. Randy suggested I put in .c file, 
> > > > but I am not sure exactly where? Should I make a new file in called 
> > > > libs/iscsi_ibft_helper.c ?
> > > 
> > > Put it in your .c file and make it a global function to be called by
> > > someone else if they need it.
> > 
> > If the kernel is built with CONFIG_ISCSI_IBFT=m, the
> > setup_[32|64],c code would depend on the 'find_ibft' symbol which is
> > in a module (in the iscsi_ibft.c), which is not available during
> > the bootup phase and not linked to vmlinuz.
> 
> Ah, then don't allow that :)
> 
> > This isn't an issue if the module is built with CONFIG_ISCSI_IBFT=y of
> > course.
> > 
> > Or did by 'your .c file' mean a new file in arch/x86/kernel directory?
> 
> I didn't realize an external file, outside of your changes, needed this
> function.  If it does, then perhaps you need to just place it elsewhere.

The fundamental problem is that 'find_ibft' ought to be available
from anywhere (or at least from the iscsi_ibft.c) so that the iscsi_ibft
module can be loaded on any platform. But on x86, it needs to be called
 from setup_[32|64].c because the IBFT can be located anywhere
between 512KB and 1MB - and the E820 does not neccesarily have to
exclude that region. Hence the patch I proposed implements a
'reserve_ibft_region' code which would reserve the region of memory
found by 'find_ibft' so that it can be preserved when iscsi_ibft
module is actually loaded.

It ends up that there are three consumers of 'find_ibft':
 a) the module itself (iscsi_ibft.c)
 b) setup_32.c
 c) setup_64.c

The first choice, which looked the most flexible, was to have it
in iscsi_ibft.h file.
The second one, which would inhibit the user from making iscsi_ibft
a module, would be to move it to iscsi_ibft.c and make it
EXPORT_SYMBOL(), but that seems wasteful from a memory foot-print
look.
A third option was to put in /lib, but that doesn't seem right - this
'find_ibft' code is specific to this module.

Of all the options, the cleanest looks to be the first choice :-(
(I am not trying to be obstinate here - I just can't think of any
other reasonable place).
