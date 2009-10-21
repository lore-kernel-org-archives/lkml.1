Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZJUTLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZJUTLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZJUTLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:11:21 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34386 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZJUTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Xeu9V7nJ1WafOxjWnq6yUPvGkc6KpjwrRWqVgTGyohWy0P5ixe30v3hHFelBgwuhuS
         ShAx8Rpkgt0+fS5RP6krF71qtZmyXO+9mROSKo65BZKV8tIiGptOsea45TuE1M1GILTW
         fFQwdEwXLjx0Ob5epRV+ooHaWoP1uuyvW7IbM=
MIME-Version: 1.0
In-Reply-To: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
Date: Wed, 21 Oct 2009 20:11:24 +0100
Message-ID: <9b2b86520910211211o30fab495r3a43cc4de9d4e968@mail.gmail.com>
Subject: Re: request_module vs. modprobe blacklist (and security subsystem 
	implications)
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, randy.dunlap@oracle.com,
       rusty@rustcorp.com.au, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/09, Eric Paris <eparis@redhat.com> wrote:
> I recently added a new LSM hook into __request_module(),
> security_kernel_module_request().  This new hook checks if a process
> should have permission to trigger the loading of a kernel module.  The
> attack vector imagined was that some module (IPX for example) has a
> vulnerability.  An attack program (which doesn't have permission to load
> the IPX module directly) might be able to get the networking stack to
> try to autoload the module.  Once loaded the attack program could then
> use the larger surface area to exploit the kernel.
>
> We have found that many users disable the IPv6 module by setting their
> modprobe config to look like:
>
> blacklist ipv6
> install ipv6 /bin/true
>
> The problem is that a number of programs (sendmail, procmail, sshd, and
> more) have all been seen to do operations which tried to load the ipv6
> module.  These get into request_module(), hit the security hook, and are
> obviously denied since the security system doesn't see a need for those
> programs to be able to request a module be loaded.
>
> What I really want is a way for the kernel to know that a module has
> been disabled and to not even call the security hook.  My thought would
> be something like adding the ability to do
>
> echo "ipv6 -l" > /proc/sys/kernel/modules_disabled
>
> which would add "ipv6" to a list of strings.  This list of strings could
> be checked in request_module() and if the module was explicitly denied
> autoloading ability we wouldn't make the call out to userspace (or the
> security hook)
>
> echo "ipv6 +l" > /proc/sys/kernel/modules_disabled
>
> would reenable the ability of a module to be autoloaded.
>
> cat /proc/sys/kernel/modules_disabled
>
> would be a multiline output, first line would be the 0/1 state we know
> today, rest of the lines would be the list of modules being denied
> autoload.
>
> What do others think?  What's a better way to stop calling out to
> userspace looking for the ipv6 module when userspace knows it's
> disabled?
>
> -Eric

You don't explain why :-/.  All I can see is that you want to correct
the error code from "permission denied" to "not supported".  But
"permission denied" can often cover a variety of issues, no?

I don't see why a module blacklist implemented by extending
modules_disabled should return anything other than "permission
denied".  If you disable modules completely, don't you get "permission
denied"?

And what would be the difference between "permission denied, you do
not have the right to load IPX", and "ipv6 is not supported due to a
policy decision by the system administrator"?  I'd have thought
"permission denied" would suffice for either.

I'm sure I'm missing something important here :-).

Regards
Alan
