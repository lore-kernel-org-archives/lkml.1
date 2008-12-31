Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYLaJwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYLaJwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYLaJwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:52:35 -0500
Received: from vena.lwn.net ([206.168.112.25]:50519 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbYLaJwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:52:34 -0500
Date: Wed, 31 Dec 2008 02:52:20 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@lst.de>,
       Al@oss.sgi.com, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com, Viro <viro@ZenIV.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20081231025220.1e67236e@tpl>
In-Reply-To: <20081230144836.GA31439@lst.de>
References: <20081229041352.6bbdf57c@tpl>
	<20081229124151.GA29634@redhat.com>
	<20081229152732.GH496@one.firstfloor.org>
	<20081230055956.1747bd86@tpl>
	<20081230130439.GA28874@lst.de>
	<20081230133737.GM496@one.firstfloor.org>
	<20081230144836.GA31439@lst.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 15:48:37 +0100
Christoph Hellwig <hch@lst.de> wrote:

> That beeing said I took another look at the patch and it seems like
> most places are indeed just very quick flags setting / clearing
> with the only sleeping possible inside ->fasync.  So having a
> file_flags_lock spinlock, and another sleeping mutex protecting
> ->fasync might be another options.  
> 
> Jon, do you remember what we actually need to protect in -fasync?
> any reason not to take the locking inside the method?  Together with
> ->lock and the old ->ioctl it's pretty special in fops as none of  
> the others have any locking at all.

There's nothing special about fasync() itself.  The problem is that the
setting of the FASYNC flag and the associated call to fasync() need to
be atomic, lest the driver/filesystem and the VFS end up with differing
ideas about the setting of that flag.  In the absence of that
constraint, one could just use the normal bit operations on f_flags.

jon
