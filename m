Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYFKJQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYFKJQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYFKJPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:15:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36208 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYFKJPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:15:52 -0400
Date: Wed, 11 Jun 2008 02:04:08 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
Subject: Re: Is configfs the right solution for configuration based fs?
Message-ID: <20080611090407.GA17466@mail.oracle.com>
Mail-Followup-To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>, Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com> <20080609022821.GL29740@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609022821.GL29740@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 07:28:21PM -0700, Joel Becker wrote:
> On Sun, Jun 08, 2008 at 02:25:36PM -0700, Luis R. Rodriguez wrote:
> > I was really interested in looking to start a filesystem based
> > approach for configuration of wireless a while back, an alternative to
> > nl80211 if you will, but I stopped after I was told about some major
> > issues with configfs. I forget the issues raised clearly so I'd like
> 
> 	I'd love to hear about the issues as well. 

	Here's a list of "known" issues I hear about with configfs.
These are requests/complaints/etc I have gotten since it was merged.

1) configfs should be sysfs

	The argument is that sysfs should somehow support the
user-directed mkdir(2)/rmdir(2) lifecycle of configfs in addition to its
usual functions.  This, unfortunately, doesn't work.  I sent a pretty
detailed discussion of this to lkml the last time it came up, but here's
a short summary.  Number one, I tried this first.  It got ugly fast.
Number two, a goal of configfs is a simpler lifecycle than sysfs
(understanding the lifetimes of config items).  Adding an additional
mode to the already complicated lifecycle of kobjects directly opposes
this

2) There needs to be a way to pin a config item

	configfs's ->drop_item() operation returns void - if it is
called, your item must deactivate.  This is in line with configfs'
user-directed paradigm.  However, sometimes another kernel subsystem is
depending on that item - it will crash if the item goes away.
	After getting this beaten over my head a few times by good
friends, I realized they were right.  configfs now has
configfs_depend_item() to allow subsystems to pin config items when
necessary.

3) configfs should support large attributes

	A configfs attribute can be a maximum of 4k in size.  This fits
the simple show/store methods cribbed from sysfs.  However, more than
one person has given a good reason for larger attributes, often lists of
things.
	This isn't implemented yet, because I haven't come up with a
good way to do it.  seq_file works pretty well for the show side, but
there is no seq_write() to match on the store side.  I'd love to come up
with a sane semantic and make it work.  Consider it a TODO.

Finally, this thread has presented 
4) easier definition of items, perhaps with macros like DEFINE_ATTR

	I think I have a __CONFIGFS_ATTR() macro, but it's nowhere near
as nice as what sysfs has.  This definitely could use some work, making
configfs easier to use.

	That's what I have.  I don't know if any of these issues were
what you were worried about, Luis.

Joel

-- 

"In the long run...we'll all be dead."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
