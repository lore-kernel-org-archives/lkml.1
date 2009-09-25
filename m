Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZIYUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZIYUsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZIYUsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:48:24 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:41306 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZIYUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:48:23 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC] Privilege dropping security module
Date: Fri, 25 Sep 2009 20:48:27 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <h9jaar$url$1@taverner.cs.berkeley.edu>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <20090923223110.GA1449@c.hsd1.tn.comcast.net> <h9g795$9om$1@taverner.cs.berkeley.edu> <20090925072248.GB9821@c.hsd1.tn.comcast.net>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1253911707 31605 128.32.168.222 (25 Sep 2009 20:48:27 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 25 Sep 2009 20:48:27 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer  wrote:
>> If I understand correctly, this isn't sufficient to run untrusted code,
>> because it only restricts access to the filesystem.  You gotta restrict
>> access to the network, interaction with other processes, and so on.
>> (For instance, does dpriv let the untrusted process take over another of
>> your processes using ptrace?)
>
>Yes, currently dpriv allows a process to take over another process using
>ptrace. However, I plan on supporting limits on ptrace (and other
>things) in the future.

Ptrace is just one example: there is a non-trivial list of non-filesystem
resources that must be controlled, to run untrusted code safely.

>> I suspect making all permissions recursive is going to lead to overly
>> permissive policies.  Suppose I want to allow read access to everything
>> under /lib and /usr/lib, read-execute access to everything under /bin
>> and /usr/bin, and read-write access to everything under /tmp.  (But I
>> do not want to allow any access to any other directories.)  How do I
>> do it?
>
>The important thing is that limits can be overridden while they are
>still in the stage. This allows you to deny access to a directory, but
>still allow access to specific subdirectories.
>
>  $ echo -----X /        > /sys/kernel/security/dpriv/stage
>  $ echo r--R-X /lib     > /sys/kernel/security/dpriv/stage
>  $ echo r--R-X /usr/lib > /sys/kernel/security/dpriv/stage
>  $ echo r-xR-X /bin     > /sys/kernel/security/dpriv/stage
>  $ echo r-xR-X /usr/bin > /sys/kernel/security/dpriv/stage
>  $ echo rw-RWX /tmp     > /sys/kernel/security/dpriv/stage
>  $ echo commit          > /sys/kernel/security/dpriv/control
>
>Does this answer your question?

Unfortunately it does not, because as you note:

>It should be noted that you can still
>walk to any directory because X is allowed on /.

Which contradicts the goal of not allowing access to any other
directories.  In other words, the implementation above of my desired
policy is overly permissive.  This illustrates my more general point:
the dpriv policy specification language seems likely to lead to overly
permissive policies -- policies that are more permissive than what was
really desired.

>To prevent this you
>would have to allow X on / and then specifically deny X on /*/, but
>expanding * is something that I would rather have done in userspace.

In principle a user of dpriv could do that, to be sure, but in practice
this becomes unwieldy, so I suspect few will.  As a result, in practice
this interface to dpriv probably means that most implemented policies
will be more permissive than intended/desired.  I consider that a defect
in the design of the specification language.  It seems like it would
be preferable to have a specification language that better facilitates
secure use of dpriv.
