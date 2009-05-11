Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZEKSNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZEKSNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZEKSN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:13:27 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34246 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZEKSN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:13:26 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
References: <20090509143742.GA27663@kroah.com> <20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 May 2009 11:13:18 -0700
In-Reply-To: <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> (Kay Sievers's message of "Mon\, 11 May 2009 12\:46\:57 +0200")
Message-ID: <m11vqvcxtt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, greg@kroah.com, fabio.comolli@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, peterz@infradead.org, alan@lxorguk.ukuu.org.uk, arjan@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

>> Yes but you are asking all of us to maintain it.  Forever in perpetuity.
>> A better case needs to be made than you have already shipped the code.
>
> I would be very careful with such statement if you want us to accept
> your namespace hacks in the future. I guess if we ask with your next
> round "do we want to to have to maintain this for forever" you get a
> very different answer than today.

I fully expect people to ask if we want people to maintain my code
forever.

I need to extend to you a small apology you were blasting Arjan and
had added me to the CC, and I thought it was a reply to something I
wrote so my context was wrong, and I reacted more strongly than I
would have otherwise.

>> I don't see a case having been made that the existing user
>> space interface is broken.  Just that the udev implementation
>> is slow.
>
> That's utter nonsense. It's not slow at all, it's just slower that
> what we can do with the bit of help from the kernel.

Which has been my question all along where is the kernel slow?

>> I think a slow user space application is simply not a justification
>> for putting code in the kernel.
>
> Can you read? Did you read the many reasons why we want this? I guess not.

I see statements like:
"several seconds" (Your original patch)
"boot speed boot speed boot speed" (You)
"1-2 seconds" (GregKH)

And I got the impression that a very slowly running udev is what you
are trying to solve.

Your numbers actually only show a 1 second net gain on kvm.  Although
it is hard to tell what is happening.

It sounds like what you are really trying to solve is to allow more
things to run in parallel with udev.  I believe there is a very simple
way to do that.

At udevd start.
mount /dev
mknod /dev/console
mknod /dev/zero
mknod /dev/null
(and maybe a few other well know device nodes)
daemonize (to stop serializing other processes)
dynamically create everything else by looking at sysfs.

That should have a trivial serialized cost, and allow you to take
whatever time it is you need to serialize device creation.

It has the downside that it opens up the window between when devices
are in sysfs and devices are in /dev, but I don't see it creating
any new races.

Eric

