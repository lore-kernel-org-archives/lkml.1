Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYLCMtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYLCMtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYLCMth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:49:37 -0500
Received: from vps1.tull.net ([66.180.172.116]:45802 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752320AbYLCMth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:49:37 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2008 07:49:37 EST
Date: Wed, 3 Dec 2008 23:42:52 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Geoffrey McRae <geoff@rabidhost.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: New Security Features, Please Comment
Message-ID: <20081203124252.GD11807@mail.local.tull.net>
References: <1228260494.24232.21.camel@compy.ivent.com.au> <20081203005338.6472db7a@lxorguk.ukuu.org.uk> <1228268657.6679.4.camel@lappy.spacevs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228268657.6679.4.camel@lappy.spacevs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:44:17PM +1100, Geoffrey McRae wrote:
> On Wed, 2008-12-03 at 00:53 +0000, Alan Cox wrote:
> > > (such as PHP) as the user that owns the website we are forced to fork a
> > > new process per request, then call setuid/gid and then launch the script
> > > language. This ofcource is resource intensive, but at present there is
> > > no other solution.

[...]

> But once this set is introduced a HTTP server could be written that uses
> forked children to handle requests, that have their identity swtiched
> before doing any work, including parsing CGI scripts.

I think we can do that already, using FastCGI.

As I understand it, the traditional CGI server system call flow is:

   accept
   fork
    \ setuid(user)
      exec(cgi script)

And I don't see how your 4 extra system calls would improve that flow.

The FastCGI flow is:

   setuid(user)
   exec(fastcgi script)
   loop receiving requests over a pipe and processing

In this case the handling process has already been forked and exec'ed
so the time-consuming work is done once and the script can then get
on with the business of processing requests as quickly as possible.

I'm sure there are other execution models where the CGI processors
are pre-forked. Executing the CGI script (e.g. through a scripting
language) is presumably the most expensive operation, and doing that
in advance won't be useful if you have large numbers of distinct users
but they won't all be running CGIs all the time. In other words, if you
had 300,000 users and 1 CGI script being run, you won't want to pre-fork
300,000 processes each with a different uid. But if you had 300,000
users and 200,000 different CGI scripts, you also have no choice but
to fork and exec at request time, because there are too many different
scripts.

Nick.
