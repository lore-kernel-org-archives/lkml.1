Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZABQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZABQp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZABQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:45:16 -0500
Received: from mail.fieldses.org ([141.211.133.115]:39531 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZABQpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:45:15 -0500
Date: Fri, 2 Jan 2009 11:45:05 -0500
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #2]
Message-ID: <20090102164505.GA10465@fieldses.org>
References: <20090102051905.GC1073@fieldses.org> <20090101235332.GA31840@fieldses.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <29449.1230859152@redhat.com> <32481.1230897578@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32481.1230897578@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 11:59:38AM +0000, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > No.  I started bisecting, and it does appear to be a regression from the
> > cred patches, but at some point in the middle there it hangs on boot (a
> > softlockup report blames a spinlock in set_groups).
> 
> Do you remember which patch you were at?

It appears that:

	- 1cdcbec1a3372c0c49c59d292e708fd07b509f18 "CRED: Neuter
	  sys_capset()" is good

	- 98870ab0a5a3f1822aee681d2997017e1c87d026 "CRED: Documentation"
	  is bad

	- f1752eec6145c97163dbce62d17cf5d928e28a27 and
	  d84f4f992cbd76e8f39c488cf0c5d123843923b1 produce the soft
	  lookup in set_groups()

... and I haven't figured out what's in between.  And the test failure
is nfsd_lookup() returning OK on a directory when it should return
nfserr_perm.  I assume that's the result of inode_permission(directory
inode, MAY_EXEC) returning 0 when it shouldn't, but I haven't confirmed
that.

--b.
