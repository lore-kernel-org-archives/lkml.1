Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYJ1OZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYJ1OZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYJ1OZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:25:05 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58401 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbYJ1OZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:25:03 -0400
Date: Tue, 28 Oct 2008 10:24:58 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned
	htree hash algorithms
Message-ID: <20081028142458.GC8869@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	tony.luck@intel.com
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu> <20081022172221.c1a8c5b5.akpm@linux-foundation.org> <20081023025646.GD10369@mit.edu> <20081023192618.GS3184@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023192618.GS3184@webber.adilger.int>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added Tony Luck to the CC list since as the Itanium maintainer,
he's most likely to be able to speak to both cross compilation issues
especially as it relates to the Intel Compiler....

Tony, Andrew has requested I clean up this compile-time test to
determine whether variables of type char are signed or unsigned:

	char c;
	...
	c = (char) 255;
	if (((int) c) == -1) {
		...
	}

... since it results in this annoying gcc warning:

> fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type

Two possible solutions which come to mind is to use the C preprocessor
macros CHAR_MIN/CHAR_MAX as defined in limits.h, or to use
__CHAR_UNSIGNED__ which is defined by gcc on platforms where char's
are unsigned (or if the gcc option --funsigned-char is given).  

I believe at this point, it's settled that either of the above
solutions should do the right thing for gcc, either in
cross-compilation environments, or natively.  (I prefer
__CHAR_UNSIGNED__ since it doesn't depend on the userspace header
files, which might be screwy on some distributions, and depending on a
macro set by gcc seems much more robust in cross-compilation
environments.)

The question is whether this solution is likely to work on the Intel C
compiler.  My understanding is that a kernel compiled with gcc is
pathetically slow on the Itanic (not to mention taking aeons to
compile), and so there has always been a desire to make sure that the
Linux Kernel will compile on the Intel C compiler, at least for the
Intanium platform.  Do you know if icc will do the right thing as far
as defining __CHAR_UNSIGNED__ if necessary?  

I don't even know if the Itanium is one of those wierd-sh*t platforms
that tried to make char's unsigned, one of those really horrific
design decisions perpetrated by the Arm and PowerPC platforms since it
tends to break compatibility with K&R C which doesn't even have a
signed keyword (and for which char's were always signed).  If it's one
of the sane platforms, then this might not matter so much.

Thanks,

							- Ted
