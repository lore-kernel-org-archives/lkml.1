Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZJUT1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZJUT1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZJUT1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:27:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbZJUT1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:27:45 -0400
Subject: Re: request_module vs. modprobe blacklist (and security subsystem 
 implications)
From: Eric Paris <eparis@redhat.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, randy.dunlap@oracle.com,
       rusty@rustcorp.com.au, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
In-Reply-To: <9b2b86520910211211o30fab495r3a43cc4de9d4e968@mail.gmail.com>
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
	 <9b2b86520910211211o30fab495r3a43cc4de9d4e968@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Oct 2009 15:27:28 -0400
Message-Id: <1256153248.4443.49.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 20:11 +0100, Alan Jenkins wrote:
> On 10/21/09, Eric Paris <eparis@redhat.com> wrote:
> > I recently added a new LSM hook into __request_module(),
> > security_kernel_module_request().  This new hook checks if a process
> > should have permission to trigger the loading of a kernel module.  The
> > attack vector imagined was that some module (IPX for example) has a
> > vulnerability.  An attack program (which doesn't have permission to load
> > the IPX module directly) might be able to get the networking stack to
> > try to autoload the module.  Once loaded the attack program could then
> > use the larger surface area to exploit the kernel.
> >
> > We have found that many users disable the IPv6 module by setting their
> > modprobe config to look like:
> >
> > blacklist ipv6
> > install ipv6 /bin/true
> >
> > The problem is that a number of programs (sendmail, procmail, sshd, and
> > more) have all been seen to do operations which tried to load the ipv6
> > module.  These get into request_module(), hit the security hook, and are
> > obviously denied since the security system doesn't see a need for those
> > programs to be able to request a module be loaded.
> >
> > What I really want is a way for the kernel to know that a module has
> > been disabled and to not even call the security hook.  My thought would
> > be something like adding the ability to do
> >
> > echo "ipv6 -l" > /proc/sys/kernel/modules_disabled
> >
> > which would add "ipv6" to a list of strings.  This list of strings could
> > be checked in request_module() and if the module was explicitly denied
> > autoloading ability we wouldn't make the call out to userspace (or the
> > security hook)
> >
> > echo "ipv6 +l" > /proc/sys/kernel/modules_disabled
> >
> > would reenable the ability of a module to be autoloaded.
> >
> > cat /proc/sys/kernel/modules_disabled
> >
> > would be a multiline output, first line would be the 0/1 state we know
> > today, rest of the lines would be the list of modules being denied
> > autoload.
> >
> > What do others think?  What's a better way to stop calling out to
> > userspace looking for the ipv6 module when userspace knows it's
> > disabled?
> >
> > -Eric
> 
> You don't explain why :-/.  All I can see is that you want to correct
> the error code from "permission denied" to "not supported".  But
> "permission denied" can often cover a variety of issues, no?
> 
> I don't see why a module blacklist implemented by extending
> modules_disabled should return anything other than "permission
> denied".  If you disable modules completely, don't you get "permission
> denied"?
> 
> And what would be the difference between "permission denied, you do
> not have the right to load IPX", and "ipv6 is not supported due to a
> policy decision by the system administrator"?  I'd have thought
> "permission denied" would suffice for either.
> 
> I'm sure I'm missing something important here :-)

Ah yes, not your fault though  :)  The problem is that SELinux reports
these denials and users get scared.  We can (and now do) silence all of
these SELinux caused denials, but now we have no notification if a
malicious program tried to cause the auto loading of a module.  What we
want is a way to inform users when their system is doing bad things,
like trying to load the IPX module, but not to cause these notifications
when SELinux is denying something that would have been effectively
"denied" by modprobe later when it called /bin/true instead of loading
the IPv6 module.

Basically I don't want to log a denial and put up a warning in front of
a user when the system administrator explicitly told modprobe to fail on
those.

Make a little more sense?  I honestly don't care what the retval is, I
just care that I'm able to put up an SELinux message saying we stopped
something bad while not putting up lots of false positives...

