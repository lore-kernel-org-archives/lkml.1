Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYCRMzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYCRMzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYCRMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:55:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51235 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYCRMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:55:30 -0400
Date: Tue, 18 Mar 2008 08:54:45 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andreas Schwab <schwab@suse.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
Message-ID: <20080318125445.GS8368@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Michael Tokarev <mjt@tls.msk.ru>, Andreas Schwab <schwab@suse.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <47DEFE26.80101@msgid.tls.msk.ru> <jeabkwaou7.fsf@sykes.suse.de> <47DF6E13.5050709@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DF6E13.5050709@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 10:24:03AM +0300, Michael Tokarev wrote:
> Without digging into implementation details (in this case it's
> the fact that /dev/stdin in linux is implemented using a symlink
> to - f.e. - /dev/tty/0 etc), I expect /dev/stdin to always work
> as far as filedescriptor 0 is open, regardless of any permissions
> on the actual tty (if it's a tty in the first place, which is
> not necessary the case) -- exactly the same as /dev/tty works.

Actually, /dev/stdin is not a symlink to the tty.  It's a symlink to
/proc/self/fd/0:

% ls -lL /dev/stdin
0 crw--w---- 1 tytso tty 136, 1 2008-03-18 08:30 /dev/stdin

The problem is that /proc/self/fd/0 is a symlink open file in
question, and so *it* is a symlink to /dev/pts/0.

The main issue is that at the moment, when you open /proc/self/fd/X,
what you get is a new struct file, since the inode is opened a second
time.  That is why you have to go through the access control checks a
second time, and why there are issues when you have /dev/stdin
pointing to a tty which was owned by user 1, and then when you su to
user 2, you get a "permission denied" error.

On other operating systems, opening /proc/self/fd/X gives you a
duplicate of the file descriptor.  That means that the seek pointer is
also duplicated.  This has been remarked upon before.  Linux 1.2 did
things "right" (as in, the same as Plan 9 and Solaris), but it was
changed in Linux 2.0.  Please see:

http://www.ussg.iu.edu/hypermail/linux/kernel/9609.2/0371.html

and four years later:

http://www.ussg.iu.edu/hypermail/linux/kernel/0002.3/1022.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0002.3/1250.html

I don't see a mention of it in 2004, so I guess that broke the 4 year
cycle, but here it is once again in 2008.  :-)

       	   	      	   	    	   - Ted
