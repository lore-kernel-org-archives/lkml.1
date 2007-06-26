Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbXFZEKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbXFZEKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXFZEJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:09:58 -0400
Received: from smtpout.mac.com ([17.250.248.175]:62283 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXFZEJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:09:57 -0400
In-Reply-To: <200706252237.59226.agruen@suse.de>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com>
Cc: James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Date: Tue, 26 Jun 2007 00:09:24 -0400
To: Andreas Gruenbacher <agruen@suse.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 25, 2007, at 16:37:58, Andreas Gruenbacher wrote:
> On Monday 25 June 2007 06:33, James Morris wrote:
>> Convert LSM into a static interface, as the ability to unload a  
>> security module is not required by in-tree users and potentially  
>> complicates the overall security architecture.
>
> It's useful for some LSMs to be modular, and LSMs which are y/n  
> options won't have any security architecture issues with unloading  
> at all. The mere fact that SELinux cannot be built as a module is a  
> rather weak argument for disabling LSM modules as a whole, so   
> please don't.

Here are a few questions for you:

   1)  What do you expect to happen to all the megs of security data  
when you "rmmod selinux"?  Do you maintain a massive linked list of  
security data (with all the locking and performance problems) so that  
you can iterate over it calling kfree()? What synchronization  
primitive do we have right now which could safely stop all CPUs  
outside of security calls while we NULL out and free security data  
and disable security operations?  Don't say "software suspend" and  
"process freezer", since those have whole order-of-magnitude- 
complexity problems of their own (and don't always work right either).

   2)  When you "modprobe my_custom_security_module", how exactly do  
you expect that all the processes, files, shared memory segments,  
file descriptors, sockets, SYSV mutexes, packets, etc will get  
appropriate security pointers?  This isn't even solvable the same way  
the "rmmod" problem is, since most of that isn't even accessible  
without iterating over the ENTIRE dcache, icache, every process,  
every process' file-descriptors, every socket, every unix socket,  
every anonymous socket, every SYSV shm object, every currently-in- 
process packet.

   3)  This sounds suspiciously like "The mere fact that the  
Linux-2.6-VM cannot be built as a module is a rather weak argument  
for disabling VFS modules as a whole".  We don't do "pluggable  
fundamental infrastructure" in Linux.  If it's fundamental  
infrastructure then you eliminate as many differences as possible and  
leave the rest to CONFIG options (or delete it entirely).


So... Do you have a proposal for solving those rather fundamental  
design gotchas?  If so, I'm sure everybody here would love to see  
your patch; though maybe not if it's a 32MB patch-zilla-of-doom (AKPM  
beware, the merge-conflict-from-hell is on its way).  On the other  
hand, if you accept that these problems basically can't be solved and  
we make things static and rip out a bunch of code, we can probably  
improve our performance under larger security models (like SELinux/ 
AppArmor/TOMOYO/MagicSecurityFlavorOfTheWeek(TM)) by a percent or two.

Cheers,
Kyle Moffett

