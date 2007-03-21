Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXCUMAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXCUMAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXCUMAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:00:48 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:43316 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXCUMAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:00:47 -0400
Date: Wed, 21 Mar 2007 12:59:37 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: kconfig `bool' (was: Re: [PATCH 13/13] fix ps3fb glue allowing
 a modular build)
In-Reply-To: <Pine.LNX.4.62.0703202148150.22113@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.64.0703211244150.14457@scrub.home>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
 <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
 <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
 <20070314170720.GL4095@ftp.linux.org.uk> <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
 <Pine.LNX.4.62.0703202148150.22113@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 20 Mar 2007, Geert Uytterhoeven wrote:

> On Wed, 14 Mar 2007, Linus Torvalds wrote:
> > In many ways it would be nice if we had two different kinds of "bool": one 
> > where "m" in the dependency chain means "y" is ok, and one where "m" means 
> > "n".
> > 
> > We used to have "dep_bool" and "dep_mbool" for this, a long time ago. It 
> > got dropped in the Kconfig language rewrite, and I think it was a mistake.

Well, it wasn't really dropped, just the syntax changed...
There were only one or two rules which depended on the dep_bool syntax and 
it were special cases anyway.

> > So I think it would be nice to re-introduce it. As it is, we have a number 
> > of Kconfig language constructs that are just unnecessarily hard to 
> > understand, because we end up having to add a "= y" or similar.
> > 
> > The rule *used* to be: "dep_mbool" was a boolean that was valid even for 
> > modules, while "dep_bool" was a boolean that was valid only for straigth 
> > "y", and a module would turn it off.
> > 
> > Maybe not "bool" vs "mbool", but it might be nice to have
> > 
> > 	bool FB_PS3
> > 		depends strictly on FB
> > 
> > ie a "depends strictly" refuses to upgrade a bool dependency from "m" to 
> > "y", while a regular depends allows it.
> > 
> > Or something.. The "depends strictly on X" thing would really be just a 
> > mental shorthand for "depends on (X)=y" (it's actually longer to type, but 
> > I think it's a bit more intuitive, thus "mental shortcut").

I'm not sure this would really an improvement, for the casual reader X=y 
is IMO more readable if he knows the basic kconfig syntax, whereas he had 
to lookup first what "strictly" means. Also the potential user had to know 
about this syntax, but it's simply not needed often enough that it would 
be common and might be easily forgotten if one fixed the driver and 
changed the bool to tristate.

> I've been thinking about this a bit more...
> 
> Kconfig knows about the following types:
>   o bool
>   o tristate
>   o string
>   o hex
>   o int
> 
> However, from a semantical point of view, they can be subdivided in 2 classes:
>   1. driver/subsystem/library enablers (i.e. things that are used in a Makefile
>      to decide whether to compile a unit or not):
>        o tristate (y=builtin, m=loadable, n=disabled)
>        o bool (y=builtin, n=disabled)
>   2. options (i.e. things that control some features, limits, or default
>      values):
>        o bool (y=true, n=false)
>        o string (literal)
>        o hex (literal)
>        o int (literal)
> 
> The confusion arises from the 2 different semantics for `bool': for the former,
> a `depends on' obviously cannot be `builtin' if the dependency is `modular',
> while for the latter, it can be `true' if the dependency is `modular'.

What I'm considering in this context is to introduce a syntax to 
specifically describe modules (e.g. to also generate the Makefile from 
it):

module FB_PS3
	bool ".."
	depends on FB

In this context it would be valid to add the requirement that the 
dependencies must be 'y'.

bye, Roman
