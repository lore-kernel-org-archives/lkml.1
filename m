Return-Path: <linux-kernel-owner+w=401wt.eu-S936382AbXJSVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936382AbXJSVlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbXJSVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:40:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37153 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529AbXJSVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:40:51 -0400
Date: Fri, 19 Oct 2007 17:40:21 -0400
Message-Id: <200710192140.l9JLeLEO004110@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, bfields@fieldses.org,
       nfs@lists.sourceforge.net, neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: nfsv2 ref leak in 2.6.24? 
In-reply-to: Your message of "Fri, 19 Oct 2007 09:41:16 EDT."
             <1192801277.7073.4.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1192801277.7073.4.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> 
> On Fri, 2007-10-19 at 01:49 -0400, Erez Zadok wrote:
> > I'm testing unionfs on top of nfsv2/3/4, using 2.6.24 as of linus's commit
> > 4fa4d23fa20de67df919030c1216295664866ad7.  A lot of my unionfs regression
> > tests are failing on nfs2, b/c files that should be deleted, aren't.  It
> > feels like there may be a ref leak that prevents the files from being
> > deleted, or maybe an unlink issue.  It doesn't happen in all of my previous
> > kernels w/ identical unionfs (code 2.6.9--2.6.23).  And in 2.6.24 it happens
> > only w/ nfs2 -- nfs3/4 are fine.
> > 
> > I'm not sure if this is a client or server issue, and I'm only starting to
> > dig deeper.  But I thought I'd ask you in case this is a known problem and
> > you have a fix.  If this is the first you hear of this problem, let me know
> > and I'll try to narrow it down further.
> 
> A couple of questions:
> 
>       * Are these files being sillyrenamed?
>       * Are they shown as being removed by the server?
> 
> Cheers
>   Trond

Trond, I was able to narrow down the problem w/o using unionfs at all (yay!
:-).  All I do is setup a loop device, mkfs it as ext2, mount it, then
export it to localhost and mount it locally as nfs2.  I go and touch a new
file in the ext2 directory.  Then I readdir the export point to find the new
file indeed.  Then I stat(1) the new file, and get the appropriate stat
output.  Now the strange thing is that right after the stat through the
export point, the file DISAPPEARS from the lower ext2 dir, but REAPPEARS a
few seconds later.

It doesn't happen all the time, so it feels like some sort of a race or
timing-related bug.  And it only happens w/ nfs2 on 2.6.24 (v3/4 work fine;
v2/3/4 work find in previous kernels).

I'm trying to get a script that'll be able to reproduce this for you more
deterministically.

BTW, does your just-posted set of patches, subject "[GIT] NFS client fixes
for 2.6.23++" possibly fix this?  I can try it and let you know.

Hope this helps for now.

Erez.
