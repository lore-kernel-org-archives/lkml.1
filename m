Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbXHBAJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbXHBAJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXHBAJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:09:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55476 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXHBAJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:09:39 -0400
Date: Thu, 2 Aug 2007 05:52:02 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
In-Reply-To: <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0708020541060.8258@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
 <20070801053509.GA5905@martell.zuzino.mipt.ru>
 <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Aug 2007, Satyam Sharma wrote:

> On Wed, 1 Aug 2007, Alexey Dobriyan wrote:
> 
> > On Tue, Jul 31, 2007 at 10:04:10PM +0530, Satyam Sharma wrote:
> > > Callers (especially "store" functions for sysfs or configfs attributes)
> > > that want to convert an input string to a number may often also want to
> > > check for simple input sanity or allowable range. strtol10_check_range()
> > > of netconsole does this, so extract it out into lib/vsprintf.c, make it
> > > generic w.r.t. base, and export it to the rest of the kernel and modules.
> > [...]
> > 
> > Please, copy strtonum() from BSD instead. Nobody needs another
> > home-grown converter.
> 
> BSD's strtonum(3) is a detestful, horrible shame.
> 
> The strtol_check_range() I implemented here does _all_ that strtonum()
> does, plus is generic w.r.t. base, and minus the tasteless "errstr"
> argument.
> 
> Tell me, how does that "errstr" ever make sense? We _anyway_ return
> errors (-EINVAL or -ERANGE) if any of those cases show up. And
> _because_ we use negative numbers to return errors, we can't use this
> function to convert negative inputs anyway ... an appropriate error
> message can always be outputted by the caller itself. [ hence the
> two WARN_ON's I added here ]

Glargh, lemme take that back :-p

Wait, it takes in an const char ** argument, and then the whole error
return checking is based on the (const char *) *arg, and not the
return value (-EINVAL, -ERANGE) itself. And it appears, we set the
const char **errstr from inside the function only if the caller didn't
explicitly give us a NULL itself ... hmm, it all does make sense, plus
allows to convert negative inputs as well -- now that the error return
checking in the callsite won't be based on the return value anyway
(but strtonum(3) is still a bit daft, in that it "pretends" to return
error values in ret even though the caller can't use that to test if
an error actually occurred).

[ Thankfully there won't be any BSD lovers around here, so probably I'll
  be able to get out of this clean :-) So okay, I'll port it over ... ]


Thanks,
Satyam
