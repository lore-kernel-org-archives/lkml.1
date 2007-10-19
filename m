Return-Path: <linux-kernel-owner+w=401wt.eu-S967144AbXJSVwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967144AbXJSVwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966984AbXJSVwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:52:42 -0400
Received: from pat.uio.no ([129.240.10.15]:41455 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965479AbXJSVwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:52:40 -0400
Subject: Re: nfsv2 ref leak in 2.6.24?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: bfields@fieldses.org, nfs@lists.sourceforge.net, neilb@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710192140.l9JLeLEO004110@agora.fsl.cs.sunysb.edu>
References: <200710192140.l9JLeLEO004110@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 17:52:32 -0400
Message-Id: <1192830752.7466.32.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.120)
X-UiO-Scanned: 9C94E8FE045B9D29870335B0A2C9213553B0A75E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 321 total 4604917 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 17:40 -0400, Erez Zadok wrote:
> In message <1192801277.7073.4.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> > 
> > On Fri, 2007-10-19 at 01:49 -0400, Erez Zadok wrote:
> > > I'm testing unionfs on top of nfsv2/3/4, using 2.6.24 as of linus's commit
> > > 4fa4d23fa20de67df919030c1216295664866ad7.  A lot of my unionfs regression
> > > tests are failing on nfs2, b/c files that should be deleted, aren't.  It
> > > feels like there may be a ref leak that prevents the files from being
> > > deleted, or maybe an unlink issue.  It doesn't happen in all of my previous
> > > kernels w/ identical unionfs (code 2.6.9--2.6.23).  And in 2.6.24 it happens
> > > only w/ nfs2 -- nfs3/4 are fine.
> > > 
> > > I'm not sure if this is a client or server issue, and I'm only starting to
> > > dig deeper.  But I thought I'd ask you in case this is a known problem and
> > > you have a fix.  If this is the first you hear of this problem, let me know
> > > and I'll try to narrow it down further.
> > 
> > A couple of questions:
> > 
> >       * Are these files being sillyrenamed?
> >       * Are they shown as being removed by the server?
> > 
> > Cheers
> >   Trond
> 
> Trond, I was able to narrow down the problem w/o using unionfs at all (yay!
> :-).  All I do is setup a loop device, mkfs it as ext2, mount it, then
> export it to localhost and mount it locally as nfs2.  I go and touch a new
> file in the ext2 directory.  Then I readdir the export point to find the new
> file indeed.  Then I stat(1) the new file, and get the appropriate stat
> output.  Now the strange thing is that right after the stat through the
> export point, the file DISAPPEARS from the lower ext2 dir, but REAPPEARS a
> few seconds later.

Let me get this straight:

  1) You create the file on the server
  2) You readdir the file from the client
  3) You stat the file from the client

....with the result that the file disappears from sight on the server?

That would indicate some dcache issues with the server code. What export
options are you using?

> It doesn't happen all the time, so it feels like some sort of a race or
> timing-related bug.  And it only happens w/ nfs2 on 2.6.24 (v3/4 work fine;
> v2/3/4 work find in previous kernels).
> 
> I'm trying to get a script that'll be able to reproduce this for you more
> deterministically.
> 
> BTW, does your just-posted set of patches, subject "[GIT] NFS client fixes
> for 2.6.23++" possibly fix this?  I can try it and let you know.

I doubt the new patches fix the problem if I did indeed get your method
right.

Cheers
  Trond

