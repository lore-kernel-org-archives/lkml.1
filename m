Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZH3SYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZH3SYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 14:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZH3SYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 14:24:34 -0400
Received: from thunk.org ([69.25.196.29]:34613 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZH3SYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 14:24:34 -0400
Date: Sun, 30 Aug 2009 14:24:24 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: memleaks, acpi + ext4 + tty
Message-ID: <20090830182424.GB20822@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> <tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <20090830163417.GA15183@skywalker.linux.vnet.ibm.com> <20090830171749.GA8642@mit.edu> <43e72e890908301029t71a9c1a2t3d17e99cf3112ad2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e72e890908301029t71a9c1a2t3d17e99cf3112ad2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 10:29:01AM -0700, Luis R. Rodriguez wrote:
> > Yes, as soon as the next merge window opens.  The leak only shows up
> > when you mount and unmount a filesystem, which under normal
> > circumstances doesn't happen a huge number of times on most systems.
> > By the time it showed up it was late enough in the 2.6.31-rcX series
> > that I figured it was better to wait until the next merge window.  I
> > didn't consider it a high priority bug.
> 
> That's odd I run into this kmemleak with a single bootup, no manual remounts.
> 

Yeah, but it's a singleton leak.  Let me be a bit more precise this
time: the leak happens at mount time because we're essentially doing
this due to some code that was accidentally duplicated when it was
being refactored:

	a = kmalloc(sizeof(...)*N, GFP_ATOMIC);
	  ...
	a = kmalloc(sizeof(...)*N, GFP_ATOMIC);

So a small amount of memory is leaked each time a filesystem is
mounted.  It doesn't become a huge problem unless you are repeatedly
mounting and unmounting the same filesystem in a tight loop.

	     		    	 	       	 - Ted
