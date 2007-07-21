Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXGUGBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXGUGBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932701AbXGUGAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:00:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:16425 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbXGUGAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rTGF3u91pdjnUy+iu6BBNJXWLsP5X+KGKuVRBPezardEuUqmX7rTMlXfcK8q8Zz9MGZX0o7DZLWfDL8DrJDwCh8P/qJa7934tSSOljrJmIcGRppPAoHuXJ8sqiu8TXAUo637b+zsJsq8N0xUSH6YUiF9Df5hCdDi5pZHME/S4ks=
Message-ID: <a781481a0707202300t781345afu1ca1154a1d14e5d8@mail.gmail.com>
Date: Sat, 21 Jul 2007 11:30:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <20070720231052.GA19752@suse.de>
	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
	 <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>
	 <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
	 <20070721010257.GA9561@suse.de>
	 <20070720183733.c53b511b.akpm@linux-foundation.org>
	 <20070721014419.GA10761@suse.de>
	 <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com>
	 <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, this worked:

> His .config has CONFIG_PROFILE_LIKELY=y
> which replaces unlikely() / likely() with do_check_likely() and forces
> gcc to clobber %eax with the condition itself, which in our case was
> (ret < 0) == TRUE, and thus, the "1" value we saw in %eax in the
> register dumps.

The usage of unlikely() in BUG_ON and CONFIG_PROFILE_LIKELY=y
meant %eax that held `ret' from kobject_add() was being lost.

With that turned off:

0xc136071b      call   0xc1103744 <kobject_add>
[ ret i.e. %eax = kobject_add() ]
0xc1360720      test   %eax,%eax
[ %eax = %eax && %eax = %eax ]
[ probably gcc thinks this is an efficient < 0 check on i386 :-) ]
0xc1360722      jns    0xc1360728
[ if false jump down below, else: ]
0xc1360724      ud2a
[ invalid opcode exception. /* from BUG */ ]
0xc1360726      jmp    0xc1360726
[ for (;;) ; /* from BUG */ ]

> We should probably document somewhere that CONFIG_PROFILE_LIKELY
> is not good for debugging.
>
> Hmmm ... thinking out aloud here, but probably I don't need to fix that
> libata breakage at all. I'll just put the BUG_ON(ret < 0) back in the
> code, deselect PROFILE_LIKELY, and this time we _will_ have the
> return of kobject_add() in %eax ...

So %eax retained its value. I reproduced Michal's oops (without having
to select CONFIG_ATA, because param_sysfs_init() is called way
earlier than searching for root block device during boot -- which is what
my system didn't like without ATA), and yes, I saw:

%eax == ffffffea == -22 == -EINVAL.

But:

When I replace the BUG_ON() with Greg's (or my modified) patch,
the kernel ignores that error as we wanted, but _still_ crashes before
finding the root block device (because ATA is not in kernel and my
system seems to require it). Unfortunately, lots of dmesg output
has scrolled up by then, and our "printk" is lost. Because of no
CONFIG_ATA, nothing gets written to disk either. I don't have a
serial cable around, netconsole not up yet at that point.

Ugh, I'm running out of ideas.

Satyam
