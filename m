Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYJQPYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYJQPYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYJQPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:24:33 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45988 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYJQPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AgUHOqU04Ks4v018ivB4VtI+PqAYf167Ms6T7b3n4T/XllrSbkl6sgBwonZS0V39xE
         45zBRsWDPSzKEiQ/dLPMpBnsxWfaUtU6TUKI7d8h4yBoRb1Jez/zo+KnBXfKUrFoW6yg
         PKPFzqOngwEk3XT3fzx0WaiyQIvfux5N5iid4=
Message-ID: <524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>
Date: Fri, 17 Oct 2008 10:24:29 -0500
From: "Steve French" <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: unlink behavior when file is open by other process
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       "Jeff Layton" <jlayton@redhat.com>
In-Reply-To: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 10:09 AM, Steve French <smfrench@gmail.com> wrote:
> Even when a file is open by another process, posix allows the file to
> be deleted (the file is removed from the namespace and eventually the
> data is removed from disk).   Unfortunately due to problems in some
> NAS filers/servers this can be hard to implement, and I am not sure
> what the "best" behavior is in that case.    Currently when unlink
> fails with the cifs network status codes equivalent to ETXTBUSY, cifs
> retries unlink by first renaming the file (ala nfs's "silly rename")
> by file handle and then marking the file attribute as "delete on
> close" (which will cause the server to unlink the file when the last
> opener closes the file).   This is similar to the behavior required by
> posix (although, like in nfs, the silly renamed file is temporarily
> visible in the namespace, can't be reopened by anyone else).
>
> Jeff Layton included a behavior change within a patch to fix another
> problem with NTCreateX flags
> (http://git.samba.org/?p=jlayton/cifs.git;a=commitdiff;h=f0c39587b7111deb13e56e5a521c5f3d8278cf5e)
> that I just merged that will break this (delete of open files) to at
> least one popular filer because that filer does not support rename by
> handle (rename of open file is one of the SMB transact2 levels, and
> one that most servers support).   His patch would give up in
> cifs_unlink if we can't "silly-rename" the file.   I have mixed
> feelings about this since with current code we can delete the file
> (mark the file delete on close) but we can't rename it (we could hide
> it in the namespace but it obviously can't be completely transparent
> because you can't create a file of the same name).
>
> Is it better to fail unlink if the file can't be removed from the
> namespace immediately or better to allow unlink (but then some
> applications will get an access denied on open if they try to create a
> file of the same name before the original opener closes the file)?

The two particular examples:
1) An application that does:
             open, unlink, close, create
used to always work but now would fail unless the server/filer has
rename-by-handle support

2) An application that does:
            open, unlink, create
used to fail (with access denied on create) when the server did not have
rename-by-handle support but now (with Jeff's patch sideeffect) will
fail on unlink.


-- 
Thanks,

Steve
