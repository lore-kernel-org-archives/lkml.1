Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYDAKz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYDAKz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYDAKzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:55:14 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:59969 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbYDAKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:55:12 -0400
Message-Id: <2530BB4B166747659C8F65C9C3DE7CFB@nsl.ad.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "David Chinner" <dgc@sgi.com>
Cc: "David Chinner" <dgc@sgi.com>, <linux-ext4@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <xfs@oss.sgi.com>,
       <dm-devel@redhat.com>, <linux-kernel@vger.kernel.org>
References: <20080328180736t-sato@mail.jp.nec.com> <20080331000057.GI108924158@sgi.com>
In-Reply-To: <20080331000057.GI108924158@sgi.com>
Subject: Re: [RFC PATCH 2/2] Add timeout feature
Date: Tue, 1 Apr 2008 19:54:42 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6000.16480
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6000.16545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Chinner wrote:
> The timeout is not for the freeze operation - the timeout is
> only set up once the freeze is complete. i.e:
>
> $ time sudo ~/test_src/xfs_io -f -x -c 'gfreeze 10' /mnt/scratch/test
> freezing with level = 10
>
> real    0m23.204s
> user    0m0.008s
> sys     0m0.012s
>
> The freeze takes 23s, and then the 10s timeout is started. So
> this timeout does not protect against freeze_bdev() hangs at all.
> All it does is introduce silent unfreezing of the block device that
> can not be synchronised with the application that is operating
> on the frozen device.

Exactly my timeout feature is only for an application, not for freeze_bdev().
I think it is needed for the situation we can't unfreeze from userspace.
(e.g. Freezing the root filesystem)

> FWIW, resetting this timeout from userspace is unreliable - there's
> no guarantee that under load your userspace process will get to run
> again inside the timeout to reset it, hence leaving you with a
> unfrozen filesystem when you really want it frozen...

The timeout period specified to the reset ioctl should be much larger than
the interval for calling the reset ioctl repeatedly.
(e.g timeout period = 2 minutes, calling interval = 5 seconds)
The reset ioctl will work under such setting.
If a timeout still occurs before a reset, it would imply that an unexpected
problem (e.g. deadlock) occur in an application.

Cheers, Takashi 
