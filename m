Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363Ab0AICWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0AICWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644Ab0AICWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:22:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab0AICWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:22:36 -0500
Date: Fri, 8 Jan 2010 18:22:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Fix up the NFS mmap code
In-Reply-To: <20100109021124.GG30528@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1001081814240.7821@localhost.localdomain>
References: <1262913974.2659.101.camel@localhost> <20100109005624.7473.33215.stgit@localhost.localdomain> <alpine.LFD.2.00.1001081709470.7821@localhost.localdomain> <20100109013825.GD30528@ZenIV.linux.org.uk> <alpine.LFD.2.00.1001081750080.7821@localhost.localdomain>
 <20100109021124.GG30528@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Al Viro wrote:
> 
> Well, sure - it steps on i_mutex-before-mmmap_sem first from ls somewhere and
> records the ordering for posterity.  Then NFS steps into mmap() (on a
> different inode) and gets conflicting ordering.

Look closer: the inodes for directories and for non-directories have 
i_mutex in different lockdep classes.

So that "on a different inode" thing should have made it a non-issue, 
since there is no actual chain back. There is "mmap_sem -> 
i_mutex_regular_file" (for mmap) and there is "i_mutex_directory -> 
mmap_sem" (for filldir), but that isn't an ABBA.

The problem _seems_ to be (if I read Andi's chain correctly) that a 
directory hasn't gone through the i_mutex_dir_key change, so filldir ends 
up being counted against the default i_mutex_key.


		Linus
