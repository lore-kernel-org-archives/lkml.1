Return-Path: <linux-kernel-owner+w=401wt.eu-S933042AbXGTWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbXGTWGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXGTWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:06:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbXGTWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:06:09 -0400
Message-ID: <46A131BF.4080404@zytor.com>
Date: Fri, 20 Jul 2007 15:05:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: linux-kernel@vger.kernel.org, honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de>
In-Reply-To: <20070720211300.GA21644@deine-taler.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Kunitz wrote:
> Since this week new linux-2.6/master kernels don't work with my
> initial ram disks. The sleep binary runs repeatingly into
> segmentation faults until the Busybox shell starts. My system is a
> x86-64 with Kubuntu Feisty Fawn.
> 
> By bisecting I found out that the PIE randomization patch (commit 60bfba7e)
> appears to cause the segmentation faults.
> 
> Digging further into the issue I found out, that the sleep binary
> on the initial ramdisk is a klibc binary. /usr/bin/file says it is
> statically linked and uses shared libraries. I have no clue about
> klibc, but the binaries seem to be statically linked, but load a
> shared library; probably at a fixed address. Other klibc binaries are also
> running into segmentation faults. Busybox is working, but it is
> statically linked and doesn't use a shared library.
> 
> It looks like that the PIE randomization patch breaks klibc
> binaries on x86-64.
> 

Interesting.

klibc binaries are indeed statically linked, but composed of two
different ELF images: the application itself and the shared libary
(which is referenced from the application header as the "interpreter").
 Neither of these is an ET_DYN file; they are both ET_EXEC, so it
*should* be unaffected by the PIE randomization patch.  Obviously, that
seems to not be the case.

My guess is that this patch mishandles interpreter images which are
ET_EXEC.  Jan, any insight?

	-hpa
