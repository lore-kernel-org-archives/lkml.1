Return-Path: <linux-kernel-owner+w=401wt.eu-S934709AbXGRQta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbXGRQta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbXGRQtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:49:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:33234 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760061AbXGRQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hhCA/ievq9VDS3Qdqww8JbV/JgNGazqKO+SvXDFrDh1g/w+VOQcE4B+JdoOwIbYCgjNWMIQDcfPRH9ZhHh6L5DKBWQdB4G18hKMo3qg3AlAqglZB6xWktmJdff2anKMCiqsJphVNRhR/qUtkQ9x28Ne1ezVSqDywSRTHigJkCp4=
Message-ID: <a781481a0707180949o2a3a89c9rb4c5f1b77e964cc7@mail.gmail.com>
Date: Wed, 18 Jul 2007 22:19:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <469E42BA.7010601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
	 <469E2A68.6010307@gmail.com>
	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
	 <469E352A.90909@gmail.com>
	 <a781481a0707180906w38b151faqd7077ee3da21aff3@mail.gmail.com>
	 <469E401D.2020506@gmail.com> <469E42BA.7010601@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> Tejun Heo wrote:
> > Satyam Sharma wrote:
> >>>> sysfs_find_dirent() -- to check for -EEXIST -- should be called
> >>>> *before* we create the new dentry for the to-be-created symlink
> >>>> in the first place. [ It's weird to grab a reference on the target
> >>>> for ourselves (and in fact even allocate the new dirent for the
> >>>> to-be-created symlink) and /then/ check for erroneous usage,
> >>>> and then go about undoing all that we should never have done
> >>>> at all. ] So this test could, and should, be made earlier, IMHO.
> >>> Locking.
> >> Well s/sysfs_find_dirent/sysfs_get_dirent/ then. And then simply put
> >> down the reference later.
> >
> > Isn't that the current code?
>
> Oops, somehow thought you were talking about allocating it first.
> Gee... what difference does using sysfs_get_dirent() make?  Do you think
> the following code is correct?
>
>         sd = sysfs_get_dirent("some name");
>         if (sd != NULL)
>                 return -EEXIST;
>         lock;
>         add_new_node("some name");
>         unlock;
>         sysfs_put_dirent(sd);

Nopes, it's not, of course. We'd need the parent's i_mutex as well
as the sysfs_mutex around both the EEXIST check as well as the
actual sysfs_add_one(), which is precisely what sysfs_addrm_start
and finish are, so you're right ... I'll factor this in.

Satyam
