Return-Path: <linux-kernel-owner+w=401wt.eu-S935095AbXGRQ7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095AbXGRQ7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXGRQ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:59:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:40090 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbXGRQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GhzMkL4eUTfHdbwC4PcvNPgL+enoG4Fy8YhcgpPCbc0va89VEIcV8NWaVIVhsl2jE8qhH5J3mNJrBmSABP2BbpzaIsm4KwFA5B0z1nL/8dHTP7GW5vXIKzT+zNt3AhkNoy0nJXIZ10lH/e852IMjCira4a9cLqFpReyvEgSnOTo=
Message-ID: <a44ae5cd0707180959j3a51fa3frcc49fbe957c5c01e@mail.gmail.com>
Date: Wed, 18 Jul 2007 09:59:35 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Tejun Heo" <htejun@gmail.com>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de
In-Reply-To: <a781481a0707180949o2a3a89c9rb4c5f1b77e964cc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
	 <469E352A.90909@gmail.com>
	 <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com>
	 <469E401D.2020506@gmail.com> <469E42BA.7010601@gmail.com>
	 <a781481a0707180949o2a3a89c9rb4c5f1b77e964cc7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> > Tejun Heo wrote:
> > > Satyam Sharma wrote:
> > >>>> sysfs_find_dirent() -- to check for -EEXIST -- should be called
> > >>>> *before* we create the new dentry for the to-be-created symlink
> > >>>> in the first place. [ It's weird to grab a reference on the target
> > >>>> for ourselves (and in fact even allocate the new dirent for the
> > >>>> to-be-created symlink) and /then/ check for erroneous usage,
> > >>>> and then go about undoing all that we should never have done
> > >>>> at all. ] So this test could, and should, be made earlier, IMHO.
> > >>> Locking.
> > >> Well s/sysfs_find_dirent/sysfs_get_dirent/ then. And then simply put
> > >> down the reference later.
> > >
> > > Isn't that the current code?
> >
> > Oops, somehow thought you were talking about allocating it first.
> > Gee... what difference does using sysfs_get_dirent() make?  Do you think
> > the following code is correct?
> >
> >         sd = sysfs_get_dirent("some name");
> >         if (sd != NULL)
> >                 return -EEXIST;
> >         lock;
> >         add_new_node("some name");
> >         unlock;
> >         sysfs_put_dirent(sd);
>
> Nopes, it's not, of course. We'd need the parent's i_mutex as well
> as the sysfs_mutex around both the EEXIST check as well as the
> actual sysfs_add_one(), which is precisely what sysfs_addrm_start
> and finish are, so you're right ... I'll factor this in.

I tried to apply the patch you sent earlier, but it was rejected
(2.6.22-rc6-mm1 + Tejun's patch + your patch).  When you and
Tejun agree on an additional patch, I'd be happy to test it for you.

       Miles
