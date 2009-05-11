Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZEKTtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZEKTtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZEKTtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:49:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38487 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZEKTtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:49:22 -0400
Date: Mon, 11 May 2009 20:49:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] dup2: Fix return value with oldfd == newfd and invalid
	fd
Message-ID: <20090511194922.GL8633@ZenIV.linux.org.uk>
References: <4A086D9E.60308@suse.com> <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain> <20090511191142.GK8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0905111220270.3586@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905111220270.3586@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 12:26:59PM -0700, Linus Torvalds wrote:

> Hmm. They've been "unsigned int" for as long as our history goes back 
> (including BK), but yes, making them "int" would have hidden this issue as 
> well. 
> 
> That said, I think we had reasons to do our fd's as unsigned, ie the whole 
> "compare against MAX" thing that doesn't take negative values into 
> account.
> 
> In fact, I think we should do more of those. Right now we literally depend 
> on things like "max_fds" being "unsigned int", and that the compiler then 
> turns all the
> 
> 	if (fd < fdt->max_fds)
> 
> tests silently into unsigned tests even when 'fd' is 'int'.
> 
> So I suspect we should probably make fs/file.c use _more_ "unsigned int" 
> rather than having less of them.

What we should do is a careful review of the propagation paths of file
descriptors ;-/  As it is, we have an interesting mix of int/unsigned/long
used to carry those around, and quite a few of those are used for -E...
as well.  Note, BTW, that for userland code this bug mostly isn't - libc will
convert that value to int before returning to caller, so sign expansion or
not, we won't notice.  The things like strace will, though...
