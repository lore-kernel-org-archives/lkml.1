Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZIOWej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZIOWej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZIOWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZIOWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:34:35 -0400
Date: Tue, 15 Sep 2009 18:34:05 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090915183405.2797b05e@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909141600300.24371@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
	<20090909125352.1c7b57d2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
	<20090909132039.1ca47cd4@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1>
	<20090909140257.35ede0cc@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1>
	<20090909205548.4858b524@zanovar.poochiereds.net>
	<alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1>
	<20090910153347.2f2616e8@barsoom.rdu.redhat.com>
	<alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1>
	<20090910165757.43b77874@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909101721180.27669@V090114053VZO-1>
	<20090910201932.5b8356e2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909141600300.24371@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 16:10:47 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Sep 2009, Jeff Layton wrote:
> 
> > In any case, I think we need to look closely at what's happening at
> > mount time. First, I'll need some other info:
> >
> > 1) output of "/sbin/mount.cifs -V" from both machines
> 
> The 32 bit machine
> 
> #/sbin/mount.cifs -V
> mount.cifs version: 1.5
> //chiprodfs2/company /mnt -ouser=clameter,domain=xxx
> mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=xxx
> 

Yow, that version of mount.cifs is really old. I wonder if it may be
passing bad mount options to the kernel? Might be interesting to strace
that. Something like:

# strace -f -s 256 -e mount mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=xxx

...it'll probably have a cleartext password in it so you might want to
doctor the options a bit before sending along if you do.

Alternately, you might just want to try a newer version of mount.cifs
and see whether that fixes this.

> 64 bit machine
> 
> $ /sbin/mount.cifs -V
> mount.cifs version: 1.12-3.4.0
> 
> mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=w2k
> 
> > 3) wire captures from mount attempts on both machines. Try to mount the
> > "clameter" dir on both boxes and do captures of each attempt. Maybe
> > this time use -s 0 with tcpdump so we get all of the traffic.
> 
> I cannot mount the clameter dir on the 32 bit box. Hangs. So I will mount
> /company.
> 

Actually, the trace of a hanging mount would probably be interesting.

Does the 32-bit capture that you sent represent a mount attempt that
hung? Or was it successful?

> > There may be crackable password hashes in the captures, so you may want
> > to send them to me privately and not cc the list.
> 
> Ok will follow.
> 

Thanks for the info, I had a look at the captures. They both look
fairly similar. The main difference is that the 32-bit box doesn't seem
to have sent any more calls after sending a QPathInfo call to the
server for the root inode of the mount.

What's the "devname" that you're giving to the mount command for the
"clameter" dir? If there's more than 1 path component after the
hostname, then the problem may be in the old version of mount.cifs.
Some of them had broken handling for path prefixes.

-- 
Jeff Layton <jlayton@redhat.com>
