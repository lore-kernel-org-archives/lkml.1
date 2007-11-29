Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXK2WOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXK2WOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932728AbXK2WNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:13:54 -0500
Received: from bbasa1.bakbone.com ([209.126.247.190]:47714 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756086AbXK2WNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:13:54 -0500
From: Justin Banks <justinb@bakbone.com>
Date: Thu, 29 Nov 2007 15:12:38 -0700
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jon Masters <jonathan@jonmasters.org>, Ray Lee <ray-lk@madrabbit.org>,
       tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
Message-ID: <20071129221238.GF5601@bleen.corp.bb>
References: <1196365551.6473.103.camel@perihelion> <20071129214527.1d62056c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129214527.1d62056c@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote
> > Jargon File in all its glory. And if you still think you could look for
> > patterns, how about executable code that self-modifies in random ways
> > but when executed as a whole actually has the functionality of fetchmail
> > embedded within it? How would you guard against that?
> 
> Thats a problem for whoever writes the ESR detection tool and to what
> level it works. The question for the kernel is how do we provide a
> mechanism to allow (to some extent at least) this kind of tool to run.

In a general way, what about providing a kind of {file,inode}_operations 
xchange functionality given a super_block such that filesystems could
essentially be stacked, e.g. a

int op_xchange(struct super_block *sb, struct inode_operations *new_iop, 
	struct inode_operations *old_iop, struct file_operations *new_fop,
	struct file_operations *old_fop);

The caller could/would/should be vetted, but replacing the static ops
with new ones of the caller's specification would allow them to
intercept the i/o, do whatever checking they wanted to do, and then call
the proper underlying operation (even modifying the parameters, I guess,
but that may be too weird). Perhaps separate get_* and set_* so that the
caller can retrieve the current operations vector and only "override"
the functions they really care about?

It's not perfect, but as was recently pointed out, if you can only get
98% of the way there rather than 100% is that a reason for not trying to
make it possible? It'd obviously not work for mmap, but as near as I can
tell the whole point is to get the "normal" malware cases without having
to do icky things like mangle the syscall table.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
