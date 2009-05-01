Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbZEANa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbZEANa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbZEAN3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:29:20 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:17425 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761972AbZEAN3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:29:18 -0400
Subject: Re: [PATCH 4/6] kill-the-BKL/reiserfs: release the write lock
 inside get_neighbors()
From: Chris Mason <chris.mason@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20090501132506.GD6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
	 <1241145862-21700-5-git-send-email-fweisbec@gmail.com>
	 <20090501055135.GF5983@elte.hu>  <20090501132506.GD6011@nowhere>
Content-Type: text/plain
Date: Fri, 01 May 2009 09:29:03 -0400
Message-Id: <1241184543.13084.13.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49FAF922.01C3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 15:25 +0200, Frederic Weisbecker wrote:
> On Fri, May 01, 2009 at 07:51:35AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > get_neighbors() is used to get the left and/or right blocks 
> > > against a given one in order to balance a tree.
> > > 
> > > sb_bread() is used to read the buffer of these neighors blocks and 
> > > while it waits for this operation, it might sleep.
> > > 
> > > The bkl was released at this point, and then we can also release 
> > > the write lock before calling sb_bread().
> > > 
> > > This is safe because if the filesystem is changed after this lock 
> > > release, the function returns REPEAT_SEARCH (aka SCHEDULE_OCCURRED 
> > > in the function header comments) in order to repeat the neighbhor 
> > > research.
> > > 
> > > [ Impact: release the reiserfs write lock when it is not needed ]
> > 
> > This should also be safe because under the BKL we _already_ dropped 
> > the lock when sb_bread() blocked (which it really would in the 
> > normal case).
> > 
> > There's one special case to consider though: sb_read() maps to 
> > __bread() which can return without sleeping if the bh is already 
> > uptodate. So if the filesystem _knows_ that the bh is already 
> > uptodate and holds a reference to it (this is common pattern in 
> > filesystems), it can have a locking assumption on that.
> > 

sb_bread calls __bread which calls __getblk which always calls
might_sleep() before returning.

So, the unlock isn't adding a schedule that wasn't there before.

-chris


