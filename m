Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZKBPwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZKBPwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZKBPwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:52:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZKBPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:52:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd
Date: Mon, 2 Nov 2009 16:51:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jonathan Corbet <corbet@lwn.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>
References: <20091010153314.827301943@linutronix.de> <alpine.LFD.2.00.0910212350210.3526@localhost.localdomain> <20091021221619.GF4880@nowhere>
In-Reply-To: <20091021221619.GF4880@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021651.53331.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/KnmIKYLrknQ9e9LEzbQvcWKpk5Ft7qh2KWMS
 kuj1ZDwWspkdRc0I0Xn8/v/EFri3TvdalfieZOcBrDacWq5hrM
 +OlIfqGGePFLEGwoQRJDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 October 2009, Frederic Weisbecker wrote:
> > I'm thinking that the simplier approach, would be to make the 
> > default_llseek the unlocked one. Then you only have to audit the drivers 
> > that have the BKL - ie the ones we are auditing anyway, and explicitly set 
> > them to the bkl locked llseek.
> > 
> > There might be a hidden interaction though between the non-unlocked 
> > variety of ioctls and default llseek though.
> 
> 
> I fear that won't work because the bkl in default_llseek() does not
> only synchronizes with others uses of the bkl in a driver, it also
> synchronizes lseek() itself.
> 
> As an example offset change is not atomic. This is a long long, so
> updating its value is not atomic in 32 bits archs.

A late follow-up on this one:

I looked at what places in the code manipulate file->f_pos directly
and found that almost all the uses in driver code are broken because
they don't take any locks. Most of them are in driver specific
lseek operations. Others are in read/write methods and are even
more broken because the change gets immediately overwritten by
vfs_read/vfs_write when the driver method returns.

IMHO, we should complete the pushdown into all ioctl methods
that John and Thomas have started working on, fixing the lseek
methods in those files we touch.

When that is done, all interaction between default_llseek and
driver locking has to be with explicit calls to lock_kernel
in those drivers, so we can reasonably well script the search
for drivers needing the BKL in llseek: everyhing that
 a) defines file_operations without an llseek function,
 b) touches f_pos somewhere, and
 c) calls lock_kernel() somewhere
That should only be a small number and when they are fixed,
we can remove default_llseek and instead call generic_file_llseek
for any file operation without a separate llseek method.

	Arnd <><
