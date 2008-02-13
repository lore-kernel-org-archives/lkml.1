Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbYBMCWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbYBMCWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYBMCWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:22:07 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50000 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753429AbYBMCWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:22:06 -0500
Date: Tue, 12 Feb 2008 20:22:01 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-Id: <20080212202201.a534cef8.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<1202861432.4974.29.camel@localhost>
	<20080212183158.3ff4ccd5.pj@sgi.com>
	<Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
	<20080212193229.edbff05a.pj@sgi.com>
	<alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> The enum has already been removed, as I've said a few times.

Yup.  Sorry ... beating dead horses is too much fun.

> The 'flags' field would be wrong because you're ignoring that these flags 
> are both passed by the user to the kernel and by the kernel to the user as 
> part of the 'int *' parameter in either set_mempolicy() or mbind().

I disagree, though I risk being in a minority on this matter.

Yes, you're entirely correct that these new flag have to be passed to and
from user space via an existing integer parameter.  There is no plausible
way other than packing the new flags into that existing parameter to preserve
the kernel-user API.

However, once inside the kernel, how we store this flag in struct mempolicy,
and how we pass it about between kernel routines, is our choice.

We can leave it packed, and unpack and repack it each time we consider the
flag and mode bits, or we can store and pass it as separate flags.

I urge us to consider handling it as separate flags within the kernel
because it most clearly and explicitly represents what is going on logically.
There are two different kinds of flags here, the original mempolicy modes,
and these meta modes (MPOL_F_STATIC_NODES, being the first example) which
affect the nodemask intepretation.

Cramming both these into a single int is necessary across the kernel-user API,
but it's an obfuscation that is not needed, therefore better avoided, within
the kernel code.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
