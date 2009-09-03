Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZICIzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZICIzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZICIzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:55:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:38606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbZICIzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:55:37 -0400
Message-ID: <4A9F847C.60606@kernel.org>
Date: Thu, 03 Sep 2009 17:55:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [TOOL] matchreply: make procmail aware of threads and dups
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020109000006070903070506"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 08:55:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020109000006070903070506
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

I've been reading the rather unfortunate LAK stuff on this week's LWN
and it seems like other people are having similar problems with
duplicated messages from different mailing lists.  Here's a program
I've been using for a couple of years now to solve the issue.  It
builds index of Maildir folders and can match for duplicates or a
thread a message belongs to and very easy to use with procmail.

With proper procmailrc rules, this allows me not to worry about dups
(there's race window and some might escape from time to time but no
biggie) and easily follow the threads I'm interested in by simply
moving the thread to one of the folders I keep closer eye on
regardless of the actual target delivery addresses.

The attached tarball contains README but it's outdated and doesn't
explain the -d option which matches for duplicates.

Here's my .procmailrc with some explanations which I grew over the
years and am sure can be made much prettier somehow but it should show
how it can be used.

  PATH=/usr/local/bin:/usr/bin/:/bin
  MAILDIR=$HOME/Maildir
  DEFAULT=$HOME/Maildir/
  LOGFILE=$MAILDIR/log
  VERBOSE=yes
  MREPLY="$HOME/bin/matchreply -l $HOME/Maildir/matchreply.log -v"

  #
  # matchreply duplicates
  #
  :0 Wc
  | $MREPLY -d -i waiting $MAILDIR/.Work-waiting/cur $MAILDIR/.Work-waiting/new

  :0 a
  .Duplicate/

  :0 Wc
  | $MREPLY -d -i interesting $MAILDIR/.Interesting/cur $MAILDIR/.Interesting/new

  :0 a
  .Duplicate/

  :0 Wc
  | $MREPLY -d -i inbox $MAILDIR/cur $MAILDIR/new

  :0 a
  .Duplicate/

#### The above rules match duplicates against folders I keep close eye
#### on.  All dups are collected in Duplicate folder which I sometimes
#### open when I'm suspicious whether things are working as expected.
#### It hasn't failed me yet.

  #
  # deliver by threads
  #
  :0 Wc
  | $MREPLY -i waiting $MAILDIR/.Work-waiting/cur $MAILDIR/.Work-waiting/new

  :0 a
  .Work-waiting/

  :0 Wc
  | $MREPLY -i interesting $MAILDIR/.Interesting/cur $MAILDIR/.Interesting/new

  :0 a
  .Interesting/

  :0 Wc
  | $MREPLY -i inbox $MAILDIR/cur $MAILDIR/new

  :0 a
  $DEFAULT

#### And the above match look for a matching thread so that a reply
#### always ends up on the thread regardless of the actual delivery
#### address.  So, when I spot some interesting thread in lkml, I
#### simply move the thread to one of the above folders and any
#### further messages on that thread will be delivered to that folder
#### instead of the unholily large lkml folder.

  #
  # filter spam
  #
  :0fw: spamassassin.lock
  * < 256000
  | spamassassin

  :0:
  * ^X-Spam-Status: Yes
  .Spam/

#### And only after matching for threads in the interested folders, I
#### run it through spamfilter.  So, if you're a spammer and is
#### specifically targetting me, you can sent the spam as a reply to
#### the threads I was involved in.  Thank you very much.

  #
  # Mailing list rules
  #
  :0
  * ^(X-Mailing-List:.*(linux-.*|git)@vger\.kernel\.org|^List-Id:.*\.suse\.de|.*List-Id:.*suse\.de|.*List-Id:.*linuxdriverproject\.org)
  {
#### For all the messages sent to mailing lists

	  #
	  # Deliver mails addressed to me into INBOX
	  #

	  :0
	  * ^(To|Cc):.*(htejun@gmail\.com|teheo@novell\.com|teheo@suse\.de|tj@kernel\.org)
	  $DEFAULT

#### As dups have been filtered already, anything with me on the to/cc
#### list can be delivered to my INBOX.

	  #
	  # Don't let cross-posted messages of a thread end up in
	  # different folders.
	  #

	  :0 Wc
	  | $MREPLY -d -i lide $MAILDIR/.Linux-ide/cur $MAILDIR/.Linux-ide/new

	  :0 a
	  .Duplicate/

	  :0 Wc
	  | $MREPLY -d -i lscsi $MAILDIR/.Linux-scsi/cur $MAILDIR/.Linux-scsi/new

	  :0 a
	  .Duplicate/

	  :0 Wc
	  | $MREPLY -i lide $MAILDIR/.Linux-ide/cur $MAILDIR/.Linux-ide/new

	  :0 a
	  .Linux-ide/

	  :0 Wc
	  | $MREPLY -i lscsi $MAILDIR/.Linux-scsi/cur $MAILDIR/.Linux-scsi/new

	  :0 a
	  .Linux-scsi/

#### And for the rest, dups are check and all threads are grouped
#### together depending on where they currently are.  I pay more
#### attention to linux-ide, so any cross posted threads will end up
#### there instead of other mailing lists.

	  #
	  # Okay, deliver according to address
	  #

	  :0
	  * ^(X-Mailing-List|To|Cc):.*linux-ide@vger\.kernel\.org
	  .Linux-ide/

	  :0
	  * ^(X-Mailing-List|To|Cc):.*linux-scsi@vger\.kernel\.org
	  .Linux-scsi/

	  :0
	  * ^(X-Mailing-List|To|Cc):.*linux-kernel@vger\.kernel\.org
	  .LKML/

	  :0
	  $DEFAULT
  }

Hope it's helpful for somebody.

Thanks.

-- 
tejun

--------------020109000006070903070506
Content-Type: application/x-gzip;
 name="matchreplay.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="matchreplay.tar.gz"

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
--------------020109000006070903070506--
