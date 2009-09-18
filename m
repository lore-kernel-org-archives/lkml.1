Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZIROZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZIROZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZIROZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZIROZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:25:15 -0400
Date: Fri, 18 Sep 2009 10:24:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090918102418.5d84931e@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909161224420.21599@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
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
	<20090915183405.2797b05e@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909161224420.21599@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 12:26:04 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 15 Sep 2009, Jeff Layton wrote:
> 
> > Yow, that version of mount.cifs is really old. I wonder if it may be
> > passing bad mount options to the kernel? Might be interesting to strace
> > that. Something like:
> >
> > # strace -f -s 256 -e mount mount -t cifs //chiprodfs2/company /mnt -ouser=clameter,domain=xxx
> >
> > ...it'll probably have a cleartext password in it so you might want to
> > doctor the options a bit before sending along if you do.
> >
> > Alternately, you might just want to try a newer version of mount.cifs
> > and see whether that fixes this.
> 
> Tried a newer version of mount.cifs without any change.
> 

Ok, good to rule that out then.

> > > I cannot mount the clameter dir on the 32 bit box. Hangs. So I will mount
> > > /company.
> > >
> >
> > Actually, the trace of a hanging mount would probably be interesting.
> >
> > Does the 32-bit capture that you sent represent a mount attempt that
> > hung? Or was it successful?
> 
> No it was successful.
> 

Hmm, ok. That isn't going to tell me as much as a mount that fails. For
now, I suggest that we focus on determining why these mounts hang/fail.
After that we can see whether the solution there has any bearing on why
the server is so slow to respond to this particular client.

> > What's the "devname" that you're giving to the mount command for the
> > "clameter" dir? If there's more than 1 path component after the
> > hostname, then the problem may be in the old version of mount.cifs.
> > Some of them had broken handling for path prefixes.
> 
> its //machinename/company/clameter
> 
> So two components.
> 

Also good to know.

What we should probably do at this point is track down why the 32-bit
client has such a hard time mounting the clameter dir. Here's what
would be most helpful:

1) some debug log info of the mount attempt:

# modprobe cifs
# echo 7 > /proc/fs/cifs/cifsFYI

...then attempt the mount. After it hangs for a few seconds, ^c the
mount to kill it. Collect the output from dmesg and send it to me. That
should give me some idea of what the client is doing during this phase.

If you can simultaneously capture wire traffic during the same mount
attempt that would also be helpful.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>
