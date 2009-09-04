Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZIDRbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZIDRbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZIDRby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:31:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZIDRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:31:53 -0400
Date: Fri, 4 Sep 2009 07:30:43 -1000 (HST)
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
In-Reply-To: <19105.5352.28380.230615@pilspetsen.it.uu.se>
Message-ID: <alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <19105.5352.28380.230615@pilspetsen.it.uu.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, Mikael Pettersson wrote:
> 
> Comparing the gcc outputs for this test case from runs with 2.6.30 and
> 2.6.31-rc8 shows that 2.6.31-rc8 lost a single newline (\n) byte at byte
> offset 131660. So two lines of diagnostics were fused together and the
> testsuite framework failed to match the second of those lines.

Goodie. That was the kind of hint I was looking for.

And I suspect that that means that the bug is related to do_output_char() 
expanding '\n' into '\r\n'. And the different buffering (and the pty 
'space' logic) just means that we now hit a case that we didn't use to 
hit. The relevant call chain is

 - n_tty handling:
	n_tty_write() ->
	  process_output() ->
	    do_output_char() ->
	      tty_put_char(tty, '\r')
	      tty_put_char(tty, '\n')

I'll see what I can find. But your "loses \n character" does mean that the 
'lost bytes at the end when the other end closed it' is probably not the 
issue, and we're talking about a different kind of bug entirely.

			Linus
