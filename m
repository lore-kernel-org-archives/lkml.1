Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZHPAd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZHPAd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 20:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZHPAd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 20:33:28 -0400
Received: from thunk.org ([69.25.196.29]:53448 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZHPAd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 20:33:27 -0400
Date: Sat, 15 Aug 2009 20:33:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Wagner <daw@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090816003326.GC7554@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Wagner <daw@cs.berkeley.edu>, linux-kernel@vger.kernel.org
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 03:21:27PM -0700, David Wagner wrote:
> At Usenix Security 2009, two researchers announced last week a new
> security vulnerability in multi-user Linux systems.  They demonstrated
> that one user can, in many cases, recover partial information about
> the keystrokes that another user types into applications running on
> that system.  For instance, they demonstrate how a malicious user can
> recover partial information about SSH passwords typed by other users,
> reducing the password search space by a factor of 250-2000x in
> their experiments.  Thus, this could facilitate password recovery.
> 
> In a nutshell, they exploit the fact that many files in /proc are
> world-readable yet contain sensitive information that can leak information
> about inter-keystroke timings.  For instance, /proc/$PID/stat reveals the
> ESP and EIP registers of the associated process, and is world-readable.
> /proc/pid/status is also mentioned as revealing information that could
> be exploited in these attacks.

A configuration option which defaults to disabling ESP and EIP would
be a simple way to prevent this specific instance of information
leakage.  The problem is there are other files that might reveal
timing information, but which are very useful for a system
administrator.  A key example of this is /proc/$pid/wchan, which is
responsible for the WCHAN column is a ps listing.

Maybe the better example, othter than making some of these files
non-world-readable, or zeroing out certain fields in /proc/$PID/stat,
is to put in a limit to how quickly specific files can be queried.  If
a process's /proc files which could be used to extract keystroke
timing information, is accessed more than say, ten times a second, a
random delay could be added before the information is returned.

Essentially, we can treat this as a covert channel that needs to be
restricted off, without necessarily completely removing the ability
for a system administrator to see what processes are blocked on via
"ps lx".

							- Ted
