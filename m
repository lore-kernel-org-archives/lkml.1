Return-Path: <linux-kernel-owner+w=401wt.eu-S1030433AbXCCVlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433AbXCCVlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030429AbXCCVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:41:11 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:59073 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXCCVlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:41:10 -0500
Date: Sat, 3 Mar 2007 22:41:09 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-ID: <20070303214108.GA28961@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070303122935.f1ab0067.akpm@linux-foundation.org> <45E9DD4A.2060806@redhat.com> <20070303131204.6706a95c.akpm@linux-foundation.org> <45E9E910.2070804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E9E910.2070804@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 04:30:56PM -0500, Rik van Riel wrote:

> The user has been accessing the kernel tree over and over
> again, for hours on end (compile testing a patch).  Along
> comes a backup program, that tells you to evict the whole
> thing from the cache.

This is arguably due to a linux misimplementation of posix_fadvise. SuS v3
clearly states:

  The posix_fadvise() function shall advise the implementation on the
  expected behavior of the application with respect to the data in the file
  associated with the open file descriptor

Note how it refers to the *application*. This is reiterated here:

  POSIX_FADV_WILLNEED 
    Specifies that the application expects to access the specified data in
    the near future.

  POSIX_FADV_DONTNEED
    Specifies that the application expects that it will not access the
    specified data in the near future.

  POSIX_FADV_NOREUSE
    Specifies that the application expects to access the specified data once
    and then not reuse it thereafter.

Linux however implements posix_fadvise globally:

  POSIX_FADV_DONTNEED 
    attempts to free cached pages associated with the specified region.

  POSIX_FADV_WILLNEED and POSIX_FADV_NOREUSE 
    both initiate a non-blocking read of the specified region into the page
    cache.

> How can you make global policy decisions based on the intent
> of one program?

By not doing so. Andrew's program is fine in principle, except that the
linux kernel treats the communication of a program's intent as a global
instruction.

Also, Andrew's description is a tad misleasing, as the size of the page
cache might be altered a lot in case content is accessed that was previously
cached!

With my userspace hat on, I'd love to have a proper way to communicate my
*program's* expectations to the kernel, without stomping other programs.

Also with the same hat on, I hope to rarely *need* to communicate my
expectations because the kernel correctly predicts many cases.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
