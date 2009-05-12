Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZELPiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZELPiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZELPiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:38:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19889 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZELPiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=OL8Cdd++tcjuW69uK7cr/6XzOtMyNPeEfVqwzD1rhHQ3opZcj6z+ket9u1OaVs407F
         ssrheN/TSLZ4hl7+Ib+oTCjpMKqjIMXiiiYnJX46fTXMRvXGWSK0F6Z0AkbM0a78Iyp6
         WQcDHu+AGjm/ea9KcavAHkVtd1Ys+hSWnr4zc=
MIME-Version: 1.0
In-Reply-To: <87ljp2v6vt.fsf@tac.ki.iif.hu>
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Tue, 12 May 2009 08:37:43 -0700
X-Google-Sender-Auth: ec4c982b364e7599
Message-ID: <2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
Subject: Re: mmap vs mtime in 2.6.26 and up
To: Ferenc Wagner <wferi@niif.hu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Christoph Hellwig, xfs list, Andrew Morton to cc:)

On Tue, May 12, 2009 at 5:32 AM, Ferenc Wagner <wferi@niif.hu> wrote:
> Hi,
>
> I've noticed that the last modification times of our RRD files got
> stuck after upgrading from 2.6.24 to 2.6.26 (Debian Etch -> Lenny; I
> also tested with 2.6.30-rc5, they are still stuck).  It has some
> literature, most notably kernel bug #2645, but that's closed long ago
> and the resulting patch http://lkml.org/lkml/2008/1/22/370 is present
> in my kernels.  Still, the test program (version 3 from the bug report)
> gives failures:
>
> $ ./mmap_test junk
> Modifying junk...
> Flushing data using sync()...
> Failure: time not changed.
> Not modifying junk...
> Flushing data using msync()...
> Success: time not changed.
> Not modifying junk...
> Flushing data using fsync()...
> Success: time not changed.
> Modifying junk...
> Flushing data using msync()...
> Failure: time not changed.
> Modifying junk...
> Flushing data using fsync()...
> Failure: time not changed.
>
> Is this as expected?  I reckon the bug wasn't solved fully, but it
> seems to be worse that that.


I don't think that's expected. Further, the test program (v3) from
that bugzilla http://bugzilla.kernel.org/show_bug.cgi?id=2645 works
for me under ext3, so perhaps this is an xfs-specific issue.


>
> I don't know if it's related or not, but another anomaly appeared
> after the upgrade: minutes-long remount times.  The machine always was
> under a fair load (10), but mount /usr -oremount,rw never took
> noticeable time.  The IO load pushes two other filesystems.  Now
> strace -tt shows:
>
> [...]
> 01:24:08.463813 stat64("/sbin/mount.xfs", 0xbfa40eb0) = -1 ENOENT (No such file or directory)
> 01:24:08.463904 mount("/dev/mapper/noc7-usr", "/usr", 0x894a2c8, MS_MGC_VAL|MS_NODEV|MS_REMOUNT, NULL) = 0
> 01:26:58.705387 readlink("/dev", 0xbfa3ef3b, 4096) = -1 EINVAL (Invalid argument)
> [...]
>
> After this, remount ro and rw again are quick for some time.
> (I couldn't test this part with 2.6.30-rc5, but again, this may be
> totally unrelated.)
>
> This bug is quite serious in our environment, as it thwarts the backup
> software.  The file system is xfs; rw,nosuid,nodev,nobarrier,noquota.
> --
> Regards,
> Feri.
