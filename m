Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbXF0AHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbXF0AHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXF0AHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:07:41 -0400
Received: from smtpout.mac.com ([17.250.248.185]:58011 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXF0AHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:07:40 -0400
In-Reply-To: <20070626134712.GA8615@sergelap.austin.ibm.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Date: Tue, 26 Jun 2007 20:07:05 -0400
To: "Serge E. Hallyn" <serue@us.ibm.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, at 09:47:12, Serge E. Hallyn wrote:
> Quoting Kyle Moffett (mrmacman_g4@mac.com):
>> On Jun 25, 2007, at 16:37:58, Andreas Gruenbacher wrote:
>>> It's useful for some LSMs to be modular, and LSMs which are y/n  
>>> options won't have any security architecture issues with  
>>> unloading at all. The mere fact that SELinux cannot be built as a  
>>> module is a rather weak argument for disabling LSM modules as a  
>>> whole, so please don't.
>>
>> Here are a few questions for you:
>>
>>   1)  What do you expect to happen to all the megs of security  
>> data when you "rmmod selinux"?
>
> Read the sentence right above yours again.
>
> Noone is saying we should be able to rmmod selinux.

Ok, so say we extend LSM to do what AppArmor or TOMOYO need, what do  
you expect to happen when you "rmmod tomoyo", "rmmod apparmor", or  
whatever?  Each of those is also going to stick lots of context on  
various objects during the course of running, the same way that the  
VM subsystem sticks lots of context on filesystem pages while  
running.  Besides, even the standard "capabilities" module wants to  
attach a list of capabilities to every process and defines  
inheritance rules for them.  Ergo you have the problems described below:

>> Do you maintain a massive linked list of security data (with all  
>> the locking and performance problems) so that you can iterate over  
>> it calling kfree()? What synchronization primitive do we have  
>> right now which could safely stop all CPUs outside of security  
>> calls while we NULL out and free security data and disable  
>> security operations?  Don't say "software suspend" and "process  
>> freezer", since those have whole order-of-magnitude-complexity  
>> problems of their own (and don't always work right either).
>
>>   2)  When you "modprobe my_custom_security_module", how exactly  
>> do you expect that all the processes, files, shared memory  
>> segments, file descriptors, sockets, SYSV mutexes, packets, etc  
>> will get appropriate security pointers?
>
> Those don't all need labels for capabilities, for instance.  This  
> question is as wrong as the last one.

Ok, so let's just restrict ourselves to the simple dumb-as-dirt  
capabilities module.  Every process is "labeled" with capabilities  
while running under that LSM, right?  What happens when you "rmmod  
capabilities"?  Do you iterate over all the processes to remove their  
security data even while they may be using it?  Or do you just let it  
leak?  Some daemons test if capabilities are supported, and if so  
they modify their capability set instead of forking a high-priv and a  
low-priv process and doing IPC.  When you remove the capabilities  
module, suddenly all those programs will lose that critical "low- 
privilege" data and become full root.  What happens later when you  
"modprobe capabilities"?  Do you suddenly have to stop the system  
while you iterate over EVERY process to set capabilities based on  
whether it's root or not?  It's also impossible to determine from a  
given state in time what processes should have capabilities, as the  
model includes inheritance, which includes processes that don't even  
exist anymore.

>> 3)  This sounds suspiciously like "The mere fact that the  
>> Linux-2.6-VM cannot be built as a module is a rather weak argument  
>> for disabling VFS modules as a whole".
>
> No, your argument sounds like "my fs can't be a module so neither  
> should any."

Let's go over the differences between "my fs" and "my LSM", and the  
similarities between "my VM" and "my LSM":  Filesystems don't get  
hooked from virtually every userspace-initiated operation, whereas  
both VMs and LSMs do.  VMs and LSMs attach anonymous state data to a  
large percentage of the allocated objects in the system, whereas  
filesystems allocate their own independent datastructure and use  
that.  Would you want to "rmmod ext3" and then "modprobe ext2" while  
you have an ext2-as-ext3 filesystem *mounted*???  If you want a good  
analogy, that's a better one than the "my fs can't be a module" crap.

This whole discussion boils down to 2 points:
   1) As currently implemented, no LSM may be safely rmmod-ed
   2) Someone has submitted a patch which fixes that problem (you  
can't rmmod them at all, so no crashes)

If you really want to do modular LSMs, then you need to submit a  
patch which fixes all the race conditions in LSM removal *without*  
adding much extra overhead.  I'm sure if your solutions works then  
everyone will be much more open to modular LSMs.  I said this before:

>> So... Do you have a proposal for solving those rather fundamental  
>> design gotchas?  If so, I'm sure everybody here would love to see  
>> your patch

Cheers,
Kyle Moffett

