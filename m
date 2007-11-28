Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbXK1MyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbXK1MyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXK1MyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:54:03 -0500
Received: from styx.suse.cz ([82.119.242.94]:60769 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751719AbXK1MyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:54:01 -0500
Date: Wed, 28 Nov 2007 13:53:59 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mwelinder@gmail.com, rlove@rlove.org,
       John McCutchan <ttb@tentacle.dhs.org>
Subject: Re: [PATCH] Send IN_ATTRIB events when link count changes
Message-ID: <20071128125359.GB11350@duck.suse.cz>
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com> <118833cc0711231154i588cf7c1gb99e050999af8632@mail.gmail.com> <20071126160043.GA5647@atrey.karlin.mff.cuni.cz> <118833cc0711260806x69fc2bb6n572f1e1253a201ef@mail.gmail.com> <20071126162758.GA856@duck.suse.cz> <20071127124640.6110ddfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127124640.6110ddfb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-11-07 12:46:40, Andrew Morton wrote:
> On Mon, 26 Nov 2007 17:27:58 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> >   Hi Andrew,
> > 
> >   would you pick up this patch for testing in -mm? Thanks.
> > 
> > 								Honza
> > 
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > 
> > ---
> > 
> > Send inotify events to the inode itself when its link count has changed.
> 
> Could we have a better changelog please?  What is the reason for making
> this change?  What are the before-and-after effects upon inotify clients,
> etc?
  OK, hopefully a better change log:

  Currently, no notification event has been sent when inode's link count
changed. This is inconvenient for the application in some cases:
  Suppose you have the following directory structure
    foo/test
    bar/

  and you watch test. If someone does "mv foo/test bar/", you get event
IN_MOVE_SELF and you know something has happened with the file "test".
However if someone does "ln foo/test bar/test" and "rm foo/test" you get no
inotify event for the file "test" (only directories "foo" and "bar" receive
events).
  Furthermore it could be argued that link count belongs to file's metadata
and thus IN_ATTRIB should be sent when it changes.
  The following patch implements sending of IN_ATTRIB inotify events when
link count of the inode changes, i.e., when a hardlink to the inode is
created or when it is removed. This event is sent in addition to all the
events sent so far. In particular, when a last link to a file is removed,
IN_ATTRIB event is sent in addition to IN_DELETE_SELF event.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
