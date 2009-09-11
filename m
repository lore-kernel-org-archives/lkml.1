Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZIKMgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZIKMgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZIKMgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:36:24 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56475 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZIKMgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=adS6lEsXpLjIHW7or+yuwEyrskLRgIHj4VxRqxTTxGGPZ3GazqQdD7ArAHm5rOd4m4
         tQoAFacUIRULKMVxaWU8qU9TkZflcNuIFDp2msSy0n8mJwa3x+8ktobsHWhaxxyga/vt
         0URwf6bAywQJotacVvPZ6bgYYCMcnoplPZYKw=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <20090816210134.GA14972@elte.hu>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <200908131654.45227.rjw@sisk.pl>
	 <11fae7c70908130800q7b4a5293t5c373613d736d74@mail.gmail.com>
	 <200908132034.34951.rjw@sisk.pl>
	 <11fae7c70908161217p33830075p783880315a31b2e5@mail.gmail.com>
	 <20090816205706.GB3463@elte.hu> <20090816210134.GA14972@elte.hu>
Date: Fri, 11 Sep 2009 15:36:25 +0300
X-Google-Sender-Auth: 5a4c86cc02e9150b
Message-ID: <11fae7c70909110536i72d0607fxb03df74be0afe7a7@mail.gmail.com>
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

2009/8/17 Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>>
>> > On Thu, Aug 13, 2009 at 9:34 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> > > On Thursday 13 August 2009, Martin-Éric Racine wrote:
>> > >> On Thu, Aug 13, 2009 at 5:54 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> > >> > On Thursday 13 August 2009, Martin-Éric Racine wrote:
>> > >> >> 2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
>> > >> >> > On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> > >> >> >> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>> > >> >> >>> Yes, this bug is still valid.
>> > >> >> >>>
>> > >> >> >>> Ubuntu kernel team member Leann Ogasawara and I are slowly
>> > >> >> >>> bisecting our way through the changes that took place since 2.6.30
>> > >> >> >>> to find the commit that introduced this regression. Please stay
>> > >> >> >>> tuned.
>> > >> >> >>
>> > >> >> >> hm, the only outright Geode related commit was:
>> > >> >> >>
>> > >> >> >>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
>> > >> >> >>
>> > >> >> >> the jpg at:
>> > >> >> >>
>> > >> >> >>  http://launchpadlibrarian.net/28892781/00002.jpg
>> > >> >> >>
>> > >> >> >> is very out of focus - but what i could decypher suggests a
>> > >> >> >> pagefault crash in the VFS code, in generic_delete_inode().
>> > >> >>
>> > >> >> This one might be a bit better:
>> > >> >>
>> > >> >> http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg
>> > >
>> > > Hmm.  This looks like a sysfs oops to my untrained eye.
>> >
>> > The bisect I did with Leann Ogasawara has narrowed the kernel panic
>> > down to the following:
>> >
>> > commit f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0
>> > Author: Al Viro <viro@zeniv.linux.org.uk>
>> > Date: Mon Jun 8 19:50:45 2009 -0400
>> >
>> >     add caching of ACLs in struct inode
>> >
>> >     No helpers, no conversions yet.
>> >
>> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>>
>> Weird. If the functions do what their name suggests, i.e. if
>> inode_init_always() is an always called constructor and if
>> destroy_inode() is an unconditional destructor then this patch
>> should have no functional effect on the VFS side.
>>
>> It increases the size of struct inode, so if you have some old
>> module (built to an older version of fs.h) still around it might
>> corrupt your inode data structure.
>>
>> Or the size change might trigger some dormant bug. It might move a
>> critical inode right into the path of a pre-existing (but not
>> visibly crash-triggering) data corruption.
>>
>> The possibilities on the 'weird bug' front are endless - the
>> crash/oops itself should be turned into text, posted here and
>> analyzed.
>
> Btw., before you invest any time into the 'weird crash' theory, i'd
> suggest to double check the bisection result:
>
>  f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0    crashes
>  f19d4a8fa6f9b6ccf54df0971c97ffcaa390b7b0~1  boots fine
>
> You can save yourself from a lot of head scratching that way - the
> bisection result looks weird. (albeit plausible - a VFS crash points
> to a VFS commit.)
>
> _Maybe_ the bisection is just off a little bit (there was a
> bisection mistake in the last few steps), and the real buggy commit
> is one of the nearby ones:

We double checked again last week with fresh builds and validated that
the above result is correct.

What puzzles us is the start of the crash:


BUG: unable to handle kernel paging request at ffffb4ff
IP: [<c01f716b>] __destroy_inode+0x4b/0x80
*pde = 00810067 *pte = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/power/resume


Any ideas?
Martin-Éric
