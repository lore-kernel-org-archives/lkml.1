Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZLRC7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZLRC7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZLRC7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:59:05 -0500
Received: from lists.laptop.org ([18.85.2.145]:36430 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752080AbZLRC7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:59:01 -0500
Date: Thu, 17 Dec 2009 22:00:57 -0500
From: Michael Stone <michael@laptop.org>
To: Mark Seaborn <mrs@mythic-beasts.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Message-ID: <20091218030056.GC3047@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091217.225856.145758950057800056.mrs@deli>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, Andi, Eric, and Randy,

First, thanks for all the comments, questions, and suggestions. They're very
much appreciated.

@Randy: In the revised patches that follow, I moved the documentation to

   Documentation/prctl/network.txt 

as you requested.

@Américo: In the revised patches that follow, I moved prctl_{get,set}_network()
into sys/kernel.c as you suggested.

@Eric, Mark: regarding ptrace()-ing from network-disabled processes: I agree
that this functionality is critical and I have altered the
__ptrace_may_access() check to support it. 

The new rule I propose is equivalent to the rule I used in ptrace_set_network()
and is similar to the rule that Eric proposed earlier this afternoon. I now
propose:

   "You may ptrace() any process that has all the network restrictions you do."

This should take care of your use of strace without bending anything else into
an unnatural shape.

------------------------

@Andi, Mark

Next, let's talk about the "ad-hoc"-ness of the current patches. There seem to
be three issues:

   1. What is "network access"?

   2. How should "network access" be access-controlled?

   3. Should we add a per-process boolean flag enabling and disabling some
      kinds of network access?

Here are my thoughts:

   1. "Network access" refers to the ability of a security principal to send
      messages to or to receive messages from a different principal. For our
      purposes, principals may be thought of as processes.

   2. Messages are sent and received over "channels". Common channels include
      open file descriptors, memory segments, message queues, file systems,
      process signalling trees, and ptrace attachments.
      
   3. The creation of new channels between principals is a security-sensitive
      operation. 

   4. The decision about whether or not to authorize opening a new channel
      between security principals should be based on five inputs:

            a) the general system policy, if any, of the sysadmin
            b) the personal policies, if any, of the human operator(s)
            c) the authors' policies, if any, in security principal(s)
            d) the channel being requested
            e) security labels like pids, uids, and acls labeling the principals

   5. Linux today has pretty good support for controlling the creation of
      channels involving the filesystem and involving shared daemons. It has
      mediocre support for access control involving sysv-ipc mechanisms. It has
      terrible support for access control involving non-local principals like
      "the collection of people and programs receiving packets sent to
      destination 18.0.0.1:80 from source 192.168.0.3:34661".

   6. We can make it easier and safer to write and to run software by improving
      the access control mechanisms available for deciding whether or not to
      open new channels.

   7. The best way to improve said access control mechanisms today is to add a
      facility that permits any process to drop the (heretofor not formally
      recognized) privilege that causes the kernel to open new *insufficiently
      access controlled* network channels.

   8. Anything that has to pass a regular Unix uid/gid/world discretionary
      access check *and* which the partner principal(s) have the opportunity to
      turn down is sufficiently access controlled. Everything else is not.

      (For example, filesystem Unix sockets are sufficiently controlled but
      ptrace is not because the process being traced has no opportunity to say
      "don't open this channel".)

   9. My patch implements the simplest and most usable improvement available in
      this area.

Critiques?

Alternately, you've both expressed some interest in a more general facility for
restricting network access. Do either of you have specific ideas on what you'd
like to see?

Michael
