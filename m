Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0BAWeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:34:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60031 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab0BAWeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:34:11 -0500
Date: Mon, 1 Feb 2010 22:34:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100201223410.GB12882@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201222511.GA12882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:25:11PM +0000, Al Viro wrote:
> 	There's a lot of places doing printks with ->d_name of various
> dentries.  Unfortunately, as often as not they are b0rken due to races
> with rename().
> 
> 	I propose to add a new format - %pd.  It would print dentry name.
> However, unlike everything else in vsnprintf, it would NOT be locking-agnostic.
> It would grab and release dentry->d_lock.  And yes, I hate that as much as
> anyone.  I don't see any sane alternative.
> 
> 	Patch below implements it and fixes some obvious races in ocfs2
> and ubifs by switch to that sucker.  There are many more places of
> that kind and a _lot_ of those are racy.  Adding ->d_lock in every caller
> is not a good solution, IMO...
> 
> 	Rules are:
> * don't use %pd under dentry->d_lock, use dentry->d_name.name instead; in
> that case it *is* safe.  Incidentally, ->d_lock isn't held a lot.
> * if we don't hold dentry->d_lock, feel free to use %pd....,dentry
> 
> 	Comments?

PS: if it ends up going in, the usual S-o-b applies
