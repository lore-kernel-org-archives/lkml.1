Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYCNOBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYCNOBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYCNOBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:01:23 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:44084 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYCNOBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:01:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18394.34045.414717.427277@stoffel.org>
Date: Fri, 14 Mar 2008 10:00:29 -0400
From: "John Stoffel" <john@stoffel.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803131923.14840.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803131214.40321.phillips@phunq.net>
	<20080313162711.3d483e6c@cuia.boston.redhat.com>
	<200803131923.14840.phillips@phunq.net>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Daniel" == Daniel Phillips <phillips@phunq.net> writes:

Daniel> On Thursday 13 March 2008 13:27, Rik van Riel wrote:
>> On Thu, 13 Mar 2008 11:14:39 -0800
>> Daniel Phillips <phillips@phunq.net> wrote:
>> 
>> > Scream is an exaggeration, and FUD only applies to somebody who
>> > consistently overlooks the primary proposition in this design: that the
>> > battery backed power supply, computer hardware and Linux are reliable
>> > enough to entrust your data to them. 
>> 
>> That's a reasonable enough assumption, to anyone who has never dealt
>> with software before, or whose data is just not important.
>> 
>> People who have dealt with computers for longer will know that anything
>> can fail at any time, and usually does unexpectedly and at bad moments.
>> 
>> Some defensive programming to deal with random failures could make your
>> project appealing to a lot more people than it would appeal to in its
>> current state.
 
Daniel> In its current state it has bugs and so should appeal only to
Daniel> programmers who like to work with cutting edge stuff.

As a prof SysAdmin and long time lurker, I feel I can chime in here a
bit.  No one is arguing that your code isn't neat, or have a feature
which would be nice to have.  They are arguing that your failure mode
(when, not if, it fails for some reason) is horrible.  

Who remembers the NFS PrestoServer NFS accelerator cards?  You could
buy this PCI (or was it TurboChannel back then?) card for your DEC
Alphas.  It came with 4Mb of battery backed RAM so that NFS writes
could be ack'd before being written to disk.  We had just completed
moving all the user home directories to this system that week, say
around 4gb of data?  Remember, this was around 94 sometime at a
University.  We were also using Advfs on DEC OSF/1, probably v1.2,
maybe v1.3. 

Anyway, I came into work thursday night to pickup something I had
forgotten before I took a three day weekend.  The operator on duty
asked me to look at the server since it had crashed and wasn't coming
up properly.

I ended up staying there until 9am the next morning working on it.
Turned out to be both user and hardware error.  We had forgotten to
remove the piece of plastic to enable to battery on the card, but the
circuits on the card lied and said battery voltage was fine no matter
what the battery really was.  

So the system crashed.  4Mb of data from the filesystem when bye-bye.
Can you say oops?   What a total pain to diagnose.  But even on a log
structured filesystem, having 4Mb of data just get wiped out was
enough to destroy all the filesystem.

We ended up rolling back to the original server and junking the week
of changes that users had made, and restoring chunks for users as they
requested it.  Luckily, it was early in the semester and not alot of
stuff had gotten done yet.  

Now do you see why people are a bit hesitant of this software and it's
useage model?  While you might get great performance numbers, just one
crash and the need to restore data from tape (or I'll even give you
that you're doing D2D backups) or other media will destroy your uptime
and overall performance.  

Daniel> So long as you keep insisting it has to have some kind of slow
Daniel> transactional sync to disk in order to be reliable enough for
Daniel> enterprise use, I have to leave you in my FUD filter.  Did you
Daniel> read Ric's post where he mentions the UPS in some EMS
Daniel> products?  Ask yourself, what is the UPS for?  Then ask
Daniel> yourself if EMC makes billions of dollars selling those things
Daniel> to enterprise clients.

You cannot compare the design of Ramback to an EMC solution because
you depend on Joe User's random UPS being properly sized, configured,
maintained, etc.  

EMC does all that integration work themselves.  And they size the UPS
to *only* support their needs, and they *know* those needs down to a
T, so they can make a more certain statement of reliability.  But I
bet even they have been burned.  

Think belt and suspenders.  Be paranoid.  

Now, if you could wire up RamBack to work with an addon PCI(*) NVRAM
board of some sort, then I'd possibly be interested in running it,
because then I only have to depend on the battery on the NVRAM board
working right, and that's a simpler set of constraints to confirm.  

Again, as a professional SysAdmin, I could *never* justify using
RamBack in my business because the potential downsides do NOT justify
the speedup.  

Sure, saving my engineers time by getting them faster disks, more
disk space, bigger RAM and more CPUs is justifiable in a heartbeat.
But I also pay for NetApp NFS fileservers and their reliability and
resilienciecy when they *do* crash.  And crash they do, even though
they are not a general use OS.  

quoting some number of '9's reliability is all fine and dandy, but my
users will be happy if my file server crashed once a month but came
back up working in two minutes.  With Ramback, if the system crashes,
how long will it take for a system to come back up and be useable?

So reliability isn't just about the components, it's about the
service.  And a bunch of really short outages doesn't kill me like one
huge outage does, even if I've been getting killer filesystem
performance before and after the outage.  

I admit, my work is compute bound, but when users have jobs running
for days and sometimes weeks... downtime, esp downtime with horrible
consequences, isn't acceptable.  But downtime that let's them get back
up and working quickly is more acceptable.  

This is the point people are trying to make Daniel, that the
consequences of a single RamBack system failure aren't trivial.

Thanks,
John
