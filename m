Return-Path: <linux-kernel-owner+w=401wt.eu-S1761108AbYEWCHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108AbYEWCHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 22:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbYEWCHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 22:07:00 -0400
Received: from sous-sol.org ([216.99.217.87]:55961 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090AbYEWCG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 22:06:59 -0400
Date: Thu, 22 May 2008 19:06:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Bojan Smojver <bojan@rexursive.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morgan <morgan@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: capget() overflows buffers.
Message-ID: <20080523020638.GF30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <1211505622.20341.6.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211505622.20341.6.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bojan Smojver (bojan@rexursive.com) wrote:
> On Thu, 2008-05-22 at 13:53 -0700, Chris Wright wrote:
> 
> >     cap_user_header_t head = (cap_user_header_t) xcalloc(1, sizeof(cap_user_header_t));
> >     cap_user_data_t cap = (cap_user_data_t) xcalloc(1, sizeof(cap_user_data_t));
> 
> BTW, both of the above allocations have been fixed in Squid 2 & 3, as
> they were incorrect. Not sure how that worked before - probably by
> accident.

Heh, indeed ;-)

If you want to fix the problem you're having in squid you've got a few
choices:

1) switch to using the libcap interface, arguably the best sol'n since
you know longer have to directly care about the kernel interface.
only drawback is the additional library dependency.

2) force head->version to the older version, something like:

#ifdef  _LINUX_CAPABILITY_VERSION_1
  head->version = _LINUX_CAPABILITY_VERSION_1;
#else
  head->version = _LINUX_CAPABILITY_VERSION;
#endif

this has the drawback of always using the older 32bit caps, probably
fine here, since you're not using new caps.

3) try to allow for current 64bit caps

#define CAP_TO_INDEX(x)     ((x) >> 5)
#define CAP_TO_MASK(x)      (1 << ((x) & 31))
#define CAP_ADD(_data, _set, _cap)     _data[CAP_TO_INDEX(_cap)]._set |= CAP_TO_MASK(_cap)

    cap_user_data_t cap = (cap_user_data_t) xcalloc(_LINUX_CAPABILITY_U32S, sizeof(*cap));
    head->version = _LINUX_CAPABILITY_VERSION;

    CAP_ADD(cap, effective, CAP_NET_BIND_SERVICE);
    etc...

this has the drawback of not being guaranteed to work in the future on
newer kernels and needs ifdefs to work on older kernels, is complicated,
and not worth it.
