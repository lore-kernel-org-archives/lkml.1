Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYDQTaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYDQTaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYDQTaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:30:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:28346 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYDQTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z3hayIYU9PoKUScxPjqMXGjM3KuKeLeSsELABNm2MSdUlbg6f011wxpXzL8GJ/WCu3VuAzN+8Ge/u2cfRyRiWqqlWYqgHGKv1FuIdrYuuzZ4mmLhWU4jagNqRQorb2UgT5HY9kTpWx+PjUd5WJiMmNWLs9pjkSq//XSqPqzjI1o=
Message-ID: <e7ca40f70804171230l31aa6978x6ebfb41f9e4e7ba7@mail.gmail.com>
Date: Thu, 17 Apr 2008 15:30:14 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: nfs: lock stuck after interrupt
Cc: bfields@fieldses.org, trond.myklebust@fys.uio.no, eshel@almaden.ibm.com,
       neilb@suse.de, akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JmY9Y-0004e4-7R@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1JmY9Y-0004e4-7R@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We brought up this specific issue a few weeks ago in this thread:

http://marc.info/?l=linux-nfs&m=120663578712912&w=2

While we had a fix that tested out properly (third reply in the
thread), I believe Trond fixed this recently in a more "correct"
method with this patch (and series):

http://marc.info/?l=linux-nfs&m=120726349027607&w=2

We haven't had the opportunity to check Tronds' patch yet though.

-Aaron


On Thu, Apr 17, 2008 at 1:44 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> 1) on server lock file X
>  2) on client lock file X
>      blocks
>  3) on client send interrupt to process doing locking
>      locking syscall restarted, continues blocking
>  4) on server release lock on file X
>      on client lock is acquired
>  5) on client release lock on file X
>  6) on client lock file X
>      blocks
>
>  Everything up to the last step is fine, but something goes wrong
>  during the final unlock.  Stopping the nfs-server removes the stray
>  lock.
>
>  Here's a trace on the server:
>
>  lockd: request from 192.168.1.1, port=862
>  lockd: LOCK          called
>  lockd: nlm_lookup_host(192.168.1.2->192.168.1.1, p=6, v=4, my role=server, name=tucsk)
>  lockd: get host tucsk
>  lockd: nsm_monitor(tucsk)
>  lockd: nlm_lookup_file (02000001 00006200 00000002 0001783d 7f54ef79 00017801 d06c5915 00000000)
>  lockd: creating file for (02000001 00006200 00000002 0001783d 7f54ef79 00017801 d06c5915 00000000)
>  lockd: found file 0ad074c0 (count 0)
>  lockd: nlmsvc_lock(ubda/96317, ty=1, pi=1, 0-99, bl=1)
>  lockd: nlm_lookup_host(192.168.1.2->192.168.1.1, p=6, v=4, my role=server, name=tucsk)
>  lockd: get host tucsk
>  lockd: nlmsvc_lookup_block f=0ad074c0 pd=1 0-99 ty=1
>  lockd: get host tucsk
>  lockd: created block 0aeabf80...
>  lockd: vfs_lock_file returned 1
>  lockd: nlmsvc_insert_block(0aeabf80, -1)
>  lockd: release host tucsk
>  lockd: nlmsvc_lock returned 50331648
>  lockd: LOCK         status 3
>  lockd: release host tucsk
>  lockd: nlm_release_file(0ad074c0, ct = 2)
>  lockd: request from 192.168.1.1, port=862
>  lockd: CANCEL        called
>  lockd: nlm_lookup_host(192.168.1.2->192.168.1.1, p=6, v=4, my role=server, name=tucsk)
>  lockd: get host tucsk
>  lockd: nlm_lookup_file (02000001 00006200 00000002 0001783d 7f54ef79 00017801 d06c5915 00000000)
>  lockd: found file 0ad074c0 (count 1)
>  lockd: nlmsvc_cancel(ubda/96317, pi=1, 0-99)
>  lockd: nlmsvc_lookup_block f=0ad074c0 pd=1 0-99 ty=1
>  lockd: check f=0ad074c0 pd=1 0-99 ty=1 cookie=36120000
>  lockd: unlinking block 0aeabf80...
>  lockd: freeing block 0aeabf80...
>  lockd: release host tucsk
>  lockd: nlm_release_file(0ad074c0, ct = 2)
>  lockd: CANCEL        status 0
>  lockd: release host tucsk
>  lockd: nlm_release_file(0ad074c0, ct = 1)
>  lockd: closing file ubda/96317
>  lockd: request from 192.168.1.1, port=862
>  lockd: LOCK          called
>  lockd: nlm_lookup_host(192.168.1.2->192.168.1.1, p=6, v=4, my role=server, name=tucsk)
>  lockd: get host tucsk
>  lockd: nsm_monitor(tucsk)
>  lockd: nlm_lookup_file (02000001 00006200 00000002 0001783d 7f54ef79 00017801 d06c5915 00000000)
>  lockd: creating file for (02000001 00006200 00000002 0001783d 7f54ef79 00017801 d06c5915 00000000)
>  lockd: found file 0ad074c0 (count 0)
>  lockd: nlmsvc_lock(ubda/96317, ty=1, pi=2, 0-99, bl=1)
>  lockd: nlm_lookup_host(192.168.1.2->192.168.1.1, p=6, v=4, my role=server, name=tucsk)
>  lockd: get host tucsk
>  lockd: nlmsvc_lookup_block f=0ad074c0 pd=2 0-99 ty=1
>  lockd: get host tucsk
>  lockd: created block 0aeab240...
>  lockd: vfs_lock_file returned 0
>  lockd: freeing block 0aeab240...
>  lockd: release host tucsk
>  lockd: nlm_release_file(0ad074c0, ct = 2)
>  lockd: release host tucsk
>  lockd: nlmsvc_lock returned 0
>  lockd: LOCK         status 0
>  lockd: release host tucsk
>  lockd: nlm_release_file(0ad074c0, ct = 1)
>  lockd: request from 192.168.1.1, port=862
>  lockd: UNLOCK        called
>  lockd: nlm_lookup_host(192.168.1.2->192.168.1.1, p=6, v=4, my role=server, name=tucsk)
>  lockd: get host tucsk
>  lockd: nlm_lookup_file (02000001 00006200 00000002 0001783d 7f54ef79 00017801 d06c5915 00000000)
>  lockd: found file 0ad074c0 (count 0)
>  lockd: nlmsvc_unlock(ubda/96317, pi=3, 0-9223372036854775807)
>  lockd: nlmsvc_cancel(ubda/96317, pi=3, 0-9223372036854775807)
>  lockd: nlmsvc_lookup_block f=0ad074c0 pd=3 0-9223372036854775807 ty=2
>  lockd: UNLOCK        status 0
>  lockd: release host tucsk
>  lockd: nlm_release_file(0ad074c0, ct = 1)
>
>
>  Everything looks normal, yet...
>
>  This is 100% reproducable for me (ext3 exported over nfs, server and
>  client: 2.6-git).
>
>  Miklos
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
