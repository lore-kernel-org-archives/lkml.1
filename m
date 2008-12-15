Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYLOQD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYLOQD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYLOQDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:03:45 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:36697 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752437AbYLOQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:03:44 -0500
Date: Mon, 15 Dec 2008 16:03:11 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Message-ID: <20081215160311.GA23153@linux-mips.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 12:36:14PM +0100, Gerd Hoffmann wrote:

> Next revision of the patch series, with the alignment issue fixed by
> swapping the last two arguments as suggested by arch maintainers.
> 
> I've dropped the now-obsolete wrappers for mips.  Ralf, please
> double-check.

It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
will pass the 64-bit argument in two registers but the 64-bit kernel code
will assume it to be passed in a single registers.  It'd be ugly but passing
a pointer to a 64-bit argument would solve the issue; something like this:

sys_preadv(unsigned long fd, const struct iovec __user *vec,
                  unsigned long vlen, loff_t __user *pos);
compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
                  unsigned long vlen, loff_t __user *pos);

sys_splice uses loff_t __user * arguments as well and that's why it's
doesn't need any compat wrapper.

I'm surprised this works for x86; does x86-64 code really expect 64-bit
arguments as 2 32-bit arguments?

Patch 1/3 looks like it's a bug fix and you may want to submit this
separate from the remainder of the series for 2.6.28?

  Ralf
