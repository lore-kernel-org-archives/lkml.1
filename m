Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZC3AmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZC3AmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZC3Alw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:41:52 -0400
Received: from THUNK.ORG ([69.25.196.29]:40195 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbZC3Alw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:41:52 -0400
Date: Sun, 29 Mar 2009 20:39:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330003948.GA13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329231451.GR26138@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:14:51AM +1100, Dave Chinner wrote:
> This is a clear case where you want metadata changed before data is
> committed to disk. In many cases, you don't even want the data to
> hit the disk here.
> 
> Similarly, rsync does the magic open,write,close,rename sequence
> without an fsync before the rename. And it doesn't need the fsync,
> either. The proposed implicit fsync on rename will kill rsync
> performance, and I think that may make many people unhappy....

I agree.  But unfortunately, I think we're going to be bullied into
data=ordered semantics for the open/write/close/rename sequence, at
least as the default.  Ext4 has a noauto_da_alloc mount option (which
Eric Sandeen suggested we rename to "no_pony" :-), for people who
mostly run sane applications that use fsync().

For people who care about rsync's performance and who assume that they
can always restart rsync if the system crashes while the rsync is
running could, rsync could add Yet Another Rsync Option :-) which
explicitly unlinks the target file before the rename, which would
disable the implicit fsync().

> > Much easier and more reliable to centralize it there, rather than
> > rely (falsely) upon thousands of programs each performing numerous
> > performance-killing fsync's.
> 
> The filesystem should batch the fsyncs efficiently. if the
> filesystem doesn't handle fsync efficiently, then it is a bad
> filesystem choice for that workload....

All I can do is apologize to all other filesystem developers profusely
for ext3's data=ordered semantics; at this point, I very much regret
that we made data=ordered the default for ext3.  But the application
writers vastly outnumber us, and realistically we're not going to be
able to easily roll back eight years of application writers being
trained that fsync() is not necessary, and actually is detrimental for
ext3.

	       		      	       	      - Ted
