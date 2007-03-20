Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXCTVHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXCTVHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXCTVHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:07:00 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46496 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753900AbXCTVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:06:58 -0400
Date: Tue, 20 Mar 2007 22:06:51 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: kconfig `bool' (was: Re: [PATCH 13/13] fix ps3fb glue allowing a
 modular build)
In-Reply-To: <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.62.0703202148150.22113@pademelon.sonytel.be>
References: <E1HRPbU-0003Ha-Oq@ZenIV.linux.org.uk>
 <Pine.LNX.4.62.0703141040030.28462@pademelon.sonytel.be>
 <20070314160258.GK4095@ftp.linux.org.uk> <Pine.LNX.4.62.0703141715570.28462@pademelon.sonytel.be>
 <20070314170720.GL4095@ftp.linux.org.uk> <Pine.LNX.4.64.0703141016060.9690@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Linus Torvalds wrote:
> On Wed, 14 Mar 2007, Al Viro wrote:
> > Nope.  How can kconfig distinguish that from a boolean option in modular
> > driver?  bool *can* depend on tristate and be selected when tristate is
> > set to m.
> 
> Btw, this is one of those things that easily causes problems.
> 
> In many ways it would be nice if we had two different kinds of "bool": one 
> where "m" in the dependency chain means "y" is ok, and one where "m" means 
> "n".
> 
> We used to have "dep_bool" and "dep_mbool" for this, a long time ago. It 
> got dropped in the Kconfig language rewrite, and I think it was a mistake.
> 
> So I think it would be nice to re-introduce it. As it is, we have a number 
> of Kconfig language constructs that are just unnecessarily hard to 
> understand, because we end up having to add a "= y" or similar.
> 
> The rule *used* to be: "dep_mbool" was a boolean that was valid even for 
> modules, while "dep_bool" was a boolean that was valid only for straigth 
> "y", and a module would turn it off.
> 
> Maybe not "bool" vs "mbool", but it might be nice to have
> 
> 	bool FB_PS3
> 		depends strictly on FB
> 
> ie a "depends strictly" refuses to upgrade a bool dependency from "m" to 
> "y", while a regular depends allows it.
> 
> Or something.. The "depends strictly on X" thing would really be just a 
> mental shorthand for "depends on (X)=y" (it's actually longer to type, but 
> I think it's a bit more intuitive, thus "mental shortcut").

I've been thinking about this a bit more...

Kconfig knows about the following types:
  o bool
  o tristate
  o string
  o hex
  o int

However, from a semantical point of view, they can be subdivided in 2 classes:
  1. driver/subsystem/library enablers (i.e. things that are used in a Makefile
     to decide whether to compile a unit or not):
       o tristate (y=builtin, m=loadable, n=disabled)
       o bool (y=builtin, n=disabled)
  2. options (i.e. things that control some features, limits, or default
     values):
       o bool (y=true, n=false)
       o string (literal)
       o hex (literal)
       o int (literal)

The confusion arises from the 2 different semantics for `bool': for the former,
a `depends on' obviously cannot be `builtin' if the dependency is `modular',
while for the latter, it can be `true' if the dependency is `modular'.

It would be nice if Kconfig would make the distinction between the two types of
`bool' explicit.  Anyone with a good replacement name for the first type of
`bool'? I can't find one.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
