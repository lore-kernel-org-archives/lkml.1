Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZGWHob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZGWHob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZGWHob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:44:31 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62810 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZGWHoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UMInk7F+HvcMctVKsQy3mEe8Bn254EmOYa5anHxUteaYfge1pmyyuDPpC6KPonaW6d
         Zf/d7At776Iksn+Y1mobhY/FApzbu/AEEhhXAdFmj10ZfdrOwDakwonP94p+ErqRHcUV
         ygxnGVDge4HbcF9SRuXD1giVgRV/qUNghxTSQ=
MIME-Version: 1.0
In-Reply-To: <d8bd05e00907222324q26b8faa0i2d85f4d7e35d8198@mail.gmail.com>
References: <62.47.75.132.1247818962.wm@webmail.inode.at>
	 <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
	 <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
	 <524f69650907222310h433cfe86vaef63c8ea2e56d56@mail.gmail.com>
	 <d8bd05e00907222324q26b8faa0i2d85f4d7e35d8198@mail.gmail.com>
Date: Thu, 23 Jul 2009 02:44:30 -0500
Message-ID: <524f69650907230044u5ab44c59y91bc9b808f5fd6c3@mail.gmail.com>
Subject: Re: mounting cifs filesystems not possible
From: Steve French <smfrench@gmail.com>
To: Gerhard Hintermayer <gerhard.hintermayer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 1:24 AM, Gerhard
Hintermayer<gerhard.hintermayer@gmail.com> wrote:
> See my original post to LKML at http://lkml.org/lkml/2009/7/15/217.
> You can see kernel version, and dmesg output (including cifsFYI set to
> 7) there.
> I did file a bug report to gentoo bug list and lkml. Shall I also do
> so for bugzilla.samba.org ? I think it's more kernel related.
>
> The DebugData of the share I'm trying to mount (fortunaltely I got a

> mount -t cifs -o user=aprol,password=*****,ip=10.5.12.105 //BRKVN05/AtlasPM /mnt/AtlasPM

The mount syntax you listed in your post is a little strange with the
mount options preceding rather than following the UNC name and device,
ie rather than the usual:
              mount.cifs {//unc-name} {mount-point} [-o options]

It looks like the first 3/4 of mount succeeded (setting up a session,
and connecting to the share) to the point of doing the lookup of the
root directory of the share (which I don't see in your trace).
Typically there have been the following reasons for that to fail:
1) the user has no permission on the root of the share
or
2) the root of the share is a dfs referral to another server (this
should work now, but was probably not supported a few kernel releases
ago)
or
3) the server reports that the root directory is not a directory (ie
is a file for example)

It may be that an earlier mount failed perhaps oopsing in the vfs, and
that could have left an existing cifs session and tree connection
which made it seem like a later mount worked (since it found an
existing session) but that seems unlikely.

It would be helpful to see if the client did a network request (in
this case SMB transact2 Query Path Info) on the root directory of the
share, so if you have a wireshark trace that would be useful.
-- 
Thanks,

Steve
