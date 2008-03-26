Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbYCZNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbYCZNWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYCZNWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:22:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYCZNWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yfr98evkQgYymw1hgdBOHSXbERnJ7J81oe/Ef9QEfe1/qVo+3MpDwlckHNTbJprGwnNjpS+tPB2Oy2y6ztpoMfMqjZvzqWFUQN+NGAfdnqo0335UbYwR7s0A5mlY0mgBeL9JYKgSQrt9dxtL8HgJQugTjlH7Kf35pavp7rSa4n8=
Message-ID: <e2e108260803260622u2fc56bc2u25f061fe1e60b00b@mail.gmail.com>
Date: Wed, 26 Mar 2008 14:22:10 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Emmanuel Florac" <eflorac@intellique.com>
Subject: Re: RAID-1 performance under 2.4 and 2.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080326133632.640aa0d2@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080325194306.4ac71ff2@galadriel.home>
	 <e2e108260803260142o34c33e7ajf395d5cb62824cb4@mail.gmail.com>
	 <20080326120713.24cb8093@harpe.intellique.com>
	 <e2e108260803260415w64fa4feave44560dd7ac7cbdb@mail.gmail.com>
	 <20080326133632.640aa0d2@harpe.intellique.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 1:36 PM, Emmanuel Florac <eflorac@intellique.com> wrote:
> Le Wed, 26 Mar 2008 12:15:57 +0100
>
> "Bart Van Assche" <bart.vanassche@gmail.com> écrivait:
>
> > You are welcome to post the numbers you obtained with dd for direct
>  > I/O on a RAID-1 setup for 2.4 versus 2.6 kernel.
>
>  Here we go (tested on a slightly slower hardware : Athlon64 3000+,
>  nVidia chipset) . Actually, direct IO result is identical. However, the
>  significant number for the end user in this case is the NFS thruput.
>
>  2.4 kernel (2.4.32), async write thru NFS mount
>  --------------------------------
>  emmanuel[/mnt/temp]$ dd if=/dev/zero of=./testdd01 bs=1M count=1024
>  1073741824 bytes (1,1 GB) copied, 15,5176 s, 69,2 MB/s
>
>  2.4 kernel (2.4.32), sync write
>  --------------------------------
>  root@0[root]# ./dd if=/dev/zero of=/mnt/raid/testdd01 bs=1M count=1024 \
>  oflag=direct,dsync
>  1073741824 bytes (1.1 GB) copied, 21.7874 seconds, 49.3 MB/s
>
>  2.6 kernel (2.6.22.18), async write thru NFS mount
>  --------------------------------
>  emmanuel[/mnt/temp]$ dd if=/dev/zero of=./testdd02 bs=1M count=1024
>  1073741824 bytes (1,1 GB) copied, 21,3618 s, 50,3 MB/s
>
>  2.6 kernel (2.6.22.18), sync write
>  --------------------------------
>  root@0[root]# ./dd if=/dev/zero of=/mnt/raid/testdd02 bs=1M count=1024 \
>  oflag=direct,dsync
>  1073741824 bytes (1.1 GB) copied, 21.7011 seconds, 49.5 MB/s

It's good to see that the synchronous write throughput is identical
for the 2.4.32 and 2.6.22.18 kernels.

Regarding NFS: there are many parameters that influence NFS
performance. Are you using the userspace NFS daemon or the NFS daemon
in the kernel ? Telling NFS that it should use TCP instead of UDP
usually increases performance, as well as increasing the read and
write block size. And if there is only a single client accessing the
NFS filesystem, you can increase the attribute cache timeout in order
to decrease the number of NFS getattr calls. You could e.g. try the
following command on the client:

mount -o remount,actimeo=86400,rsize=1048576,wsize=1048576,nfsvers=3,tcp,nolock
/mnt/temp

Please read the nfs(5) man page before using these parameters in a
production environment. Note: the output of the nfsstat command can be
helpful when optimizing NFS performance.

Bart.
