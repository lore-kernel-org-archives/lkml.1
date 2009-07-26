Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZGZVnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZGZVnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 17:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZGZVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 17:43:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47799 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZGZVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 17:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=m6g478ysw3VFRtXLhz41kpF7eJNU04sdfg3l9o7qqDs5duNv+eC2HFDtGrGdpUtY5V
         IzVnISSkykqB6jDB7k9SQnAWocLfB4Le4+GvJqnlYz18ya5Ny18wqBhO5+xdUNewENcP
         f4VZiKSvYvjSGzli/UGOomNMiFz9pI+OlJer4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: smatch and tun.c
Date: Sun, 26 Jul 2009 23:40:57 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, eteo@redhat.com
References: <alpine.DEB.2.00.0907241400310.12573@bicker>
In-Reply-To: <alpine.DEB.2.00.0907241400310.12573@bicker>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907262340.57339.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009 14:21:54 Dan Carpenter wrote:
> Jonathan Corbet from lwn.net suggested that I write a smatch 
> (http://repo.or.cz/w/smatch.git) script to prevent the tun.c type bugs 
> from happening again.
> 
> I wrote two scripts.  One just looks for bugs where a variable is 
> dereferenced while initializing a local variable and checked for NULL like 
> this:
> 	int x = foo->bar;
> 	BUG_ON(!foo);  
> I have a theory that sometimes peoople are sloppy when they initialize 
> variables.  This script printed 96 warnings.  The other script prints 
> those messages along with every other time a variable is dereferenced and 
> then checked for NULL.  This script printed 685 messages.
> 
> Smatch scripts tends to have a lot of false positives.  The script that 
> only printed problems with variable initialization was maybe 40% actual 
> bugs but the one that checked everything was maybe 15% actual bugs.  I 
> guess my theory is correct.
> 
> One thing that causes false positives is that some macros need to 
> check for NULL pointers.  Also smatch doesn't handle loops correctly yet.  
> Sometimes variables get changed inside another function and that isn't 
> handled correctly yet.

Indeed there is still a lot of false positives but the functionality
is already very useful so big thanks for doing it!

> By bugs, I don't mean security bugs, I mean picky little things.  Quite 
> often places have useless checks for NULL.  But still it's worth fixing.

Yes, moreover they are a "noise" which makes discovery of real issues more
time consuming and difficult. 

> I feel bad for just sending this email instead of proper bug reports and 
> patches, but the truth is that I'm cycling through Africa on a bycicle.  I 
> sleep in a tent.  It took me days to scrape together enough electricity 
> and internet to send this one email...

You've just became my personal when it comes to the best use of available
resources! ;)

> I have attached a zip file with the warnings from 2.6.31-rc3 allmodconfig.
> Here are the instructions if you want to use a different config.
>     git clone git://repo.or.cz/smatch.git
>     cd smatch
>     make
>     cd /usr/src/linux
>     make C=1 CHECK=/path/to/smatch modules bzImage | tee warns.txt 
>     egrep '(warn|error):' warns.txt | egrep '(before|initializer)'

The last line needs to be:

	egrep '(warn|warning|error):' warns.txt | egrep '(before|initializer)'

to make it work, also if somebody wants to see the same list but against
current -next kernel it is here:

http://www.kernel.org/pub/linux/kernel/people/bart/null-pointer-err-list-next-0724.gz

[ some issues have been fixed already and some line numbers have changed ]

PS I'll also post a "filtered" list (without false positives) in a few days
(I've verified ~50% of entries till now).
