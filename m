Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZDABua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZDABua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZDABuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:50:19 -0400
Received: from thunk.org ([69.25.196.29]:34007 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZDABuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:50:17 -0400
Date: Tue, 31 Mar 2009 21:50:10 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Cc: Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090401015010.GB4529@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
	Alberto Gonzalez <info@gnebu.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D2A5AB.1090704@ursus.ath.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 01:22:19AM +0200, Andreas T.Auer wrote:
> You are always thinking about the few seconds/minutes of work you gonna
> lose, but there are different situations, too.
> 
> E.g. your POP3 client receives a very important mail, saves it to disk,
> uses fsync to make sure it is out and tells the server to delete it. If
> you are gonna delay the fsync, you will have a long window in which the
> mail can get lost instead of a minimum window. Or are there any POP3
> clients, which can synchronize the mail-polling with a spinning a disk?

True, but consider --- this is a laptop we're talking about, right?
What if the laptop hard drive crashes after you accidentally drop your
laptop.  Even if you're using an SSD, what if someone steals your
laptop.  Your first mistake was using POP3.  :-)   

Personally, what I do is create a local *copy* of my IMAP mailbox, and
I delete messages on the local copy of the mail spool --- and then
periodically I run a program called "mbsync"
(http://isync.sourceforge.net) to propagate deletes back to the IMAP
server, and download new mail to my local Maildir copy of my mail spool.

But still, you're right.  In some cases, you really want "fsync()" to
mean "fsync()".  I'm not sure how often such applications _should_ be
running on a laptop which is prone to be being dropped and/or stolen.
This would have to be something that a user chooses to do on their
system, and they would have to take into account whether they are
running some workloads that really can't tolerate data loss or not.

If all they are doing is browsing the web, and the issue is firefox's
desire to constantly write to their home directory, the user should be
able to say, "you know, my battery life is more important that making
sure that every last web page I visit is saved away in some file ---
Firefox's 'Awesome Bar' really isn't worth that much to me."

Of course, there is the question whether most users will be able to
understand the risks of doing things like using POP3 and fetchmail as
described in your scenario above.  And that's a valid question --- so
it's worth asking whether suppressing fsync()'s really saves enough
power to be worth it, as opposed to say, fixing applications that are
write-happy, or choosing not to use applications which are write-happy
when you are running on battery.

						- Ted
