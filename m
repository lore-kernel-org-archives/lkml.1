Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYFRUNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYFRUNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYFRUNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:13:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45659 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYFRUNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:13:02 -0400
Date: Wed, 18 Jun 2008 13:11:07 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [BUGFIX][PATCH 3/3] configfs: Fix failing symlink() making
	rmdir() fail
Message-ID: <20080618201107.GF16780@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com> <1213724243-29183-4-git-send-email-louis.rilling@kerlabs.com> <20080617221528.GA29091@mail.oracle.com> <20080618114043.GB30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618114043.GB30804@localhost>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 01:40:43PM +0200, Louis Rilling wrote:
> The problem is rmdir() of the target item (see below). ATTACHING only protects
> us from rmdir() of the parent. This is the exact reason why I attach the link to
> the target in last place, where we know that we won't have to rollback.

	Why wouldn't it protect the target, given that detach_prep()
will be called against the target if it's being rmdir'd?

> 	And AFAICS, creating a VFS object can not hurt as long as we hold the
> parent i_mutex, right? Otherwise there already is a problem in
> configfs_attach_item() where a failure in populate_attrs() leads to rollback the
> creation of the VFS object already created for the item.

	We *can* do that, but we try to isolate it - hand-building VFS
objects is complex and error prone, and I try to isolate that to
specific cases.  I'd rather avoid it when not necessary.

> > 		spin_lock(&configfs_dirent_lock);
> > 		parent_sd->s_type &= ~CONFIGFS_USET_ATTACHING;
> > 		if (ret) {
> 
> Here, if detach_prep() of the target failed because of the link attached above,
> it had no means to retry. rmdir() of the target fails because of this
> temporary link, which results in a failing symlink() making rmdir() of the
> target fail.

	How so?  It sees ATTACHING, it gets -EAGAIN, it tries again,
just like before.  What's different?

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
