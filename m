Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYHNJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYHNJbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYHNJbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:31:01 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:56891 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYHNJbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:31:00 -0400
In-Reply-To: <20080813192922.GI8232@mit.edu>
To: Theodore Tso <tytso@mit.edu>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Thu, 14 Aug 2008 10:30:56 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 10:30:56,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 10:30:56,
	Serialize complete at 14/08/2008 10:30:56,
	S/MIME Sign failed at 14/08/2008 10:30:56: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/08/2008 10:30:58,
	Serialize complete at 14/08/2008 10:30:58
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080814093103.6CD102FE8B4@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote on 13/08/2008 20:29:22:

> On Wed, Aug 13, 2008 at 03:02:48PM -0400, Eric Paris wrote:
> > I never suggested putting a scanner in kernel.  Sound like you want 
the
> > "allow don't cache" response from your userspace scanner while this is
> > going on.  The kernel doesn't need to be making decisions about when 
to
> > send events, nor should userspace tell the kernel not to send events.
> > Its up to whatever the scanner is to agree not to actually do any
> > scanning...
> 
> And if the system isn't running a virus checker, but just a file
> indexer (ala tracker), it shouldn't go to userspace at all.  In that
> case all that is necessary is an asynchronous notification.
> 
> Also something else that is needed is support for multiple clients.
> (i.e., what happens if the user runs two virus checkers, or a virus
> checker plus a hierarchical storage manager driving a tape robot, or
> all of the above plus trackerd --- where some clients need to block
> open(2) access, and some do not need block open(2) --- and in the case
> of HSM, ordering becomes important; you want to retrieve the file from
> the tape robot first, *then* scan it using the virus checker.  :-)

Hm, maybe by implementing a facility with which a client can register it's 
interface usage intent? Something like:

register(I_HAVE_NO_INTEREST_IN_CONTENT);
register(I_WANT_TO_EXAMINE_CONTENT);

All former ones would run first because they only want to have the 
opportunity to block and do something unrelated to file content (like 
HSMs), and later group would be ran last since they want to examine the 
content.

Ordering inside those two groups is not important because I don't see how 
a model other than restrictive can make sense with content security 
scanning.
 
> > No.  How in the heck can some out of kernel database store information
> > about what inodes have been scanned in any even slightly sane way? And
> > people think the race between open and read is too large and you 
suggest
> > moving clean/dirty marking to a userspace database?  I MUCH prefer my
> > (and it sounds like arjan agrees) clean/dirty versioned flag in inode.
> 
> Don't ask me; I think most AV checkers for linux are security theater
> and not very much use (other than making money for the AV company's
> shareholders) anyway.  I thought you were the one who wanted to record
> information about which version of the virus db a particular file had
> been scanned against.  The place where I can see this being useful is
> what happens you get a new virus DB, and so you need to start scanning
> all of the files in your 5TB enterprise file server --- and then the
> system crashes or it needs to be taken down for scheduled maintenance.
> 
> You want to have *some* off-line database for storing this
> information, since it would be silly to want to have the first thing
> that happens after a new virus DB gets downloaded is to interate over
> the entire filesystem, clearing a persistent the "clean" bit --- that
> would take *forever* on a 5TB filerserver; and what happens if you
> crash in the middle of clearing the "clean" bit..  And if the system
> gets shutdown in the middle of the scan, you need some way of
> remembering which inodes have been scanned using the "new" db, and
> which ones haven't yet been scanned via the new virus db.  All of this
> should be kept in userpsace, and is strictly speaking Not Our Problem.
> 
> I'm just arguing that there should be absolutely *no* support in the
> kernel for solving this particular problem, since the question of
> whether a file has been scanned with a particular version of the virus
> DB is purely a userspace problem.

The thing is the idea never was for clean-dirty "database" to be 
persistent but to have the same lifetime as the inode (in memory one). And 
once the cache/database gets invalidated re-scanning happens on-demand so 
the 5TB problem does not exist. Concerns about multiple clients where 
every has a different versioning scheme are also not relevant with the 
proposed versioning scheme (see my reply to Arjan).

So this problem can be solved in kernel in a much more performant and 
secure way than it would be possible in userspace and all that with just a 
handfull of lines of code.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

