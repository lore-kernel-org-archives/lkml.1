Return-Path: <linux-kernel-owner+w=401wt.eu-S1946050AbXBCOFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946050AbXBCOFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 09:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946449AbXBCOFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 09:05:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:49350 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946050AbXBCOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 09:05:18 -0500
Date: Sat, 3 Feb 2007 15:04:23 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag string
 termination trick
In-Reply-To: <Pine.LNX.4.61.0702031213220.27840@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.58.0702031350360.2384@be1.lrz>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
 <Pine.LNX.4.61.0702031213220.27840@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1//SX9nbQnxHPHA3Jr1pQey6654UzEqSBnRiAaJ4r12TJTAHTm3bmhErvyJGgbbszDv/GZ2cY3OsOOuYTPfUm+1t8kDhgaFNNMAipPqz3afXQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Jan Engelhardt wrote:
> On Feb 3 2007 03:08, Bodo Eggert wrote:

> >This patch changes the module license handling code to:
> >- allow modules to have multiple licenses
> >- access GPL symbols if at least one license is GPL-compatible
> 
> I strongly nak that. If you combine two object files (e.g. foo.o, bar.o)
> that have different licenses, the resulting object file (comb.o) IMHO
> constitutes a combined work, and hence the GPL should be applied to all of
> it. That obviously "does not work" - what good is a GPL comb.o file if you
> don't have the source to bar.o? I think a module (.ko) should be denied
> access to GPL symbols if any of the MODULE_LICENSE()s are not GPL.

IMO it's called MODULE_LICENSE, not CFILE_LICENSE, therefore license 
strings in the module apply to the complete module.

> Otherwise, ndiswrapper, CiscoVPN, etc. would just add a dummy.c GPL file
> with a MODULE_LICENSE("GPL") in there and get the symbols.

Using an extra GPL .o is like MODULE_LICENSE("GPL")/* for nothing*/;,
you can't really do something about it.

> Though you
> could still get at the GPL symbols by use of a dedicated wrapper (think
> nvidia kernel module), I would not want to make it easier for them by
> allowing your two points. At best, foo.o and bar.o should be compiled
> independently to foo.ko and bar.ko and work with EXPORT_SYMBOLs.

IMO, using separate modules is the only thing you can do if you don't want 
to license your complete code using GPL.

> >The license handling code was kind of strange:
> > - The kernel itself would only consider the first license, while modpost
> >   looks at all of them.
> > - If you offer your module under a non-GPL license in addition to GPL,
> >   modpost would consider this module to be non-GPL. Therefore you can't
> >   say MODULE_LICENSE("GPL");\nMODULE_LICENSE("completely free");
> 
> The idea to allow MODULE_LICENSE("GPL");\nMODULE_LICENSE("Public Domain");
> is good, but how would you interpret an .o file (with no source!) with
> MODULE_LICENSE("GPL");\nMODULE_LICENSE("Proprietary") ? (Well, see above)

reiserfs is available under a Proprietary license, too. Obviously this is OK.

> >Prohibiting the \0-trick is done by storing the length of the license
> >behind the license itself, uuencoded, as $=xyz.
> >
> >Currently, only 18 bits (256 KB) of the length are stored, but storing up
> >to 30 bits is possible without changing anything besides the macro.
> >
> >You can still trick this code by including "...\0license=GPL\0$=$\0..." or
> >by manually fabricating this string into .modinfo. Fix: Document this to
> >mean that you actually GPL-license the module. 
> 
> $=$ is interpreted as what? [Ah ok, uuencoded uint32_t] That does not look
> good. What if the length thing does not immediately come after the license
> string? (E.g. someone hand-crafted a .ko)

In this case, the tag is not recognized and will be skipped as if it were
misspelled. I could also just bail out and deny loading the module.

> static const char *const gpl_compatible[];
> 
> >+	    "GPL",
> >+		"GPL v2",
> >+		"GPL and additional rights",
> >+		"Dual BSD/GPL",
> >+		"Dual MIT/GPL",
> >+		"Dual MPL/GPL",
> 
> If we allowed multiple MODULE_LICENSE()s, all the Dual XYZ/GPL
> combinations and so can go, since it would be possible to have
> MODULE_LICENSE("GPL")\nMODULE_LICENSE("BSD");, simplifying the
> module loader code.

ACK, and "BSD" etc. should be included. I kept the combinations for 
backward-compatibility. Possibly we could warn on using them.

-- 
A bone to the dog is not charity. Charity is the bone shared with the dog, when
you are just as hungry as the dog.
	-- Jack London
