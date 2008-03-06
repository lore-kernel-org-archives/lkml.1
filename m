Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbYCFJSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbYCFJSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbYCFJR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:17:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbYCFJRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:17:55 -0500
Date: Thu, 6 Mar 2008 04:17:09 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080306091708.GE24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF44E7.3020106@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 05:12:07PM -0800, H. Peter Anvin wrote:
> It's a kernel bug, and it needs to be fixed.  The discussion is about 
> what to do in the meantime.

While it is known that 32-bit glibc memmove and also <string.h> inlines
for memmove and memrchr use std; some string op; cld;, 64-bit glibc doesn't
ever use std instruction.  gcc itself never generates std instruction.

So, I've disassebled the whole Fedora/x86_64 distro (64-bit binaries/shared
libraries/archives/object files, unpacked over 12000 rpms) to see how common
is std insn in 64-bit code.  The only positive hits were the kernel
(/boot/xen-syms-2.6.21.7-2897.fc9 in particular, whatever that is) and
libpolyml.so.1.0.0 (polyml-libs - this one has handwritten assembly in
NASM), though I had to skim through some false positives (0xfd byte
appearing in data within code sections, but it is easy to see if 0xfd
is surrounded by invalid or nonsensical instructions that it is actually
data).  The conclusion is that DF=1 in x86_64 64-bit code is extremely rare.

Therefore, if we decide to apply a workaround for the kernel bug in gcc
(I'm not convinced we should), it should be IMNSHO limited to 32-bit code.

	Jakub
