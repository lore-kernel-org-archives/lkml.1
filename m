Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXJWJIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXJWJIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXJWJHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:07:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52472 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbXJWJHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:07:50 -0400
Date: Tue, 23 Oct 2007 10:07:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [PATCH 1/9] Unionfs: security convert lsm into a static interface fix
Message-ID: <20071023090739.GA19758@infradead.org>
References: <20071022082231.GA15132@infradead.org> <200710230048.l9N0m4di009035@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710230048.l9N0m4di009035@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 08:48:04PM -0400, Erez Zadok wrote:
> Why?  Are you concerned that the security policy may change after a module
> is loaded?

No, it's a matter of proper layering.  We generally don't want modules
like stackabke filesystems to call directly into methods but rather use
proper highlevel VFS helpers to isolate them from details and possible
changes.  The move to out of line security_ helpers just put this on the
radard.

> I can probably get rid of having unionfs call security_inode_permission, by
> calling permission() myself and carefully post-process its return code
> (unionfs needs to "ignore" EROFS initially, to allow copyup to take place).

Sounds fine.

> But security_file_ioctl doesn't have any existing helper I can call.  I can
> introduce a trivial vfs_security_file_ioctl wrapper to security_file_ioctl,
> but what about the already existing *19* exported security_* functions in
> security/security.c?  Do you want to see simple wrappers for all of them?
> It seems redundant to add a one-line wrapper around an already one-line
> function around security_ops->XXX.  Plus, some of the existing exported
> security_* functions are file-system related, others are networking, etc.  So
> we'll need wrappers whose names are prefixed appropriately: vfs_*, net_*,
> etc.

The fix for security_file_ioctl is probably to either not do it at all
or move it the call to security_file_ioctl into vfs_ioctl and get it by
using that helper.  I suspect most other security_ exports should be
avoided similarly.

I also suspect the whole issue of where and how-many times to call LSM
methods for stackable filesystems is a huge can of worms and it might make
sense to talk to the LSM folks about it.
