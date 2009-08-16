Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZHPVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZHPVMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZHPVMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:12:19 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:34787 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZHPVMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gAKIdMCkEgRWAAEyU6g9ICtTwYl49lm/u9Fq8VEwTdVGJM9PoehODrzcXM4YnfbqGy
         En6hHyz2p94QzMlkSqmffltjHcUvKK6I7lFy4/W8mq+Bd/Zux7fYyjQCtQav++uZ5KDE
         CN9E42UYons5hyFsZPPeR8VfBvAocpE4ginWw=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <20090816205706.GB3463@elte.hu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908131654.45227.rjw@sisk.pl>
	 <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com>
	 <200908132034.34951.rjw@sisk.pl>
	 <11fae7c70908161217p33830075p783880315a31b2e5@mail.gmail.com>
	 <20090816205706.GB3463@elte.hu>
Date: Mon, 17 Aug 2009 00:12:17 +0300
X-Google-Sender-Auth: e33d27ed3bb60041
Message-ID: <11fae7c70908161412v61fd233au5166e18f4c4d0931@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/16 Ingo Molnar <mingo@elte.hu>:
>
> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>
>> On Thu, Aug 13, 2009 at 9:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> > On Thursday 13 August 2009, Martin-Éric Racine wrote:
>> >> On Thu, Aug 13, 2009 at 5:54 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> >> > On Thursday 13 August 2009, Martin-Éric Racine wrote:
>> >> >> 2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
>> >> >> > On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> >> >> >> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>> >> >> >>> Yes, this bug is still valid.
>> >> >> >>>
>> >> >> >>> Ubuntu kernel team member Leann Ogasawara and I are slowly
>> >> >> >>> bisecting our way through the changes that took place since 2.6.30
>> >> >> >>> to find the commit that introduced this regression. Please stay
>> >> >> >>> tuned.
>> >> >> >>
>> >> >> >> hm, the only outright Geode related commit was:
>> >> >> >>
>> >> >> >>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
>> >> >> >>
>> >> >> >> the jpg at:
>> >> >> >>
>> >> >> >>  http://launchpadlibrarian.net/28892781/00002.jpg
>> >> >> >>
>> >> >> >> is very out of focus - but what i could decypher suggests a
>> >> >> >> pagefault crash in the VFS code, in generic_delete_inode().
>> >> >>
>> >> >> This one might be a bit better:
>> >> >>
>> >> >> http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg
>> >
>> > Hmm.  This looks like a sysfs oops to my untrained eye.
>>
>> The bisect I did with Leann Ogasawara has narrowed the kernel panic
>> down to the following:
>>
>> commit f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0
>> Author: Al Viro <viro@zeniv.linux.org.uk>
>> Date: Mon Jun 8 19:50:45 2009 -0400
>>
>>     add caching of ACLs in struct inode
>>
>>     No helpers, no conversions yet.
>>
>>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
> Weird. If the functions do what their name suggests, i.e. if
> inode_init_always() is an always called constructor and if
> destroy_inode() is an unconditional destructor then this patch
> should have no functional effect on the VFS side.
>
> It increases the size of struct inode, so if you have some old
> module (built to an older version of fs.h) still around it might
> corrupt your inode data structure.
>
> Or the size change might trigger some dormant bug. It might move a
> critical inode right into the path of a pre-existing (but not
> visibly crash-triggering) data corruption.
>
> The possibilities on the 'weird bug' front are endless - the
> crash/oops itself should be turned into text, posted here and
> analyzed.

If you mean something else than the large-size snapshot of the whole
panic output that was linked earlier in this thread, I'd appreciate
instructions on how to turn that crash into text.

Martin-Éric
