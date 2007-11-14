Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbXKNWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbXKNWsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXKNWsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:48:09 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:29318 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761269AbXKNWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N9EvgwzpWsYrgymJUlYn4EF/k3Yr+URGexysgTGNRNk5h0DTYWowdwI0tIlR7mpwyyE4mvCzKbxLRc5mGe92R+Fmn2LjaAMgmrPqErtiaBDVO4vucBqs+YPtozI2AJVyvNj+TFBlOnHYcYnBQCkiynVDH8+awKVRroVTrwhFAck=
Message-ID: <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
Date: Wed, 14 Nov 2007 23:48:05 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Jan Blunck" <jblunck@suse.de>
Subject: Re: 2.6.24-rc2-mm1
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
In-Reply-To: <20071114122939.7b4ee194.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	 <20071114122939.7b4ee194.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 9:29 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 14 Nov 2007 20:16:09 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > On Nov 14, 2007 2:59 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> >
> > Breaks nfsv4 in a rather funny way:
> >
> > treogen ~ # cd /usr/portage/x
> > treogen x # touch bla
> > touch: cannot touch `bla': File exists
> > treogen x # mkdir bla
> > treogen x # touch bla/bla
> > touch: cannot touch `bla/bla': File exists
> > treogen x # ls -lad *
> > drwxr-xr-x 2 root root 6 Nov 14 20:03 bla
> > treogen x # ls -la *
> > total 0
> > drwxr-xr-x 2 root root  6 Nov 14 20:03 .
> > drwxr-xr-x 3 root root 16 Nov 14 20:03 ..
> > treogen x #
> >
> > So I can create new directories, but not new files. Reading files works normal.
> >>
> > The client is 2.6.24-rc2-mm1, the server 2.6.22-gentoo-r9.
> > The fstab-line from the client:
> > 192.168.2.4:/portage    /usr/portage            nfs4
> > rw,noatime,nodiratime,intr 0 0
> >
> > 2.6.23-mm1 as client worked, some 2.6.24-rc1-git? also.
>
> hm.  I guess that means I get to do yet another git-bisect.  Either the nfs
> changes or r-o-bind-mounts, I bet.

Seems like you would lose that bet.

I don't have the time to finish the bisect, but there are only 19
patches remaining and three of them look like the prime suspects:

20709a71062a02d0271424f78c547dc733e863fe use-struct-path-in-struct-svc_expkey
b07dd17327f38b9a5401415c0fbf816e6cd0051b
use-struct-path-in-struct-svc_export-checkpatch-fixes
a0886174a1bc1b7c172d40c1e416ba7e48a35ffd use-struct-path-in-struct-svc_export
62e954810588af549580026c3d8718e7717837d0
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes
06719d94df24e67ccecf38cf4c6879188dd3f18a
d_path-make-get_dcookie-use-a-struct-path-argument
979a6d93394b28eee31f3322177827ec938eb34f
d_path-make-proc_get_link-use-a-struct-path-argument
59b0e6c59449dc2fc2366d54f76470056483f9e6
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes
f15c39b7240e37ba89433aba610bfa10bd22b4f7
d_path-use-struct-path-in-struct-avc_audit_data
84556ff61beaacc32d7bcba3d644d4d8d6539356 d_path-kerneldoc-cleanup
5087403994daedc7bfd338f65b7dc69216b03e2e
one-less-parameter-to-__d_path-checkpatch-fixes
b610833be56ae170d33d91ee4325b70d38d6f28b one-less-parameter-to-__d_path
7395eaf4a37d80dd657e1b527de0cf9c94b4f866 introduce-path_put-unionfs
dde9146c8a1cec65d3d62ff0cbbea03598ccf1f5
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs
5fc66f255cfc1780ca22b7ddcd2d91d1abd68e48 introduce-path_get-unionfs
0ef3d8718cc6732ed2d8294cee8838bf451bd133 make-set_fs_rootpwd-take-a-struct-path
be604962ef9505c13e2ce757c0c557bd2f9fd19e use-struct-path-in-fs_struct
b87fbae44dd2eb0fe803f888d8f7fa1fb820553c introduce-path_get
9780697f9e775cbcf62b18780036fbb03b76100f
use-path_put-in-a-few-places-instead-of-mntdput
53923d3167a3820ec21ba6464da80395a5d32dce introduce-path_put

(sha1 come from
git://git.kernel.org/pub/scm/linux/kernel/git/smurf/linux-trees.git)

I added Jan Blunck to the recipents, as he wrote
use-struct-path-in-struct-svc_expkey and
use-struct-path-in-struct-svc_export

Torsten
