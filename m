Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZFXWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZFXWup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZFXWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:50:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43241 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbZFXWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:50:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 24 Jun 2009 15:45:11 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <200906241255.54709.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <200906241255.54709.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Rusty Russell wrote:

> On Tue, 23 Jun 2009 03:33:22 am Davide Libenzi wrote:
> > What you're doing there, is setting up a kernel-to-kernel (since
> > userspace only role is to create the eventfd) communication, using a file*
> > as accessory. That IMO is plain wrong.
> 
> The most sensible is that userspace can use these fds; an in-kernel variant is 
> possible too, but not primary IMHO.
> 
> It's nice that userspace create the fds; it can then use the same fd for 
> multiple event sources.
> 
> But I didn't see anything wrong with the way eventfd used to work: you have a 
> kvm ioctl to say "attach this eventfd to this guest notification" and that does 
> the eventfd_fget.  A detach ioctl does the fput (as does release of the kvm 
> fd).
> 
> If they close the eventfd and don't do the detach ioctl, it's their problem.

Some components would like to know if userspace dropped the fd, and take 
proper action accordingly (release resources, drop module instances, etc...).
The POLLHUP helps with that, but w/out decoupling file* memory from 
eventfd_ctx memory, it becomes pretty tricky (if feasible at all) to 
handle the event in a race-free way.
Once the file* is decoupled from the eventfd_ctx, it becomes saner to 
expose the internal kernel API via the eventfd_ctx.
Another thing that comes in my mind (that for some components might not 
matter) is considering the effect of userspace doing things like:

	for (;;) {
		fd = eventfd(...);
		ioctl(xfd, XXX_ADD, fd);
		close(fd);
	}

That might lead to unprivileged users drawing kernel memory w/out any 
userspace accountability, if not properly handled.



- Davide


