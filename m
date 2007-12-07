Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXLGUdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXLGUdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbXLGUcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:32:54 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36157 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbXLGUcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:32:54 -0500
Date: Fri, 7 Dec 2007 15:32:42 -0500
Message-Id: <200712072032.lB7KWgTr015620@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [NFS] NFSv2/3 broken exporting/mounting (permission denied) in 2.6.24-rc4 
In-reply-to: Your message of "Fri, 07 Dec 2007 15:06:55 EST."
             <20071207200655.GD2204@fieldses.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071207200655.GD2204@fieldses.org>, "J. Bruce Fields" writes:
> On Fri, Dec 07, 2007 at 03:00:13PM -0500, Erez Zadok wrote:
[...]
> Those files are actually in a separate filesystem (of type "nfsd") which
> is supposed to be mounted on /proc/fs/nfsd/.   So that mount must have
> failed in the bad case?  It's not immediately obvious to me what this
> patch has to do with that.  Hm.

Yes, it is indeed a separate mount in both cases, but in the broken case,
/proc/fs/nfsd is empty.

The patch in question introduces a proc ->d_revalidate method which does
this:

static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
{
	d_drop(dentry);
	return 0;
}

I'm not sure why it drops the dentry and then returns OK to the VFS; is it
to force the VFS to revalidate the dentry?  In that case, I think it should
return -ESTALE.  I also don't know why /proc needs a ->d_revalidate in the
first place (it was fine up until now).  Perhaps what proc does now is
correct, but its behavior has changed such that nfsd's /proc/fs/nfsd needs
to do something different (like grab an extra dentry ref?).

Anyway, if I comment out the d_drop line in proc_revalidate_dentry, or
remove proc's ->d_revalidate method, nfs exporting works again.

Someone more familiar with this patch and /proc should investigate.  Until
then, nfsv2/3 exporting are broken in 2.6.24-rc4.

> --b.

Cheers,
Erez.
