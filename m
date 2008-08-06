Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYHFPXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYHFPXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbYHFPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:23:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48685 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498AbYHFPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:23:07 -0400
Date: Wed, 6 Aug 2008 11:22:36 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: tvrtko.ursulin@sophos.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Rik van Riel <riel@redhat.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080806152236.GE14109@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, tvrtko.ursulin@sophos.com,
	Arjan van de Ven <arjan@infradead.org>,
	"Press, Jonathan" <Jonathan.Press@ca.com>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	malware-list@lists.printk.net, Rik van Riel <riel@redhat.com>
References: <20080806064418.6afa0672@infradead.org> <20080806141656.8B44B2FE94A@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806141656.8B44B2FE94A@pmx1.sophos.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 03:16:02PM +0100, tvrtko.ursulin@sophos.com wrote:
> 
> You can't do something like inotify("/") (made up API) but you have to set 
> up a watch for every directory you wan't to watch. That seems like a waste 
> of resources.
> 
> Then you get back a file name, if you wan't to report it or attempt* to 
> scan it you have to build a pathname yourself, which means you have to 
> maintain the whole tree of names in memory. Even bigger waste.

Yes, it would be nice if inotify gave you back a full pathname and
where a single watch would return all changes anywhere in the
filesystem tree.  I'd recommend that folks try to create such a patch.

> When I say attempt to scan it above I mean that we are back into the 
> pathanme teritorry. It is not guaranteed we will be able to open and scan 
> using that pathname. I don't know what inotify reports with chroots and 
> private namespaces, but it can certainly fail with NFS and root_squash. So 
> it is less effective as well as being resource intensive.

Linux's namespace support does break a lot of traditional paradigm.
I'll note the TALPA "requirements" are broken themselves since they
refer to pathnames.

Furthermore, I assume you'll always want to do the scanning in
userspace; the virus signature files for Windows are ***huge***.  And
if you are going to be scanning for Windows virii on the argument that
you want to stop malware on fileservers, I don't think you want to put
all of that code into the kernel.  (I'll note that all that code
complexity leads to bugs, which will in kernel code cause system
crashes.  One company's Linux AV code --- I won't say which --- almost
lead to a rather big and public customer abandoning an Linux
deployment because said proprietary, badly/disastrously written,
kernel code was leaking a small amount of memory on every file open,
and no one could figure out why their file server was crashing every
five days or so.  I was called in to rescue said customer before they
cancelled the contract in disgust, and I traced it back to a
proprietary AV kernel module.  What fun...)

So if we are going to have to deal with namespaces, I suspect the best
we can do for any interface (whether it is inotify based or not) is to
have it return pathnames that are valid in the namespace that the
program calling said interface happens to be running in.  If necessary
the AV program can be given access to a highly privileged namespace
where all mounts are visible.  And if you want to restrict namespaces
from being created at all, that's a security policy decision that
should be made via the LSM hooks.

As far as blocking opens are concerned, my suggestion there would be
changes would probably be much more likely accepted if they solved
more problems than just what the AV folks need.  For example, think
about hierarchical storage management, and DMAPI.  DMAPI is a total
disaster because it doesn't know about namespaces and so is completely
pathname based (which doesn't work well when you have namespaces).
But a solution which is general enough that it can also be used to
support HSM would probably be a good thing.

Also, it may very well be that instead of one, purpose-specific
interface such as what you suggested in TALPA, it might be much better
if it was a series of different interfaces; and in some cases, some of
the changes might be extensions and improvments to existing
facilities, such inotify.

Regards,

						- Ted
