Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXAVW1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXAVW1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 17:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbXAVW1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 17:27:36 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4027 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbXAVW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 17:27:35 -0500
Date: Mon, 22 Jan 2007 22:27:25 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org,
       Alon Bar-Lev <alon.barlev@gmail.com>
Subject: Re: [patch 03/26] Dynamic kernel command-line - arm
Message-ID: <20070122222725.GB32085@flint.arm.linux.org.uk>
Mail-Followup-To: Tomas Carnecky <tom@dbservice.com>,
	linux-kernel@vger.kernel.org, Alon Bar-Lev <alon.barlev@gmail.com>
References: <20070118125849.441998000@strauss.suse.de> <20070118130028.719472000@strauss.suse.de> <20070118141359.GB31418@flint.arm.linux.org.uk> <45AF92E7.50901@dbservice.com> <20070118152326.GC31418@flint.arm.linux.org.uk> <20070122221400.GE6262@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122221400.GE6262@strauss.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 11:14:00PM +0100, Bernhard Walle wrote:
> * Russell King <rmk+lkml@arm.linux.org.uk> [2007-01-18 16:23]:
> > On Thu, Jan 18, 2007 at 04:31:51PM +0100, Tomas Carnecky wrote:
> > > Russell King wrote:
> > > > On Thu, Jan 18, 2007 at 01:58:52PM +0100, Bernhard Walle wrote: 
> > > >> -static char command_line[COMMAND_LINE_SIZE];
> > > >> +static char __initdata command_line[COMMAND_LINE_SIZE];
> > > > 
> > > > Uninitialised data is placed in the BSS.  Adding __initdata to BSS
> > > > data causes grief.
> > > > 
> > > 
> > > Static variables are implicitly initialized to zero. Does that also
> > > count as initialization?
> > 
> > No.  As I say, they're placed in the BSS.  The BSS is zeroed as part of
> > the C runtime initialisation.
> > 
> > If you want to place a variable in a specific section, it must be
> > explicitly initialised.  Eg,
> > 
> > static char __initdata command_line[COMMAND_LINE_SIZE] = "";
> 
> Why? It must be initialised if you rely on a initialised value in the
> code.

That comment most certainly is 100% incorrect.  The following:

static char foo[16];

has a well defined value when you read from it before writing to it.
If you think otherwise, suggest you read any specification of the C
language.

> But I don't think that this in in case here. Can you tell me the
> code where you read from command_line before writing to it?

That wasn't my point.

Anyway, here's what the GCC manual has to say about use of
__attribute__((section)) on variables:

`section ("SECTION-NAME")'
     Use the `section' attribute with an _initialized_ definition of a
     _global_ variable, as shown in the example.  GCC issues a warning
     and otherwise ignores the `section' attribute in uninitialized
     variable declarations.

     You may only use the `section' attribute with a fully initialized
     global definition because of the way linkers work.  The linker
     requires each object be defined once, with the exception that
     uninitialized variables tentatively go in the `common' (or `bss')
     section and can be multiply "defined".  You can force a variable
     to be initialized with the `-fno-common' flag or the `nocommon'
     attribute.

which reflects precisely what I've been saying concerning the addition
of __initdata.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
