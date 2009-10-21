Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZJUI30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZJUI30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZJUI3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:29:25 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:57449 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZJUI3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=phdMGLdtjWCEE/p5opXtXl4DJYxUbjFGyTAskTptcI/XsFK9dBVQlzb+lH+gSChTO3
         LEoztUHBsVL7J0L61yv7zGdCpp1R2GjUyo9N0ie9Na8I5j0fCoX89brOPvgfu4A/hdqL
         QSUpIc2i6ZMmhWV2FzjuF1elThcwYVImv4ghU=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Date: Wed, 21 Oct 2009 10:29:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mattia Dongili <malattia@linux.it>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <200910200008.57468.arnd@arndb.de> <alpine.LFD.2.00.0910210157170.8674@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910210157170.8674@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910211029.21702.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 October 2009, John Kacur wrote:
> From 11e6a3b690413c3926e6db1c53a53410b5214c3d Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 21 Oct 2009 01:51:41 +0200
> Subject: [PATCH] sonypi: Use non-BKL version of llseek.
> 
> The default version of llseek uses the BKL.
> We have removed the use of the BKL in open and the ioctl.
> Now lets remove the last use of the BKL by explictly calling the
> generic unlocked llseek, under the sonypi_device.lock mutex
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Well, for this specific case, the driver does not actually need to seek,
because the read function never looks at the position and there is no
write function. For annotation purposes, IMHO we should have a simple
'.llseek = no_llseek' in there.

In other files, the best solution may be to just point to generic_file_llseek
and make sure we hold the i_mutex when accessing the file->f_pos explicitly.

Interestingly, atomicity of updates to f_pos is currently maintained through
file_pos_write(), which does not hold any lock but assumes that a store to
an loff_t is atomic. It is not atomic in general, so concurrent lseek and
read/write operations seem to have undefined behaviour no matter what kind
of locking we have in the llseek function.

	Arnd <><
