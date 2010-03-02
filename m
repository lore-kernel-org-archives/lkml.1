Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0CBPTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:19:38 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:56181 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343Ab0CBPTg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:19:36 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in git tree
Date: Tue, 2 Mar 2010 16:19:32 +0100
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
References: <20100301042249.GA12289@linux.vnet.ibm.com> <201003012129.36937.elendil@planet.nl> <20100302011633.GJ6758@linux.vnet.ibm.com>
In-Reply-To: <20100302011633.GJ6758@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003021619.34793.elendil@planet.nl>
X-OriginalArrivalTime: 02 Mar 2010 15:19:35.0624 (UTC) FILETIME=[C4731480:01CABA1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010, Paul E. McKenney wrote:
> Sigh!  Because popen() doesn't fail when the command is bogus, it seems.
> I now do stat() to check for it existing, and that seems to handle the
> remote-output case.

Cool. Did you check if it's really necessary to treat the two cases 
separately? I would expect srctree to always be set, and if I read the 
root Makefile correctly that's indeed the case:
srctree         := $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))

Hmm. I see you've switched from SRCTREE to KBUILD_SRC. Is that correct? 
SCRTREE is also used elsewhere in the same file and that's the variable 
(in lower case; the upper case variant is a C define) that's explicitly 
exported in the root Makefile.

> > One other thing. I wonder if this implementation will always reliably
> > result in the *current* SHA1 being included in the .config. AFAICT
> > the .config only actually gets written if there are changes, or if you
> > explicitly do a 'make oldconfig'.
> >
> > But if you e.g. pull a stable update and just run 'make', the .config
> > will likely remain unchanged and will thus still contain the SHA1 from
> > a previous build.
>
> Good point.  But the same is true of the Linux kernel version
> identifier, right?

Right. But the increased precision of the SHA1 IMO also demands an 
increased reliability of its accuracy: if it's not accurate it loses its 
value.

Personally I think that maybe the config file is not the correct place for 
this. For one thing users may well send a config file that's not the 100% 
exact one used to build the kernel when they know it's close enough that 
it makes no practical difference (I know I've done so in the past).

Wouldn't it be more logical to include the line in the dmesg output? My 
preference would be a separate line below the existing (Linux version) 
line. That line could only be output if the kernel was built from a VCS.
It could then even be repeated in oops output.

That would also solve the problem of the config file not being updated.

Paul E. McKenney wrote:
>> I'd hate to have that run every time I make a kernel.
> 
> Good point...  Should we have an environment variable that controls this
> behavior?

I would suggest at most a general enabled/disabled switch (distros might 
prefer to disable it too), and not more detailed settings to control 
whether or not to include dirty or whatnot.

Cheers,
FJP
