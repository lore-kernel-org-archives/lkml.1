Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZHFWrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZHFWrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbZHFWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:47:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZHFWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:47:07 -0400
Date: Thu, 6 Aug 2009 18:47:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Greg KH <gregkh@suse.de>
cc: Roland Dreier <rdreier@cisco.com>, Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: drivers/staging/meilhaus build broken with ftrace
In-Reply-To: <20090806222906.GA14792@suse.de>
Message-ID: <alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com>
References: <ada4oskfwtp.fsf@cisco.com> <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com> <20090806222906.GA14792@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Aug 2009, Greg KH wrote:

> On Thu, Aug 06, 2009 at 05:46:57PM -0400, Steven Rostedt wrote:
> > 
> > Hi Roland,
> > 
> > On Thu, 6 Aug 2009, Roland Dreier wrote:
> > 
> > > Commit fc4c7355 ("ftrace: Fix the conditional that updates $ref_func")
> > > breaks the build of drivers/staging/meilhaus with ftrace enabled:
> > > 
> > >       CC [M]  drivers/staging/meilhaus/me0600_device.o
> > >     No function to reference at scripts/recordmcount.pl line 339, <IN> line 258.
> > >     make[4]: *** [drivers/staging/meilhaus/me0600_device.o] Error 9
> > > 
> > > Yes, that's crazy, but the situation is the following:
> > > 
> > >  - for some reason I can't fathom, the meilhaus driver declares
> > >    me0600_pci_constructor() as weak in drivers/staging/meilhaus/me0600_device.h
> > > 
> > >  - me0600_pci_constructor() is the only function in .text in
> > >    drivers/staging/meilhaus/me0600_device.c
> > > 
> > > so recordmcount.pl ends up finding only one weak function in .text, and
> > > so it never sets $ref_func before calling update_funcs().
> > 
> > Ug, I figured this would happen. I think I have a patch somewhere that can
> > handle this.
> 
> Don't make ftrace do a lot of work if it's a bug in the staging driver.
> Odds are the code in there should be fixed instead, I'll gladly take a
> patch to do that.

Yes the module did something funky, but what broke recordmcount.pl was not 
something that is not allowed. The code broke because a weak function was 
the only function in a section. This patch keeps it from crashing.

Hmm, maybe I should make it warn, because a weak function by itself in a 
section will not be traced.

-- Steve

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d29baa2..979da4b 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -393,7 +393,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if ($text_found);
+	update_funcs() if (defined($ref_func));
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -441,7 +441,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if ($text_found);
+update_funcs() if (defined($ref_func));
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
