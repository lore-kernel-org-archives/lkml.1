Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZC3Op2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZC3Op2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZC3OpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:45:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZC3OpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:45:09 -0400
Date: Mon, 30 Mar 2009 16:42:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] Make relatime default
Message-ID: <20090330144213.GA5426@random.random>
References: <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org> <20090326175314.GC7198@srcf.ucam.org> <20090326184838.26166549@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326184838.26166549@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:48:38PM +0000, Alan Cox wrote:
> On Thu, 26 Mar 2009 17:53:14 +0000
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > Change the default behaviour of the kernel to use relatime for all
> > filesystems. This can be overridden with the "strictatime" mount
> > option.
> 
> NAK this again

NAK but because if we change the default it is better to change it to
the real thing: noatime.

I think this can be solved in userland but perhaps changing this in
kernel would be a stronger message that atime is officially
obsoleted. (and nothing will break, not even mutt users will notice,
and if they really do it won't be anything more than aesthetical)


About the open(destination, O_TRUNC); write; close, I think it's not
worth changing the kernel or the VM in any way to hide buggy
programming like that, to the contrary it's great it was found early
on (instead of being filed as some obscure not reproducible bug lost
in some bugzilla and hitting once in a while with an unlucky
power-loss during boot). But solving this bug with fsync so it works
for writeback mode too, would make me prefer to gamble and run the the
buggy version ;). Not sure if it worth providing any ordering
guarantee more than 'ordered' mode in the long term or some proper
barrier, but at least ordered mode already allows for renaming the
tempfile to be enough and that is clearly the best tradeoff. fsync
really should be used only to avoid total loss of information (like
when we need to avoid losing the delivery of an email after the smpt
client is told the email was already received by the smtp server).

Using fsync to tell the kernel in what order to write is dirty
pagecache data to disk, is as inefficient as driving a car to travel a
10 meters distance, so rightfully people isn't using it for this even
if it's the only way it could work for writeback and ext2 too.
