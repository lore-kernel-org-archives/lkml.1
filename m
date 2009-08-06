Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZHFK7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZHFK7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZHFK7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:59:53 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:43909 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZHFK7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:59:52 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: fanotify - overall design before I start sending patches
Date: Thu, 6 Aug 2009 11:59:44 +0100
User-Agent: KMail/1.9.10
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
References: <1248466429.3567.82.camel@localhost> <4A7AAE89.20205@sophos.com> <1249554548.32113.137.camel@twins>
In-Reply-To: <1249554548.32113.137.camel@twins>
MIME-Version: 1.0
Message-Id: <200908061159.45550.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2009 11:59:50,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2009 11:59:51,
	Serialize complete at 06/08/2009 11:59:51
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009 11:29:08 Peter Zijlstra wrote:
> On Thu, 2009-08-06 at 11:20 +0100, Douglas Leeder wrote:
> > Pavel Machek wrote:
> > > On Wed 2009-08-05 17:46:16, Tvrtko Ursulin wrote:
> > >> On Wednesday 05 August 2009 03:05:34 Pavel Machek wrote:
> > >>
> > >> Just to make sure you haven't missed this - it is not that they have
> > >> to complete the whole operation before the timeout period (since you
> > >> mention realtime/mlock I suspect this is what you think?), but
> > >> _during_ the operation they have to show that they are active by
> > >> sending something like keep alive messages.
> > >>
> > >> Or you are worried about failing to meet even that on a loaded system?
> > >> There has to be something like this otherwise hung userspace client
> > >> would kill the whole system.
> > >
> > > Of course, I'm worried about failing to meet this on loaded
> > > system. And the fact that I _have_ to worry about that means that
> > > interface is ugly/broken.
> >
> > You mean that in 5 seconds, you won't have any point when you can tell
> > the kernel, "I'm still working"?
>
> I have to agree with Pavel here, either you demand the monitor process
> is RT/mlock and can respond in time, in which case the interface doesn't
> need a 5 second timeout, or you cannot and you have a hole somewhere.
>
> Now having the kernel depend on any user task to guarantee process is of
> course utterly insane too.
>
> Sounds like a bad place to be, and I'd rather not have it.
>
> If you really need the intermediate you might as well use a FUSE
> filesystem, but I suspect there's plenty of problems there as well.

So you mount FUSE on top of everything if you want to have systemwide 
monitoring and then you _again_ depend on _userspace_, no? By this logic 
everything has to be in kernel. But even if it was, and the CPUs are so 
overloaded that an userspace thread does not get to run at all for X seconds, 
are kernel threads scheduled differently eg. with priority other than nice 
levels?

Also, it is not like that when the timeout expires the kernel will hang. 
Rather, some application would get an error from open(2). Note how that is by 
system configuration where the admin has made a _deliberate_ decision to 
install such software which can cause this behaviour. 

You can have a RT/mlocked client but what if it crashes (lets say busy loops)? 
Which is also something timeout mechanism is guarding against.

I really think if we want to have this functionality there is no way around 
the fact that any userspace can fail. Kernel should handle it of course, and 
Eric's design does it by kicking repeatedly misbehaving clients out.

If the timeout is made configurable I think this is the best that can be done 
here. I don't think the problem is so huge as you are presenting it.

Tvrtko
