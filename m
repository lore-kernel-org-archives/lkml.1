Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbXILWoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbXILWoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXILWoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:44:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39153 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751915AbXILWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:44:31 -0400
Date: Wed, 12 Sep 2007 17:44:30 -0500 (CDT)
From: Brent Casavant <bcasavan@sgi.com>
Reply-To: Brent Casavant <bcasavan@sgi.com>
To: Andreas Schwab <schwab@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <jetzpza7ci.fsf@sykes.suse.de>
Message-ID: <20070912172519.N5573@pkunk.americas.sgi.com>
References: <20070912144128.D5573@pkunk.americas.sgi.com> <jetzpza7ci.fsf@sykes.suse.de>
Organization: Silicon Graphics, Inc.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Andreas Schwab wrote:

> Brent Casavant <bcasavan@sgi.com> writes:
> 
> > I could mmap a temporary tmpfs file (tmpfs so that if there is a
> > machine crash no sensitive data persists) which is created with
> > permissions of 0, immediately unlink it, and pass the file
> > descriptor through an AF_UNIX socket.  This does open up a very
> > small window of vulnerability if another process is able to chmod
> > the file and open it before the unlink.
> 
> Only the owner can chmod a file, so why is that a vulnerability?

In this particular case because the user may not normally have direct
access to some of the data to be contained in that file.

Decryption keys in a key management system, in particular.  If the
keys are passed over secure network links such that they only ever
exist in system RAM, and are not reachable via the filesystem, these
keys can be protected from disclosure to the user (short of /proc/#/mem
type of tricks).  However, if there is even a brief window when the
user can gain access to the file, these keys are at risk of disclosure.

The problem can be addressed, in this case, by having the daemon half
of the design create these files, however it would provide a bit more
flexibility if the client side was also capable of creating them.  It's
not a make-or-break problem, by any means, but does somewhat motivate
an O_NOLINK flag for open().

Brent

P.S. By the way, there doesn't seem to be a way to remove /proc/#/mem
     files.  That might be an additional nicety -- programs worried about
     being snooped could unlink their own entry.  /dev/mem and /dev/kmem
     can simply be removed by the sysadmin of such a system.  If all of
     that were done you'd have to resort to attacking crash dumps, core
     dumps, or via something like kdb to extract "hidden" data.

-- 
Brent Casavant                          All music is folk music.  I ain't
bcasavan@sgi.com                        never heard a horse sing a song.
Silicon Graphics, Inc.                    -- Louis Armstrong
