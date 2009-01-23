Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbZAWJr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbZAWJr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZAWJrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:47:48 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39143 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbZAWJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:47:47 -0500
Message-Id: <1232704065.25510.1296328851@webmail.messagingengine.com>
X-Sasl-Enc: oRaEBDa81rGKcmHe+MQWtxtdTsVFtW5Sg2DtLcwQPSeJ 1232704065
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Greg KH" <gregkh@suse.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20090123051620.GA8122@suse.de>
References: <20081203193901.715896543@mini.kroah.org>
 <20081203194849.GQ8950@kroah.com>
 <1232686261.9977.1296303473@webmail.messagingengine.com>
 <20090123051620.GA8122@suse.de>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Date: Fri, 23 Jan 2009 20:47:45 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 21:16 -0800, "Greg KH" <gregkh@suse.de> wrote:
> On Fri, Jan 23, 2009 at 03:51:01PM +1100, Bron Gondwana wrote:
> > On Wed, 03 Dec 2008 11:48 -0800, "Greg KH" <gregkh@suse.de> wrote:
> > > The default value for "max_user_instances" is set to 128, that should be enough too.
> > 
> > Our fairly heavily loaded postfix backup mx (lots of spams rejected per day) hit this
> > limit running kernel 2.6.27.8.  Any particular reason for it being as low as 128
> > by default?
> 
> Something had to be picked :)

Fair enough :)

> > This is a kvm virtual machine running on a reasonably beefy external box, but
> > with 2Gb RAM allocated to the mx instance because that's all kvm would let me
> > use last time I checked.  We're using KVM so the local copy of the database is
> > a little further away from the "internet facing side" and so we can build each
> > machine with our standard FAI setup.
> 
> I would suggest just changing this default value then, it's a simple
> userspace configuration item, and for your boxes, it sounds like a
> larger value would be more suitable.

Yes - I've pushed it up to 4096 now.  Should be plenty!

I guess Postfix is a bit of an odd case here.   It runs lots of processes, yet
uses epoll within many of them as well - sort of a historical design in some ways,
but also to enforce maximum privilege separation with many of the daemons able to
be run under chroot with limited capabilities.

So I guess I have a few questions left:

1) is this value ever supposed to be hit in practice by non-malicious software?
   If not, it appears 128 is too low.

2) if we're going to stick with 128, is there any way to query the kernel as to how
   close to the limit it's getting?  As an example, our system checks poll
   /proc/sys/fs/file-max every 2 minutes, and warn us if its getting "full".

I was paged a couple of nights ago because we has file-nr set at 300000, which
used to be plenty, but we had a drive failure in another machine, and moved all
our Cyrus masters off while the RAID rebuilt.  Suddenly there were heaps more
processes.  We had set the limit insanely high (page when only 5000 left), but
I managed to wake up and log in within about 4 minutes, and there were still 256
left when I shoved it up higher.

Obviously I've tuned it to be warned earlier now.  But anyway - it's possible.
I can't see any easy way to be aware when, say, 110 epolls have been used by the
same user, so I can fix the limit before it starts throttling incoming connections!

3) do you want me to write up a patch to add an epoll-max or similar procfile that
   can be queried for this value?

Bron ( the basic rule here is - if something has woken you up by failing, a test
       goes into the automated systems so you get advance warning next time )
-- 
  Bron Gondwana
  brong@fastmail.fm

