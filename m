Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbXFDBGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbXFDBGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXFDBFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:05:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:16716 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXFDBFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RMbKfzujefgd18xsIPMgPcDqdIwZZNLPow+eNriRQwseP/3XXADzqInJ3wLeKH7hLqzC2rDOCIquV1RBb85g6YGBj93r2Jb+1kgONLwO/sLRnDzhhhHYdhI7Q4Q0loTwV8JAETbELhW38GLQFHu8TAXF6FYSlYP0HI6eZYDCr3o=
Message-ID: <e7ca40f70706031805h56da4c3ag2dd0e902430785cc@mail.gmail.com>
Date: Sun, 3 Jun 2007 21:05:51 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
Cc: "John Stoffel" <john@stoffel.org>
In-Reply-To: <18019.21781.470399.393340@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <18019.21781.470399.393340@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, thanks for responding.  I'm using kernel 2.6.20 on a
home-grown distro.

I've responded to a few specific points inline - but as a whole,
Davide directed me to work that is being done specifically to address
these issues in the kernel, as well as a userspace implementation that
would allow me to sidestep this failing for the time being.


On 6/3/07, John Stoffel <john@stoffel.org> wrote:
>
> How large are these files?  Are they all in a single directory?  How
> many files are in the directory?
>
> Ugh. Why don't you just write to a DB instead?  It sounds like you're
> writing small records, with one record to a file.  It can work, but
> when you're doing thousands per-minute, the open/close overhead is
> starting to dominate.  Can you just amortize that overhead across a
> bunch of writes instead by writing to a single file which is more
> structured for your needs?

In short, I'm distributing logs in realtime for about 600,000
websites.  The sources of the logs (http, ftp, realmedia, etc) are
flexible, however the base framework was build around a large cluster
of webservers.  The output can be to several hundred thousand files
across about two dozen filers for user consumption - some can be very
active, some can be completely inactive.

> Netapps usually scream for NFS writes and such, so it sounds to me
> that you've blown out the NVRAM cache on the box.  Can you elaborate
> more on your hardware & Network & Netapp setup?

You're totally correct here - Netapp has told us as much about our
filesystem design, we use too much ram on the filer itself.  Its true
that the application would handle just fine if our filesystem
structure were redesigned - I am approaching this from an application
perspective though.  These units are capable of the raw IO, its the
simple fact that open calls are taking a while.  If I were to thread
off the application (which Davide has been kind enough to provide some
libraries which will make that substantially easier), the problem
wouldn't exist.

> The problem is that O_NONBLOCK on files open doesn't make sense.  You
> either open it, or you don't.  How long it takes to comlete isn't part
> of the spec.

You can certainly open the file, but not block on the call to do it.
What confuses me is why the kernel would "block" for 415ms on an open
call.  Thats an eternity to suspend a process that has to distribute
data such as this.

> But in this case, I think you're doing something hokey with your data
> design.  You should be opening just a handful of files and then
> streaming your writes to those files.   You'll get much more
> performance.

Except I cant very well keep 600,000 files open over NFS.  :)  Pool
and queue, and cycle through the pool.  I've managed to achieve a
balance in my production deployment with this method - my email was
more of a rant after months of trying to work around a problem (caused
by a limitation in system calls), only to have it present an order of
magnitude worse than I expected.  Sorry for not giving more
information off the line - and thanks for your time.

-Aaron
