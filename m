Return-Path: <linux-kernel-owner+w=401wt.eu-S1946054AbXEAW5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946054AbXEAW5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946051AbXEAW5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:57:51 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:50172 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946056AbXEAW5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:57:49 -0400
Date: Tue, 1 May 2007 15:57:47 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Simon Arlott <simon@fire.lp0.eu>
cc: Markus Rechberger <mrechberger@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Manu Abraham <abraham.manu@gmail.com>,
       Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       helge.hafting@aitel.hist.no, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
In-Reply-To: <4636E0E2.5020601@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
 <4636E0E2.5020601@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Simon Arlott wrote:
> On 30/04/07 22:17, Markus Rechberger wrote:
> > From my side I do not see any problem with that patch, if someone else
> > has a problem with it please state out the reason.
>
> I have no problem with the patch since it has nothing to do with my DVB
> card but you're only encouraging Uwe to be abusive since it seems to
> help get him what he wants:

I've been aware of the problem with dst not fully using the dvb customization
systems(*) for a long time.  It came up when dvb_attach() et al were first
being integrated, well before any rejected patches or strongly worded emails
or whatever from certain people that I'm aware of.

I saw some discussion about dst by Markus, Mauro, and Andrew Morton, and since
I already know about the issues here, I felt I should post a patch for them
any other reasonable developers who might spend time on this.

If there is an abusive person, I'm not going to let it affect my behavior.
You lose if you let them influence your decisions one way, or influence them
another way.


(*) There are two customization/dependency control systems in DVB.  One is
dvb_attach(), the other is DVB_FE_CUSTOMISE.  They are not two entirely
separate systems, but overlap in their design a great deal.

The significant part, common to both, is the overall design of the driver
framework.  DVB uses what I would describe as an object oriented system.  A
driver for a certain type of hardware exports a single attach function, which
returns an object for one instance of that hardware.  All control of that
hardware is done via methods defined in this object.  There is typical
hierarchy, where an 'adapter' object will contain a 'frontend' object which
will contain a 'tuner' object.  Of course hardware designers are not
constrained by the software frameworks we create, so sometimes it's more
complex (e.g., dst).

This design means the actual hard link between different drivers is limited to
each driver's single attach function (**).  By breaking this one link, we can
control which drivers must be loaded or linked to only those necessary or
wanted.  dvb_attach() and DVB_FE_CUSTOMISE are two different ways of
controlling these links.

dvb_attach() is based on symbol_request()
A.  It's only useful with modules
B.  It doesn't prevent drivers from being compiled
C.  It allows one to build support for hardware, yet not actually load that
    support until it is needed.  This allows supporting a wide array of
    possible hardware without a large amount of wasted resources, useful for
    distribution kernels for example.

DVB_FE_CUSTOMISE is based on Kconfig and static inline stub functions
A.  It works with drivers compiled into the kernel, not using modules.
B.  It prevents drivers from even being compiled in the first place.
C.  Disabled drivers are truly disabled, it is not possible to have support
    for hardware and yet not load it.
This is useful for the smallest & simplest kernel, for set top boxes and the
like.  It's entirely possible to use both at once:  compile some drivers into
your kernel, leave others as modules, not compile modules for hardware you
don't have, only load the modules for the hardware you are using at the
moment, and still support hardware you might connect later.


(**) The dvb-pll module still exports more symbols than just dvb_pll_attach(),
that is why the customization systems don't fully work with it yet.  It also
exports dvb_pll_configure(), an obsolete interface which only a couple
remaining users that have yet been converted.  And it exports PLL definition
structs, which isn't a difficult problem and I know several ways to fix it, we
just haven't decided or actually done it yet.
