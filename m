Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZHFLYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZHFLYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZHFLYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:24:13 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:45759 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZHFLYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:24:12 -0400
X-SourceIP: 213.93.53.227
Subject: Re: fanotify - overall design before I start sending patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Douglas Leeder <douglas.leeder@sophos.com>, Pavel Machek <pavel@ucw.cz>,
       Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
In-Reply-To: <200908061159.45550.tvrtko.ursulin@sophos.com>
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com>
	 <1249554548.32113.137.camel@twins>
	 <200908061159.45550.tvrtko.ursulin@sophos.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 13:23:51 +0200
Message-Id: <1249557831.32113.234.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 11:59 +0100, Tvrtko Ursulin wrote:

> > I have to agree with Pavel here, either you demand the monitor process
> > is RT/mlock and can respond in time, in which case the interface doesn't
> > need a 5 second timeout, or you cannot and you have a hole somewhere.
> >
> > Now having the kernel depend on any user task to guarantee process is of
> > course utterly insane too.
> >
> > Sounds like a bad place to be, and I'd rather not have it.
> >
> > If you really need the intermediate you might as well use a FUSE
> > filesystem, but I suspect there's plenty of problems there as well.
> 
> So you mount FUSE on top of everything if you want to have systemwide 
> monitoring and then you _again_ depend on _userspace_, no? By this logic 
> everything has to be in kernel.

I was assuming there was an unprotected region on the system, otherwise
you cannot bootstrap this, nor maintain it -- see the daemon dies can't
start a new one problem.

But yes, if its so invasive to the filesystem as to make it unusable I'd
argue it to be part of the filesystem, we do filesystem encryption in
the filesystem, so why should we do such invasive scanning outside of
it?

We are taking about the kind of fanotify client that says: No you cannot
open/read/write/mmap/etc.. this file until I say you can, right?

I'd call that deeply invasive.

>  But even if it was, and the CPUs are so 
> overloaded that an userspace thread does not get to run at all for X seconds, 
> are kernel threads scheduled differently eg. with priority other than nice 
> levels?

No, except that some are run as RT processes, but other than that
they're simply yet another task.

Thing is, they don't do random things after a timeout. Its not like we
simply give up a BIO if its been in the queue for a second. No we see it
through.

> Also, it is not like that when the timeout expires the kernel will hang. 
> Rather, some application would get an error from open(2). Note how that is by 
> system configuration where the admin has made a _deliberate_ decision to 
> install such software which can cause this behaviour. 
>
> You can have a RT/mlocked client but what if it crashes (lets say busy loops)? 
> Which is also something timeout mechanism is guarding against.

By the above you're hosed anyway since starting a new one will fail due
to there being no daemon, right? Might as well forfeit all security
measures once the daemon dies. That is let security depend on there
being a daemon connected.

And once you do that, mandating the daemon to be a Real-Time process and
have everything mlocked to avoid it being DoS'd seems like a minimum
requirement.

> I really think if we want to have this functionality there is no way around 
> the fact that any userspace can fail. Kernel should handle it of course, and 
> Eric's design does it by kicking repeatedly misbehaving clients out.

Seems like a weird thing to me, suppose you DoS the system on purpose
and all clients start getting wonky, you kill them all, and are left
with non, then you cannot access any of your files anymore and
everything grinds to a halt?

> If the timeout is made configurable I think this is the best that can be done 
> here. I don't think the problem is so huge as you are presenting it.

I think having a timeout is simply asking for trouble - either you do or
you don't having a timeout is like having a random number generator for
a security policy.

Like said, having the filesystem block actions based on external
processes seems just asking for trouble.

