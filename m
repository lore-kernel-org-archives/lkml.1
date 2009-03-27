Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZC0UCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZC0UCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZC0UCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:02:41 -0400
Received: from THUNK.ORG ([69.25.196.29]:55920 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbZC0UCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:02:40 -0400
Date: Fri, 27 Mar 2009 16:01:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327200118.GA6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CD2C47.4040300@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 03:43:03PM -0400, Jeff Garzik wrote:
> On the other side of the coin, major desktop apps Firefox and  
> Thunderbird already use it:  Firefox uses sqlite to log open web pages  
> in case of a crash, and sqlite in turn sync's its journal as any good  
> database app should.  [I think tytso just got them to use fdatasync and  
> a couple other improvements, to make this not-quite-so-bad]

I spent a very productive hour-long conversation with the Sqlite
maintainer last weekend.  He's already checked in a change to use
fdatasync() everywhere, and he's looking into other changes that would
help avoid needing to do a metadata sync because i_size has changed.
One thing that will definitely help is if applications send the
sqlite-specific SQL command "PRAGMA journal_mode = PERSIST;" when they
first startup the Sqlite database connection.  This will cause Sqlite
to keep the rollback journal file to stick around instead of being
deleted and then recreated for each Sqlite transaction.  This avoids
at least one fsync() of the directory containing the rollback journal
file.  Combined with the change in Sqlite's development branch to use
fdatasync() everwhere that fsync() is used, this should definitely be
a huge improvement.

In addition, Firefox 3.1 is reportedly going to use an union of an
on-disk database and an in-memory database, and every 15 or 30 minutes
or so (presumably tunable via some config parameter), the in-memory
database changes will be synched out to the on-disk database.  This
will *definitely* help a lot, and also help improve SSD endurance.

(Right now Firefox 3.0 writes 2.5 megabytes each time you click on a
URL, not counting the Firefox cache; I have my Firefox cache directory
symlinked to /tmp to save on unnecessary SSD writes, and I was still
recording 2600k written to the filesystem each time I clicked on a
HTML link.  This means that for every 400 pages that I visit, Firefox
is currently generating a full gigabyte of (in my view, unnecessary)
writes to my SSD, all in the name of maintaining Firefox's "Awesome
Bar".  This rather nasty behaviour should hopefully be significantly
improved with Firefox 3.1, or so the Sqlite maintainer tells me.)

	      	      	      	     	    	       - Ted
