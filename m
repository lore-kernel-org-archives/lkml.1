Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXEaRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXEaRnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXEaRnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:43:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:34616 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXEaRnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=OJ5KNO0t/kIQLcnJp6YaBYxzcY9T0mHYXVtOuEbe4Hf7fCpwavyozMrpYvvKO8dVvIwpTejvRH6vrenLqhEloTmsBbqPwVYz6VcuxKAYEOGlUVDTsoLNhEFw8VyhqaY8zapDuiLwSNCA0K3qhjPi79eI7tDm9B1iicv3LgVXKEE=
Date: Thu, 31 May 2007 21:42:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070531174201.GB8392@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465DF91F.3010201@sandeen.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Sandeen - Wed, May 30, 2007 at 05:22:23PM -0500]
| Eric Sandeen wrote:
| 
| > Jan, something seems busted here.  I'm getting lockups when testing udf
| > on a single cpu with this last patch in place...
| > 
| > I think it's the BKL stumbling on itself.
| 
| To demonstrate, try this:
| 
| # BIGFILENAME=`seq -s '' 1 1000`
| # ln -s $BIGFILENAME foo
| 
| instant deadlock :(
| 
| -Eric
| 

Eric, could you please try the following:

1) declare the spinlock in the top of inode.c as

	DEFINE_SPINLOCK(udf_drop_lock);

2) replace in udf_drop_inode()

	kernel_lock -> spin_lock(&udf_drop_lock);
	kernel_unlock -> spin_unlock(&udf_drop_lock);

I'm not sure if it help but you may try ;)

		Cyrill

