Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbXCWAmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbXCWAmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934219AbXCWAmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:42:15 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:37574 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934215AbXCWAmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PDKujzjvQYbHaGwMf/MMj6IuHnzZLkQOuWgfFrXJfMvSsMYJ7ycuSTQywM/X9Xm3cDXU7a4LP+R9dqlAV50ec94pwoGLd3NVj0bdVUyqWNv4OtrNAv54D9lSTA9zybxkBcGDUyBGT6jdM3xICS1FQSxEBbXlT0PpM8mAPODuJWE=
Message-ID: <2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
Date: Fri, 23 Mar 2007 02:42:12 +0200
From: "Marti Raudsepp" <marti@juffo.org>
To: "Alasdair G Kergon" <agk@redhat.com>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: [dm-devel] Fw: BUG: Files corrupt after moving LVM volume to USB disk
Cc: "device-mapper development" <dm-devel@redhat.com>,
       "Kernel hackers" <linux-kernel@vger.kernel.org>,
       "Milan Broz" <mbroz@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070322153301.GN27600@agk.surrey.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070322000348.92631512.akpm@linux-foundation.org>
	 <20070322153301.GN27600@agk.surrey.redhat.com>
X-Google-Sender-Auth: 72e937fd38975c2d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Summary of what I've managed to rule out so far:
1. this problem does not occur without dm-crypt
2. this problem does not occur when the file system hasn't been moved from
   the SATA disk to USB
3. Both reiserfs and ext3 are affected by this problem, but ext3
merely slows down.
4. Unmounting and re-mounting has no effect.

My initial report contains more details.

On 3/22/07, Alasdair G Kergon <agk@redhat.com> wrote:
> A couple of patches to try:
> dm-io-fix-bi_max_vecs.patch
> dm-merge-max_hw_sector.patch
>
> and perhaps these three:
> dm-crypt-fix-call-to-clone_init.patch
> dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
> dm-crypt-fix-remove-first_clone.patch

No luck. :(

And thanks for reminding me how annoying reboots are...

On 3/21/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> Does this happen only with this combination, or can you elliminate
> something as the cause?

Doesn't occur if dm-crypt is not involved (e.g., when placing reiserfs or
ext3 straight on top of /dev/primary/punchbag). I don't know if LVM is
necessary, as I don't have any unallocated space for "oldschool" partitions
left.

Nor do these problems occur when creating either file system directly on the
USB disk -- so, only when they have been lvmoved from the SATA disk, or when
the volume is physically dd'ed to the USB disk.

On 3/21/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> Does it happen with ext3 or only reiserfs?

Tried with ext3 (LVM+dm-crypt+ext3), and the files didn't appear corrupt,
however, I could still see those messages in my dmesg, and disk access was
*extremely* slow, causing around 10k context switches per second (!?) reading
below 5 MB/s. Normally, I can get read speeds around 12-22 MB/s with this
particular USB disk. However, it's not CPU-bound, as over >80% of CPU is still
spent in iowait.

When the ext3 file system is created directly on a volume that is located on
the USB disk, however, these problems do not occur, just like with reiserfs.

However, when I copied the same files to a reiserfs volume when the LV had
already been pvmoved to /dev/sdb, the files were readable (as pointed out in
my initial post). Interestingly, it did not introduce the same slowdown as
with ext3, reading around 13-14 MB/s with ~3k context switches per second.

To clarify (I double-checked all these scenarios):
(1) files written *before* pvmove are corrupt with reiserfs
(2) files written *after*  pvmove read fast with reiserfs
(3) files written *before* pvmove read slowly with ext3
(4) files written *after*  pvmove read slowly with ext3
(5) files written to an ext3 volume that was formatted on the USB disk and not
    pvmoved are fast and don't report these dmesg warnings.

This is purely my speculation, and I can't pretend to know much about the
inner workings of device-mapper/file systems, but it appears that ext3
statically derives some attributes during the creation of a file system,
while reiserfs gets them runtime. ext3 contains a slow workaround if these
attributes don't match (and still posts a warning), but reiserfs
returns outright I/O errors.

(P.S. does the LKML archive randomly omit some double-newlines in posts, or
is this a problem on my end?)

Marti Raudsepp
