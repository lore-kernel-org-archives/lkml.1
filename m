Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbZEANcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbZEANcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763339AbZEANbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:31:53 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:32880 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763351AbZEANbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r63Wa7BxzYJjd9x1vGPO85RvooKi12ZV2+DlkKKvkSyj9D2pALjkL4an9Wtj8rumEm
         Afz8gUZmvDO6twtiOk+vFTceFCx3P0ELGRY3TKaIEF3VHyME8r4cUeqH06H9anFAPahj
         6W8ku57LQ2FJi3mUnE23KsjGUKQMXho4VX8W4=
Date: Fri, 1 May 2009 15:31:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/6] kill-the-BKL/reiserfs: release the write lock
	before rescheduling on do_journal_end()
Message-ID: <20090501133147.GF6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-3-git-send-email-fweisbec@gmail.com> <20090501070911.GG5983@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501070911.GG5983@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:09:11AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > When do_journal_end() copies data to the journal blocks buffers in memory,
> > it reschedules if needed between each block copied and dirtyfied.
> > 
> > We can also release the write lock at this rescheduling stage,
> > like did the bkl implicitly.
> > 
> > [ Impact: release the reiserfs write lock when it is not needed ]
> > 
> > Cc: Jeff Mahoney <jeffm@suse.com>
> > Cc: Chris Mason <chris.mason@oracle.com>
> > Cc: Alexander Beregalov <a.beregalov@gmail.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  fs/reiserfs/journal.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> > index 7976d7d..373d080 100644
> > --- a/fs/reiserfs/journal.c
> > +++ b/fs/reiserfs/journal.c
> > @@ -4232,7 +4232,9 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
> >  		next = cn->next;
> >  		free_cnode(sb, cn);
> >  		cn = next;
> > +		reiserfs_write_unlock(sb);
> >  		cond_resched();
> > +		reiserfs_write_lock(sb);
> 
> There's 8 cond_resched()'s in the code - i'd suggest to introduce a 
> helper for this - reiserfs_write_cond_resched(sb) or so?
> 
> 	Ingo

Indeed, that + the pattern suggested by Al.

Thanks.

