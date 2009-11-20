Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZKTPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZKTPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZKTPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:06:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZKTPGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:06:16 -0500
Date: Fri, 20 Nov 2009 10:04:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091120150421.GC5872@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091118153227.GA5796@redhat.com> <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com> <20091118225626.GA2974@redhat.com> <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com> <20091120141840.GA5872@redhat.com> <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 03:28:27PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Fri, Nov 20, 2009 at 3:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Corrado,
> >
> > I liked the idea of putting all the sync-noidle queues together in root
> > group to achieve better throughput and implemeted a small patch.
> >
> > It works fine for random readers. But when I do multiple direct random writers
> > in one group vs a random reader in other group, I am getting strange
> > behavior. Random reader moves to root group as sync-noidle workload. But
> > random writers are largely sync queues in remain in other group. But many
> > a times also jump into root group and preempt random reader.
> 
> can you try the attached patches?
> They fix the problems you identified about no-idle preemption, and
> deep seeky queues.
> With those, you should not see this jumping any more.
> I'll send them to Jens as soon has he comes back from vacation.
> 
> Corrado
> 
> > Anyway, with 4 random writers and 1 random reader running for 30 seconds
> > in root group I get following.
> >
> > rw: 59,963KB/s
> > rr: 66KB/s
> >
> > But if these are put in seprate groups test1 and test2 then
> >
> > rw: 30,587KB/s
> > rr: 23KB/s
> >

I quickly tried your new patches to try to keep idling enabled on deep
seeky sync queues so that it does not jump around too much and consume
share both in sync workload and sync-noidle workload.

Here are new results.

Without cgroup.

rw: 58,571KB/s
rr: 83KB/s

With cgroup:

rw: 32,525KB/s
rr: 25KB/s

So without cgroup it looks like that random reader gained a bit and that's 
a good thing.

With cgroup, problem still persists. I am wondering why both are loosing.
Looks like I am idling somewhere otherwise at least one person should have
gained.

Thanks
Vivek
