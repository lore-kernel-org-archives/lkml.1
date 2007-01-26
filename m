Return-Path: <linux-kernel-owner+w=401wt.eu-S1161018AbXAZPMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161018AbXAZPMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030752AbXAZPMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:12:55 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:60816 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030731AbXAZPMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:12:54 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 3/3] have pipefs ensure i_ino uniqueness by calling iunique and hashing the inode
Date: Fri, 26 Jan 2007 16:12:52 +0100
User-Agent: KMail/1.9.5
Cc: Kirill Korotaev <dev@openvz.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200612291911.kBTJBLvx019107@dantu.rdu.redhat.com> <45B9F939.8070701@openvz.org> <45BA1359.7020200@redhat.com>
In-Reply-To: <45BA1359.7020200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261612.52414.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 15:42, Jeff Layton wrote:
> Kirill Korotaev wrote:
>  > Jeff,
>  >
>  > is 100% uniqeness is so much required for pipe inode numbers?
>  > AFAIU, it is not that critical for pipefs (unlike smb, nfs etc.)
>  >
>  > Thanks,
>  > Kirill
>
> There is no in-kernel reason why i_ino uniqueness is important for
> pipefs. Where it might matter is userspace. The i_ino value is used for:
>
> 1) the st_ino value returned in stat calls
>
> 2) the dentry name (generated as "[inode_number]")
>
> So while it's certainly not "correct" to have multiple inodes with the same
> number on any filesystem, it is probably more important in some places is
> others. For pipefs, maybe it isn't, especially given a potential 6%
> performance impact to fix it. Anyone else have thoughts?

For dentry name, we certainly could use "[address of inode]" instead 
of "[inode number]" to get unicity, but do we care ?

For st_ino values on pipefs and sockets, I doubt any user application would 
care. I never had to fstat() a socket fd. Of course it's a file descriptor, 
but all we really want to do with this kind of file descriptor is to call 
socket API.

And for some heavy loaded internet servers , the additional cost of 
insert/delete a node in a machine shared tree could be a problem.

Some weeks ago I suggested to not hash pipe/socket dentries in order to save 
some locked ops (see commits 304e61e6fbadec586dfe002b535f169a04248e49 & 
b3423415fbc2e5461605826317da1c8dbbf21f97 ), so obviously I prefer not adding 
another tree ops. However, pipe/sockets creation/destroy are probably not 
that frequent, so the 6% perf impact is not that big :)

Eric
