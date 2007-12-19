Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbXLSD2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbXLSD2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXLSD2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:28:15 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:42699 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752986AbXLSD2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:28:14 -0500
Message-ID: <47688FD9.6080705@crispincowan.com>
Date: Tue, 18 Dec 2007 19:28:25 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
 settings for task actions [try #2]
References: <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil> <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <25572.1197320887@redhat.com> <25965.1197329769@redhat.com> <9789.1197405725@redhat.com>
In-Reply-To: <9789.1197405725@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>> That sounds too SELinux specific.  How do I do it so that it works for any
>>> LSM?
>>>       
>> You can't.  There is no LSM for userspace; LSM specifically disavowed
>> any common userspace API, and that was one of our original
>> objections/concerns about it.
>>     
> So, basically, userspace programs (outside of security tools) aren't supposed
> to need access to the security infrastructure?
>   
That depends on your LSM model. Under SELinux, lots of programs need
access to the security infrastructure to set the label to something
other than the default label. Under AppArmor, there is no concept of a
label, and not much need for programs to access the security infrastructure.

So far, AppArmor has two API's into the kernel: change_hat() and
change_profile(). Both of them are used to change the security context
of the calling process. Naturally they are subject to policy
restrictions of what you get to change to. They are largely intended to
be used by applications servers (think of Java servlets) to change into
a security context associated with a servlet rather than putting all the
hosted applications in the application server's context.

I'm unclear on whether SELinux has an analogous facility. I've been told
that the concept is anathema, and also that there is a similar facility
in SELinux, but without the corresponding user-space components that
AppArmor provides (mod_apparmor for Apache, and a similar module for
Tomcat).

Going way up to the top of the threat for 08/28, you say you want to do
this:

David Howells wrote:
> Allow kernel services to override LSM settings appropriate to the actions
> performed by a task by duplicating a security record, modifying it and then
> using task_struct::act_as to point to it when performing operations on behalf
> of a task.
>
> This is used, for example, by CacheFiles which has to transparently access the
> cache on behalf of a process that thinks it is doing, say, NFS accesses with a
> potentially inappropriate (with respect to accessing the cache) set of
> security data.
I'm not sure, but I think that you could do this *much* easier in
AppArmor using change_profile to switch the NFS Daemon to the profile of
the requesting process. That still leaves some problems:

    * The profile of the requesting process has to exist on the NFS
      server, and it may not.
    * You need a uniform name space of profiles, and you definitely
      don't have that.

However, it seems to me that you have the same problem with SELinux:
what do you do if the domain/type of the requesting process does not
exist on the NFS server? How do you ensure a uniform name space of types?

>>> Is linking against libselinux is a viable option if it's not available under
>>> all LSM models?  Is it available under all LSM models?  Perhaps Casey can
>>> answer this one.
>>>       
>> Nope, they would all have their own libraries, if they have a library at
>> all.  But that isn't your problem
>>     
> It is if I have to maintain a special pieces of code for each possible LSM.
> One piece for SELinux, one piece for AppArmour, one piece for Smack, one piece
> for Casey's security system.  That sounds like a pain.
>   
There is little correspondence between AppArmor and SELinux, but one
point of correspondence is that an AA "profile" is quite similar to the
SELinux notion of a domain as applied to a process. In the Targeted
Policy, they are used the same way too. I could imagine a small
(growing) generic library that mapped onto SELinux and AppArmor APIs for
changing security context.

>> Why are you opposed to having userspace determine the context and write it
>> to a cachefiles interface,
>>     
> Because, from what I gather, that means my userspace program needs to do
> something different, depending on the security model that's currently in force
> on a system.
Yes, that's absolutely true: if you want to manipulate the security
system, you have to actually call it in terms that the security system
will understand.

>   Furthermore, I would have to have separate code, as far as I
> know, for each security model as there's no commonality in userspace.
>   
Yep. If there was a common user space, ten there really wouldn't need to
be separate LSMs. This is a fundamental problem: the security systems
export rather different semantics, so there cannot be a truly generic
user space, just some band aids that provide a klude to access the bits
that kind of have some overlap.

> How about I just stick the context in /etc/cachefilesd.conf as a textual
> configuration item and have the daemon pass that as a string to the cachefiles
> kernel module, which can then ask LSM if it's valid to set this context as an
> override, given the daemon's own security context?  That seems entirely
> reasonable to me.
>   
That semantically maps well to the AppArmor change_profile() API, so
conceptually it should work. It would be easier if you did that in user
space instead of in the kernel, I don't know if it causes a problem to
attempt to kind-of call change_profile() from within the kernel.
Notably, change_profile can fail, so what does your kernel module do
when the attempt to change security context fails?

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

