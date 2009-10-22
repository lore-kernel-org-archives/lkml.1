Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZJVObM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZJVObM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZJVObM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZJVObL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:31:11 -0400
Subject: Re: request_module vs. modprobe blacklist (and security subsystem
 implications)
From: Eric Paris <eparis@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       randy.dunlap@oracle.com, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
In-Reply-To: <200910221626.51170.rusty@rustcorp.com.au>
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
	 <9b2b86520910211211o30fab495r3a43cc4de9d4e968@mail.gmail.com>
	 <1256153248.4443.49.camel@dhcp231-106.rdu.redhat.com>
	 <200910221626.51170.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Oct 2009 10:30:22 -0400
Message-Id: <1256221822.4443.95.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 16:26 +1030, Rusty Russell wrote:

I should start by making sure people are certainly they know what I'm
talking about (which I think thus far everyone does.)  I am NOT talking
about a program which either calls modprobe directly or tries to
directly load a module.  I'm talking about a program which does an
operation (say, try to create and IPv6 or IPX socket) which causes the
kernel to automatically launch modprobe in userspace to load that
module.  Often times this is not a malicious action.

> On Thu, 22 Oct 2009 05:57:28 am Eric Paris wrote:
> > Ah yes, not your fault though  :)  The problem is that SELinux reports
> > these denials and users get scared.  We can (and now do) silence all of
> > these SELinux caused denials, but now we have no notification if a
> > malicious program tried to cause the auto loading of a module.
> 
> Well, yes.  I think you need to be more careful in your filtering.

More careful filtering is somewhat possible.  I can't stop the kernel
from reporting that SELinux blocked the kernel from autoloading a new
module, but I can send the module name with the denial message to
userspace and then have the desktop alert box stop showing denials which
modprobe config disabled, but it would be very brittle.  

> If a userspace program tries some security exploit that has been closed, do
> you want to warn about it?  Because that seems to be the question here.

I say yes.  Knowing that malicious activity is taking place, even if it
didn't hurt anything is useful.  I'd rather know that a script kiddie is
trying to attack me so I can deal with him rather than not realize until
after he is successful.  But that's not quite the case here.  If the
administrator explicitly disables a module (ok, IPv6 is the only
interesting one) the kernel still regularly upcalls to modprobe which
then does nothing.  Wouldn't having a mechanism to stop the upcall and
delays be a good thing even without my SELinux complaint?

> Why should ssh not load IPv6?  Because noone should?  Fine, but there's a
> difference between "I expect it to do this but I won't let it" and "I don't
> expect it to do this".

In this case it's because the admin decided not to allow it.  In this
case it is 'I expect it to do this, and I know that later it would fail,
so I don't want to complain that it is failing now.'  I want a way to
move the failure up, and to allow and admin to stop with the useless
userspace callouts to modprobe.

I want a way to make the kernel not upcall at all, if I have that I can
make SELinux do whatever I want.  If I don't have that, all I can do is
some post failure fragile userspace filtering.

