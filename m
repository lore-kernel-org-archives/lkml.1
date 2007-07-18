Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXGRPa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXGRPa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXGRPaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:30:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:43662 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbXGRPaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cX0fVsdx0e3LiR3baTbNcqvToD1ge6Pkj086/SfLclG3F1+8lVGBOzdkXJybPT2qUNMk8F4OO9CZzFFePUVTpFmqKDQDUGDtIj4eA4cXYiVIBORbq4VYWNPOiQaeqPbKOrb4SPT/070Ei7kUeuS6ednsEAL81UcOXzNp+Mt/xuI=
Message-ID: <a781481a0707180830g44cdd38etb4a540afce218065@mail.gmail.com>
Date: Wed, 18 Jul 2007 21:00:13 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>
	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi,
>
> On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> > Satyam Sharma wrote:
> > > On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> > >> There is a subtle bug in sysfs_create_link() failure path.  When
> > >> symlink creation fails because there's already a node with the same
> > >> name, the target sysfs_dirent is put twice - once by failure path of
> > >> sysfs_create_link() and once more when the symlink is released.
> > >
> > > The "symlink" is released? But the creation of the symlink is
> > > precisely what failed here ... did it not?
> > >
> > >> Fix it by making only the symlink node responsible for putting
> > >> target_sd.
> > >
> > > And again ... the changelog sounds confusing indeed, perhaps I'm
> > > not familiar enough with sysfs symlink-related terminology/semantics.
> > > Care to elaborate?

BTW, please do explain this one to me, if you can find the time :-)

> > > Wow. This looks like a very mysterious way to fix a mysterious bug :-)
> > > BTW I just looked over at sysfs_create_link() and ... it looks quite ...
> > > unnecessarily complicated/obfuscated ...
> >
> > Well, I dunno.  Probably my taste just sucks.  Please feel free to
> > submit patches and/or suggest better ideas.
>
> OK, for example:
>
> sysfs_find_dirent() -- to check for -EEXIST -- should be called
> *before* we create the new dentry for the to-be-created symlink
> in the first place. [ It's weird to grab a reference on the target
> for ourselves (and in fact even allocate the new dirent for the
> to-be-created symlink) and /then/ check for erroneous usage,
> and then go about undoing all that we should never have done
> at all. ] So this test could, and should, be made earlier, IMHO.

A trivial nit:

The cleanup ignores the return of sysfs_addrm_finish() -- functions
such as those could and should be void-returning. It doesn't even
need to return an int for success / failure ... I went over it's code,
and it's obvious that the function just never fails!

Returning the count of objects actually added / removed is quite
redundant too, because we return "actx->cnt" unconditionally
from inside it, and the caller can know that anyway, without
even calling it. Also, note that nowhere in the present code is
the return of that function ever being used in that sense (i.e. as
a "count") anyway ...

So: best to just make it void-returning. That's what it is.

Satyam
