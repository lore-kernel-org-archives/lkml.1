Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZEAFvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZEAFvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZEAFvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:51:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZEAFvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:51:43 -0400
Date: Fri, 1 May 2009 07:51:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 4/6] kill-the-BKL/reiserfs: release the write lock
	inside get_neighbors()
Message-ID: <20090501055135.GF5983@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241145862-21700-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> get_neighbors() is used to get the left and/or right blocks 
> against a given one in order to balance a tree.
> 
> sb_bread() is used to read the buffer of these neighors blocks and 
> while it waits for this operation, it might sleep.
> 
> The bkl was released at this point, and then we can also release 
> the write lock before calling sb_bread().
> 
> This is safe because if the filesystem is changed after this lock 
> release, the function returns REPEAT_SEARCH (aka SCHEDULE_OCCURRED 
> in the function header comments) in order to repeat the neighbhor 
> research.
> 
> [ Impact: release the reiserfs write lock when it is not needed ]

This should also be safe because under the BKL we _already_ dropped 
the lock when sb_bread() blocked (which it really would in the 
normal case).

There's one special case to consider though: sb_read() maps to 
__bread() which can return without sleeping if the bh is already 
uptodate. So if the filesystem _knows_ that the bh is already 
uptodate and holds a reference to it (this is common pattern in 
filesystems), it can have a locking assumption on that.

No such assumption seems to be present here though.

	Ingo
