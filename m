Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbYA1R1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbYA1R1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYA1R12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:27:28 -0500
Received: from styx.suse.cz ([82.119.242.94]:41149 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751103AbYA1R11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:27:27 -0500
Date: Mon, 28 Jan 2008 18:27:26 +0100
From: Jan Kara <jack@suse.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Message-ID: <20080128172726.GG14038@duck.suse.cz>
References: <200801242336.00340.a1426z@gawab.com> <20080125153634.GG28856@atrey.karlin.mff.cuni.cz> <200801260827.59675.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801260827.59675.a1426z@gawab.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 26-01-08 08:27:59, Al Boldi wrote:
> Jan Kara wrote:
> > > Greetings!
> > >
> > > data=ordered mode has proven reliable over the years, and it does this
> > > by ordering filedata flushes before metadata flushes.  But this
> > > sometimes causes contention in the order of a 10x slowdown for certain
> > > apps, either due to the misuse of fsync or due to inherent behaviour
> > > like db's, as well as inherent starvation issues exposed by the
> > > data=ordered mode.
> > >
> > > data=writeback mode alleviates data=order mode slowdowns, but only works
> > > per-mount and is too dangerous to run as a default mode.
> > >
> > > This RFC proposes to introduce a tunable which allows to disable fsync
> > > and changes ordered into writeback writeout on a per-process basis like
> > > this:
> > >
> > >       echo 1 > /proc/`pidof process`/softsync
> >
> >   I guess disabling fsync() was already commented on enough. Regarding
> > switching to writeback mode on per-process basis - not easily possible
> > because sometimes data is not written out by the process which stored
> > them (think of mmaped file).
> 
> Do you mean there is a locking problem?
  No, but if you write to an mmaped file, then we can find out only later
we have dirty data in pages and we call writepage() on behalf of e.g.
pdflush().

> > And in case of DB, they use direct-io
> > anyway most of the time so they don't care about journaling mode anyway.
> 
> Testing with sqlite3 and mysql4 shows that performance drastically improves 
> with writeback writeout.
  And do you have the databases configured to use direct IO or not?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
