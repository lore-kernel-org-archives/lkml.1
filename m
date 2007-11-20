Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbXKTPLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbXKTPLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXKTPLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:11:47 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:35547 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754786AbXKTPLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:11:46 -0500
Subject: Re: [PATCH 1/4] proc: fix NULL ->i_fop oops
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, devel@openvz.org,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <20071119125139.GB15942@infradead.org>
References: <20071116150651.GC19517@localhost.sw.ru>
	 <20071119125139.GB15942@infradead.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 20 Nov 2007 10:05:05 -0500
Message-Id: <1195571105.20910.31.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 12:51 +0000, Christoph Hellwig wrote:
> On Fri, Nov 16, 2007 at 06:06:51PM +0300, Alexey Dobriyan wrote:
> > proc_kill_inodes() can clear ->i_fop in the middle of vfs_readdir resulting in
> > NULL dereference during "file->f_op->readdir(file, buf, filler)".
> > 
> > The solution is to remove proc_kill_inodes() completely:
> > a) we don't have tricky modules implementing their tricky readdir hooks which
> >    could keeping this revoke from hell.
> > b) In a situation when module is gone but PDE still alive, standard readdir
> >    will return only "." and "..", because pde->next was cleared by
> >    remove_proc_entry().
> > c) the race proc_kill_inode() destined to prevent is not completely fixed, just
> >    race window made smaller, because vfs_readdir() is run without sb_lock held and
> >    without file_list_lock held. Effectively, ->i_fop is cleared at random moment,
> >    which can't fix properly anything.
> 
> Nice, getting rid of this is a very good step formwards.  Unfortunately
> we have another copy of this junk in
> security/selinux/selinuxfs.c:sel_remove_entries() which would need the
> same treatment.

Can't just be dropped completely for selinux - we need a way to drop
obsolete entries from the prior policy when we load a new policy.

Is the only real problem here the clearing of f_op?  If so, we can
likely remove that from sel_remove_entries() without harm, and fix the
checks for it to use something more reliable.

-- 
Stephen Smalley
National Security Agency

