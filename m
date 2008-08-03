Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYHCM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYHCM1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYHCM1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:27:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57002 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753955AbYHCM1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:27:10 -0400
Date: Sun, 3 Aug 2008 13:04:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sukadev@us.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com, matthltc@us.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, sukadev@us.ibm.com
Subject: Re: Per-instance devpts
Message-ID: <20080803130439.743ff0ae@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803050800.GA4322@us.ibm.com>
References: <20080412172933.GA19295@us.ibm.com>
	<1208027215.28187.17.camel@x61.ebiederm.org>
	<48935205.3090807@zytor.com>
	<20080803050800.GA4322@us.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1. /dev/ptmx would have to change to a symlink, ptmx -> pts/ptmx.
> 
> IIRC, /dev/tty also needs a similar symlink.

Making them symlinks is asking for trouble because some code does go
around using stat and the like and tools like MAKEDEV have definite ideas.

For /dev/tty the definition is precisely that it is your controlling
tty. No reference to namespace and a task whose controlling tty is in a
different namespace should still open the controlling tty not some
parallel in another universe when you open /dev/tty.

If you want to make sure the controlling tty is in the right namespace
that can be done in userspace when transferring control into a namespace.
In many cases I doubt that is even what is wanted.

> > 2. Permissions on /dev/ptmx would not be persistent, and would have to
> >    be set via devpts mount options (unless they're 0666 root.tty, which
> >    would presumably be the default.)
> > 3. The /proc/sys/kernel/pty limit would be global; a per-filesystem
> >    limit could be added on top or instead (presumably via a filesystem
> >    mount options.)
> >
> > I worry #1 would have substantial user-space impact, but I don't see a way 
> > around it, since there would be no obvious way to associate /dev/ptmx with 
> > a filesystem.

/dev/tty and /dev/ptmx already primarily operate by identifying a device
and switching the work to that. Actually putting a bit of namespace logic
in the driver code so the actual files stay as expected (device nodes
etc) seems a *lot* simpler than trying to do symlink hacks.

Alan
