Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYGJHBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYGJHBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYGJHBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:01:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:30934 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYGJHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ATz9VraEKsv3/cO7TUVxs5ocXHQpcLKBYt3sBBdFCkOK+oMlAnJXuKCR+mPfhP6zX2
         QF2Kj9BdpQnGV9GSrpU+W34bKaf7xuhIqZ5ta2QFf23bvONhZhtinRTaAwcGOCe+TMHZ
         UmpTOrd+IHgDd0Czo9/zQV4qNiYD3u+IPhrWw=
Message-ID: <c56f29cb0807100001n4813df87r3da97bb9a47d23a9@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:01:34 +0200
From: "Jan Willem van den Brand" <janwillem.dev@googlemail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Jan Willem van den Brand" <janwillem.dev@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3/jbd, kernel 2.6.13, make ext3 mountable as ext2 when journal is empty.
In-Reply-To: <20080709213048.GC8517@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c56f29cb0807090821x74d0652ekc3ae4bb5725df76c@mail.gmail.com>
	 <c56f29cb0807090824k727b0da7se1a019394cdbeea7@mail.gmail.com>
	 <20080709162715.GC11797@mit.edu>
	 <c56f29cb0807091404u29acc1d7nd24071c74f33e060@mail.gmail.com>
	 <20080709213048.GC8517@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, that was the missing piece.  You have an ext2-only driver under
>  Windows, and the SD card has to be usable there.  It makes *much* more
>  sense now.  :-)

Actually, we have a different situation. I left out this part in my
explanation because I did not want to confuse people :).  But here it
goes. The SD-card is formatted with the FAT file system which has an
ext3 formatted loop file. In this way, the SD-card is "mounted" by
windows without the need for a driver. Our Windows application
accesses the loop file and only supports ext2. The embedded device
does all his writing in the loop file to ensure power fail safeness.

Initially, the solution did not pass our power fail tests. The problem
was in the page cache reordering. We have the following situation:

user | ext3 | loop | FAT | disk

The ext3 file system writes in the page cache but ensures that
ordering constraints are obeyed. By default, loop writes directly in
the page cache of the FAT file. The pages are then written out of
order to disk, disobeying the ext3 ordering constraints. Enforcing
ordered page writes by mounting the underlying file system (FAT) in
sync mode did not work because loop.c writes directly in the page
cache. We solved this by not writing directly in the page cache in
loop.c if the underlying file system is mounted in sync mode.

This solution passes our power fail tests. I will share this patch in
a new post.

>  I'll note that the code to run the journal is available in userspace,
>  and while I didn't originally write it so I can only offer it to you
>  under GPL, it wouldn't be that hard to make it work under Windows.  At
>  various times I've taken patches to make parts of e2fsprogs work under
>  Windows.  (In fact, the original version of resize2fs was paid for by
>  the folks who make PartitionMagic program, and helped pay for the down
>  payment on my house.  :-) Check out lib/ext2fs/dosio.c in the
>  e2fsprogs sources.  I don't think anyone has tried building e2fsprogs
>  on a Windows/Dos environment in quite some time, so I'm sure some
>  patches will be necessary, but it maybe quite a bit easier than you
>  think.  (As part of the PartitionMagic contract I also made parts of
>  e2fsck and mke2fs work on Windows as well, although that was over ten
>  years ago by now.)

Another solution is to compile e2fsprogs with cygwin. I actually have
compiled the latest version and it passes all tests.

>  That being said, I have to ask the question --- if the goal is Windows
>  compatibility, why aren't you using FAT?  Is the performance benefit
>  critical for your application?  Or do you need a POSIX-compliant
>  filesystem?

The embedded device has to be able to cope with power failure. FAT
becomes inconsistent after power failure. During our tests, the FAT
file system always broke in just a few power failures. Ext3 as well as
ext3 + loop (with loop patch) runs for days without breaking.

> Yes, remounting read/only will flush the journal and clear the
>  INCOMPAT_RECOVER bit.

Thanks again! I will consider this alternative.

Best regards,

Jan Willem van den Brand
