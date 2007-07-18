Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbXGRQGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbXGRQGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbXGRQGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:06:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:3936 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbXGRQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pXbbsMH5ytPQZJLy5RPbLGlPEuOQSSeXokmXAcbtNTKychMshnBpmDqyRUYQbYoOllhqqqW54KdAAxNw5JnxDdbJxnXn1Vme57gx7d+GuBVV1/cBQnLFvvNxYGRn7cKPfSQ2NFfpJSyb7p9TQAohN9AG4bxINIYMqPDPpAtGVrw=
Message-ID: <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com>
Date: Wed, 18 Jul 2007 21:36:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <469E352A.90909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>
	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
	 <469E352A.90909@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> Satyam Sharma wrote:
> >> Well, I dunno.  Probably my taste just sucks.  Please feel free to
> >> submit patches and/or suggest better ideas.
> >
> > OK, for example:
> >
> > sysfs_find_dirent() -- to check for -EEXIST -- should be called
> > *before* we create the new dentry for the to-be-created symlink
> > in the first place. [ It's weird to grab a reference on the target
> > for ourselves (and in fact even allocate the new dirent for the
> > to-be-created symlink) and /then/ check for erroneous usage,
> > and then go about undoing all that we should never have done
> > at all. ] So this test could, and should, be made earlier, IMHO.
>
> Locking.

Well s/sysfs_find_dirent/sysfs_get_dirent/ then. And then simply put
down the reference later.

> Otherwise, why would the code look like that in the first place?


> > And some similar others ... so attached (sorry, Gmail web
> > interface) please find an attempt to make sysfs_create_link look
> > a trifle more like what it should look like, IMHO. The code cleanup
> > also leads to fewer LOC, smaller kernel image (lesser by 308 bytes),
> > and even speeding up the no-error common case of this function,
> > apart from the obvious readability benefits ... it's diffed on _top_ of
> > your bugfix here, but not the other patch. [ Compile-tested only. ]
>
> Compounded if-else vs. flattened if () with common error path is pretty
> much matter of being accustomed to.  I prefer the latter because it
> scales better (less nesting and less need for extra intelligence as
> error case grows).  As I'm already used to it, it's also easier on my
> eyes.

Umm, I don't see any compounded if-else that I added that wasn't
there already ... if any are, they only make the code clearly obvious
as to what it's doing in the first place. And we've still got a common
error path. Just that the error paths do not *need* to share any other
code than the simple "return error;" precisely because it's been
cleaned up. The existing code was just horrible, IMHO.

> So, unless you have more to offer, I'm not really sure whether
> the patch improves the situation noticeably.

Readability, fewer LOC, 308 lesser bytes in kernel image and
faster for the common case -- not good enough for you?! Oh, well.

Satyam
