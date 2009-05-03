Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZECTCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZECTCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZECTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:01:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44579 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbZECTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:01:39 -0400
Date: Sun, 3 May 2009 20:01:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090503190136.GY8633@ZenIV.linux.org.uk>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090503064432.GS8633@ZenIV.linux.org.uk> <alpine.DEB.1.10.0905031103290.7899@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905031103290.7899@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:07:26AM -0700, Davide Libenzi wrote:
> On Sun, 3 May 2009, Al Viro wrote:
> > On Mon, Apr 27, 2009 at 02:33:34PM -0400, Gregory Haskins wrote:
> > > +	/* We re-use eventfd for irqfd */
> > > +	fd = sys_eventfd2(0, 0);
> > > +	if (fd < 0) {
> > > +		ret = fd;
> > > +		goto fail;
> > > +	}
> > > +
> > > +	/* We maintain a reference to eventfd for the irqfd lifetime */
> > > +	file = eventfd_fget(fd);
> > > +	if (IS_ERR(file)) {
> > > +		ret = PTR_ERR(file);
> > > +		goto fail;
> > > +	}
> > > +
> > > +	irqfd->file = file;
> > 
> > This is just plain wrong.  You have no promise whatsoever that caller of
> > that sucker won't race with e.g. dup2().  IOW, you can't assume that
> > file will be of the expected kind.
> 
> The eventfd_fget() checks for the file_operations pointer, before 
> returning the file*, and fails if the fd in not an eventfd. Or you have 
> other concerns?

OK, but... it's still wrong.  Descriptor numbers are purely for interaction
with userland; using them that way violates very general race-prevention
rules, even if you do paper over the worst of consequences with check in
eventfd_fget().

General rules:
	* descriptor you've generated is fit only for return to userland;
	* descriptor you've got from userland is fit only for *single*
fget() or equivalent, unless you are one of the core syscalls manipulating
the descriptor table itself (dup2, etc.)
	* once file is installed in descriptor table, you'd better be past
the last failure exit; sys_close() on cleanup path is not acceptable.
That's what reserving descriptors is for.

IOW, the sane solution would be to export something that returns your
struct file *.  And stop playing with fd completely.
