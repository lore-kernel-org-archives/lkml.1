Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbXEPOYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbXEPOYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbXEPOYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:24:32 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60594 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbXEPOYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:24:31 -0400
Message-ID: <464B141E.3020400@s5r6.in-berlin.de>
Date: Wed, 16 May 2007 16:24:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk> <20070516033335.GH4095@ftp.linux.org.uk>
In-Reply-To: <20070516033335.GH4095@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
>> stuff that does select USB should depend on USB_ARCH_HAS_HCD, or we'll
>> end up with unbuildable configs.
> 
> BTW, this kind of situation happens often enough, so how about doing
> the following: teach kconfig that if FOO selects BAR and BAR depends
> on <expr>, we should act as if FOO had explicit depends on <expr>.

"A... select B" is just a flavor of "A... depends on B", with the
additional instruction to the Kconfig UIs:  Don't hide A if you can
silently switch on B.

So, since it is just a flavor of 'depend on', it is very obvious that it
has to propagate indirect dependencies just like 'depends on' does.

[...]
> the only thing I'm not sure how to deal
> with is how to show such inherited dependencies in menuconfig et.al.

How about throwing "select" out of the Kconfig language and improving
the UIs instead, so that users find what they want and need?

Compare to software package management.  I think most of the package
management systems store merely plain dependencies in the package
metadata.  The package manager UIs then allow users to auto-select all
packages which package A depends on, show him what was selected, let him
edit his choice before massive downloads, et cetera.  Also, package
manager UIs often offer some collections of typically used packages and
so on.  I don't think the package metadata already contain some
instructions which stuff to pre-select for the user.  It's all in the UIs.

Back to Kconfig.

We have

  - driver-like options which enable building of certain functionality.
    They often depend on multiple other options higher up, either by
    directly depending on one other option which itself may depend on
    others, or even by directly depending on several options (which each
    may depend others.)
    The driver-like options are the ones that are most relevant to users
    because they ultimately decide what the kernel can do.

  - Tunables which modify how those driver-like code will behave.

  - Infrastructure (subsystem cores), libraries.
    Nobody really cares about these on their own, we only want have all
    those of them built which serve above mentioned driver-like options.

Did I forget anything?

So, we put

  - metadata about kernel parts (what do they, what are their
    dependencies)
    into Kconfig files,

  - methods to produce .configs (which honor the dependencies and
    reflect which kernel functionality the user wanted)
    into "make fooconfig" programs,

  - user interfaces which control these methods
    into "make fooconfig" programs.

The goal is to let the user safely and efficiently enable everything he
needs/ disable everything he doesn't need.

The question is:  Which kind of information has to be put into the
Kconfig files to achieve this objective --- besides the plain
information about dependencies and human-readable information about the
functionality of the options?

Do we need instructions like "select" in Kconfig files, or do we rather
need more powerful "make fooconfig" programs?

PS:  Actually, the problems with "select" which Al pointed out in the
parent post show that "select" doesn't really let us get by with less
powerful "make fooconfig" programs, because proper treatment of
"depends" is sometimes nontrivial.

PPS:  Other current discussions indicate that additional metadata in the
Kconfigs might perhaps be useful, e.g. metadata about a kernel part's
lifecycle status (experimental, deprecated et al).
-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/
