Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZJUVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZJUVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZJUVAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:00:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50042 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZJUVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q5QHYqqfjU03jdiNc3R5ipojGPFssSr5A+hFpHzqP6xEQpkuxqGZkNfKr7x+kSURCF
         6qpjfX91JieAOvW40i7W9uUsZmDWlW/GZqLKLZ2M2XfuqD5P+HuiVSiztP3Y5Bs7kkD0
         /uvZCj1uA7HoyaV/UsDYPQAkl1oKZ/a+BzX+o=
MIME-Version: 1.0
In-Reply-To: <1256153248.4443.49.camel@dhcp231-106.rdu.redhat.com>
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com>
	 <9b2b86520910211211o30fab495r3a43cc4de9d4e968@mail.gmail.com>
	 <1256153248.4443.49.camel@dhcp231-106.rdu.redhat.com>
Date: Wed, 21 Oct 2009 22:00:17 +0100
Message-ID: <9b2b86520910211400gd8d8ed9r606c874eb4f063d3@mail.gmail.com>
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
> On Wed, 2009-10-21 at 20:11 +0100, Alan Jenkins wrote:
>> On 10/21/09, Eric Paris <eparis@redhat.com> wrote:
>> > I recently added a new LSM hook into __request_module(),
>> > security_kernel_module_request().  This new hook checks if a process
>> > should have permission to trigger the loading of a kernel module.  The
>> > attack vector imagined was that some module (IPX for example) has a
>> > vulnerability.  An attack program (which doesn't have permission to load
>> > the IPX module directly) might be able to get the networking stack to
>> > try to autoload the module.  Once loaded the attack program could then
>> > use the larger surface area to exploit the kernel.
>> >
>> > We have found that many users disable the IPv6 module by setting their
>> > modprobe config to look like:
>> >
>> > blacklist ipv6
>> > install ipv6 /bin/true
>> >
>> > The problem is that a number of programs (sendmail, procmail, sshd, and
>> > more) have all been seen to do operations which tried to load the ipv6
>> > module.  These get into request_module(), hit the security hook, and are
>> > obviously denied since the security system doesn't see a need for those
>> > programs to be able to request a module be loaded.
>> >
>> > What I really want is a way for the kernel to know that a module has
>> > been disabled and to not even call the security hook.  My thought would
>> > be something like adding the ability to do
>> >
>> > echo "ipv6 -l" > /proc/sys/kernel/modules_disabled
>> >
>> > which would add "ipv6" to a list of strings.  This list of strings could
>> > be checked in request_module() and if the module was explicitly denied
>> > autoloading ability we wouldn't make the call out to userspace (or the
>> > security hook)
>> >
>> > echo "ipv6 +l" > /proc/sys/kernel/modules_disabled
>> >
>> > would reenable the ability of a module to be autoloaded.
>> >
>> > cat /proc/sys/kernel/modules_disabled
>> >
>> > would be a multiline output, first line would be the 0/1 state we know
>> > today, rest of the lines would be the list of modules being denied
>> > autoload.
>> >
>> > What do others think?  What's a better way to stop calling out to
>> > userspace looking for the ipv6 module when userspace knows it's
>> > disabled?
>> >
>> > -Eric
>>
>> You don't explain why :-/.  All I can see is that you want to correct
>> the error code from "permission denied" to "not supported".  But
>> "permission denied" can often cover a variety of issues, no?
>>
>> I don't see why a module blacklist implemented by extending
>> modules_disabled should return anything other than "permission
>> denied".  If you disable modules completely, don't you get "permission
>> denied"?
>>
>> And what would be the difference between "permission denied, you do
>> not have the right to load IPX", and "ipv6 is not supported due to a
>> policy decision by the system administrator"?  I'd have thought
>> "permission denied" would suffice for either.
>>
>> I'm sure I'm missing something important here :-)
>
> Ah yes, not your fault though  :)  The problem is that SELinux reports
> these denials and users get scared.  We can (and now do) silence all of
> these SELinux caused denials, but now we have no notification if a
> malicious program tried to cause the auto loading of a module.  What we
> want is a way to inform users when their system is doing bad things,
> like trying to load the IPX module, but not to cause these notifications
> when SELinux is denying something that would have been effectively
> "denied" by modprobe later when it called /bin/true instead of loading
> the IPv6 module.
>
> Basically I don't want to log a denial and put up a warning in front of
> a user when the system administrator explicitly told modprobe to fail on
> those.
>
> Make a little more sense?  I honestly don't care what the retval is, I
> just care that I'm able to put up an SELinux message saying we stopped
> something bad while not putting up lots of false positives...

Yes, that explains your position, thanks.  I don't think I have any
real insight.  It still intrigues me so I flailed around a bit, here
are my thoughts.

Maybe it's userspace' problem; any actual printk() messages should be
very non-scary, and then userspace gets to filter the messages (as
well as showing them in a shiny popup or whatever).  The default
policy would be not to sound the alarm for the ipv6 module, since it
seems to be a bit special...

Or (handwave from position of extreme ignorance) you should have a
special SELinux rule with a high priority which matches the ipv6
module specifically, and is silent when it denies permission.

Or maybe it's better to ask why people disable ipv6.  Isn't it
something to do with DNS performance?  If that's the only common
reason, why isn't there an option for the DNS resolver?  If there is
and people aren't using it, why do you think people would use your new
in-kernel module blacklist instead?

I suspect sysadmins probably aren't disabling ipv6 because it poses a
_local_ privilege escalation risk.   If ipv6 is seen as slightly risky
_remotely_, perhaps it needs to be tamed so it e.g. requires
explicitly enabling on each network interface.

Alan
