Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbZEANZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbZEANZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZEANZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:25:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7560 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbZEANZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CKi570qh9FlRzq/BnDooe+SkSax68ajJvV4dnYg3oFwyce1kgo1Lx9lqkEV4i+xzhk
         s6Hb19NdZbccvtiT205T1ehQnZUIruK4NKJS8uQvATuWG4Jje4CQ6hC2K1za3MTVZz6L
         QV3LMUb1Iif8suMCfEu16KZuKmL+bV++YvKGM=
Date: Fri, 1 May 2009 15:25:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 4/6] kill-the-BKL/reiserfs: release the write lock
	inside get_neighbors()
Message-ID: <20090501132506.GD6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-5-git-send-email-fweisbec@gmail.com> <20090501055135.GF5983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501055135.GF5983@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:51:35AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > get_neighbors() is used to get the left and/or right blocks 
> > against a given one in order to balance a tree.
> > 
> > sb_bread() is used to read the buffer of these neighors blocks and 
> > while it waits for this operation, it might sleep.
> > 
> > The bkl was released at this point, and then we can also release 
> > the write lock before calling sb_bread().
> > 
> > This is safe because if the filesystem is changed after this lock 
> > release, the function returns REPEAT_SEARCH (aka SCHEDULE_OCCURRED 
> > in the function header comments) in order to repeat the neighbhor 
> > research.
> > 
> > [ Impact: release the reiserfs write lock when it is not needed ]
> 
> This should also be safe because under the BKL we _already_ dropped 
> the lock when sb_bread() blocked (which it really would in the 
> normal case).
> 
> There's one special case to consider though: sb_read() maps to 
> __bread() which can return without sleeping if the bh is already 
> uptodate. So if the filesystem _knows_ that the bh is already 
> uptodate and holds a reference to it (this is common pattern in 
> filesystems), it can have a locking assumption on that.
> 
> No such assumption seems to be present here though.
> 
> 	Ingo


Yeah, fortunately it doesn't base its check on the state of the
buffer but on the tree number of rebalancing.

But I have to remember this pattern, it could be present elsewhere
in reiserfs.

Thanks.

