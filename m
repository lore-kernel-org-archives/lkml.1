Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZGVGQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZGVGQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZGVGQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:16:11 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:53197 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZGVGQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:16:10 -0400
Date: Wed, 22 Jul 2009 07:16:30 +0100 (BST)
From: Troy Moure <twmoure@szypr.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Troy Moure <twmoure@szypr.net>, Krzysztof Oledzki <olel@ans.pl>,
       Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907211759180.19335@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0907220618270.2606@troy-laptop>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211759180.19335@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Linus Torvalds wrote:

> > Just out of curiosity, how did you find it? Now that I know where to look, 
> > it's very obvious in the assembler diffs, but I didn't notice it until you 
> > pointed it out just because there is so _much_ of the diffs...
> 
> Ahh. I think I see how you found it. Looking at the diffs, there's only a 
> few places where the number of instructions changed by a big fraction. And 
> there's only _one_ place that has a factor-of-three difference (26 lines 
> in the correct cases, and 7 lines in the wrong one). Clever.

Hmm..that's interesting.  But no, I wasn't that clever.

I actually just started poking around the radeonfb code, since you 
mentioned it looked like that might be where the issue was.  The last 
message printed in the hung kernel is "Monitor 2 type no found" - printed 
from radeon_probe_screens().  And the first message after that in the 
non-hung kernel is "Console: switching to colour frame buffer device", 
which I guessed was printed from register_framebuffer() (since that calls 
notifiers).

So I started looking in radeon_fb_register() between the call to 
radeon_probe_screens() and the call to register_framebuffer(), and tracing 
through the calls it made.  I ignored pci_, sysfs_, etc. calls, thinking 
the driver code was more likely to have a device probing loop or something 
odd like that that could be miscompiled.

For any functions that had a loop or anything strange-looking, I checked 
the assembler diffs.  And after a little while (a half-hour or so, I 
think), I found edid_checksum().  Just the name made me think it was a 
likely culprit, even before I looked at the diff. 

Obviously I got a bit lucky that problem was actually basically where I 
started looking for it.  But I figured even if I didn't find it, I'd learn 
something about the radeonfb code. And who would pass up an opportunity to 
learn about that?

	Troy
