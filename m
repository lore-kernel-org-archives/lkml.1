Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbZIDRyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbZIDRyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933803AbZIDRyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:54:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933790AbZIDRyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:54:19 -0400
Date: Fri, 4 Sep 2009 07:53:29 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <19105.5352.28380.230615@pilspetsen.it.uu.se> <alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, Linus Torvalds wrote:
> 
> And I suspect that that means that the bug is related to do_output_char() 
> expanding '\n' into '\r\n'. And the different buffering (and the pty 
> 'space' logic) just means that we now hit a case that we didn't use to 
> hit. The relevant call chain is
> 
>  - n_tty handling:
> 	n_tty_write() ->
> 	  process_output() ->
> 	    do_output_char() ->
> 	      tty_put_char(tty, '\r')
> 	      tty_put_char(tty, '\n')

Hmm. I think I have a clue.

process_output() does

        space = tty_write_room(tty);
        retval = do_output_char(c, tty, space);

so 'space' can never become off-by-one, since it's always re-calculated 
just before. And do_output_char() checks that there is room for two 
characters, and won't do just the '\r'.

So the fact that you see the '\r' and not the '\n' means that something 
dropped the second character _despite_ tty_write_room() saying there was 
room for two characters.

Now, with flow control that can in theory happen in case 'tty->stopped' 
gets set asynchronously in between, but that's not an issue here. 

So the most likely cause is just that the pty_write_room() function is 
simply buggered, or at least doesn't work together with the new world 
order.

How about something like this? It's way too anal - it says that we can 
only write data if there's enough space to always push it all the way to 
the receive buffer (including all the data that was already buffered up, 
ie the "memory_used" part). But if it finally makes the problem go away, 
we have another clue.

		Linus

