Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbZBYPyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbZBYPyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbZBYPxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:53:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:59401 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZBYPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:53:51 -0500
Date: Wed, 25 Feb 2009 08:53:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Justin Chen <jchen@hpdst41.cup.hp.com>, linux-arch@vger.kernel.org,
       bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] bitops: Change bitmap index from int to unsigned long
Message-ID: <20090225155347.GR16891@parisc-linux.org>
References: <200902250441.UAA12527@hpdst41.cup.hp.com> <1235544888.4645.2942.camel@laptop> <20090225153757.GP16891@parisc-linux.org> <1235576760.4645.3535.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235576760.4645.3535.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 04:46:00PM +0100, Peter Zijlstra wrote:
> > Adding one more bit only doubles the maximum size.  That buys us, what,
> > another eighteen months until we have to change it again?  Unsigned long
> > seems most sensible to me.  Unsigned long long probably isn't worth
> > doing -- you'd have to be using one eighth of your address space on a
> > single bitmap.
> 
> Are you serious? Bitmaps of length 4G-bit (512M-byte) are way past the
> sanely allocatable size anyway.

Runtime allocatable, yes.  This particular instance was during boot.
Justin wrote:

> If the caller passes a large unsigned integer and we interpret it as
> being negative, we compute an address outside the bitmap.  This can
> cause memory corruption or other errors.

> The issue that triggered me to do this change is the routine
> mark_bootmem_node() while we ran on an ia64 box with large memory.
> As long as the EFI maps the available memory chunk at the physical
> address 0x200000000000 (or above), the routine mark_bootmem_node() will
> get the start PFN>=0x80000000.  While it calls the __free() with this
> sidx=0x80000000 (bit31 set), the bitops (test_and_clear_bit) will treat
> this idx as a negative number since it accepts it as an "int".  It turns
> out the memory outside the bitmap will be corrupted.

If we've got problems with overflowing 'int' on memory size, we'll be
overflowing 'unsigned int' in eighteen months.  0x200000000000 is large,
but we can easily add on an extra four nybbles.

I don't see the downside to using unsigned long instead of unsigned int.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
