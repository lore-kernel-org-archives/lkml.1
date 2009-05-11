Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZEKT3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZEKT3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbZEKT3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:29:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758675AbZEKT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:29:35 -0400
Date: Mon, 11 May 2009 12:26:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] dup2: Fix return value with oldfd == newfd and invalid
 fd
In-Reply-To: <20090511191142.GK8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0905111220270.3586@localhost.localdomain>
References: <4A086D9E.60308@suse.com> <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain> <20090511191142.GK8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 May 2009, Al Viro wrote:
> 
> I'm not sure that it's a right fix, actually.  Note that userland declaration
> of that sucker is int dup2(int, int); so should we really take unsigned int
> as arguments?

Hmm. They've been "unsigned int" for as long as our history goes back 
(including BK), but yes, making them "int" would have hidden this issue as 
well. 

That said, I think we had reasons to do our fd's as unsigned, ie the whole 
"compare against MAX" thing that doesn't take negative values into 
account.

In fact, I think we should do more of those. Right now we literally depend 
on things like "max_fds" being "unsigned int", and that the compiler then 
turns all the

	if (fd < fdt->max_fds)

tests silently into unsigned tests even when 'fd' is 'int'.

So I suspect we should probably make fs/file.c use _more_ "unsigned int" 
rather than having less of them.

			Linus
