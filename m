Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbXF0BX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbXF0BX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXF0BXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:23:15 -0400
Received: from smtpout.mac.com ([17.250.248.186]:51491 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXF0BXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:23:14 -0400
In-Reply-To: <4681B611.1000704@novell.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com> <4681B611.1000704@novell.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E83D42B8-F8B8-41D1-AA4A-C669EC3F37B1@mac.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andreas Gruenbacher <agruen@suse.de>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Date: Tue, 26 Jun 2007 21:22:45 -0400
To: Crispin Cowan <crispin@novell.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, at 20:57:53, Crispin Cowan wrote:
> Kyle Moffett wrote:
>> Let's go over the differences between "my fs" and "my LSM", and  
>> the similarities between "my VM" and "my LSM":  Filesystems don't  
>> get hooked from virtually every userspace-initiated operation,  
>> whereas both VMs and LSMs do.  VMs and LSMs attach anonymous state  
>> data to a large percentage of the allocated objects in the system,  
>> whereas filesystems allocate their own independent datastructure  
>> and use that.  Would you want to "rmmod ext3" and then "modprobe  
>> ext2" while you have an ext2-as-ext3 filesystem *mounted*???  If  
>> you want a good analogy, that's a better one than the "my fs can't  
>> be a module" crap.
>>
>> This whole discussion boils down to 2 points:
>>   1) As currently implemented, no LSM may be safely rmmod-ed
>>   2) Someone has submitted a patch which fixes that problem (you  
>> can't
>> rmmod them at all, so no crashes)
>>
>> If you really want to do modular LSMs, then you need to submit a  
>> patch which fixes all the race conditions in LSM removal *without*  
>> adding much extra overhead.  I'm sure if your solutions works then  
>> everyone will be much more open to modular LSMs.
>
> Hmmm. You seem to be mostly concerned with safely rmmod'ing  
> modules. In contrast, my main concern with the proposed patch is  
> that it removes the ability to *insert* a module.

You must have missed this in my emails:
>>   2) When you "modprobe my_custom_security_module", how exactly do  
>> you expect that all the processes, files, shared memory segments,  
>> file descriptors, sockets, SYSV mutexes, packets, etc will get  
>> appropriate security pointers?  This isn't even solvable the same  
>> way the "rmmod" problem is, since most of that isn't even  
>> accessible without iterating over the ENTIRE dcache, icache, every  
>> process, every process' file-descriptors, every socket, every unix  
>> socket, every anonymous socket, every SYSV shm object, every  
>> currently-in-process packet.

I'd argue that security-module-insertion is actually MORE complicated  
than removal.  Here's one example:  TOMOYO cares about the process  
execution tree, but you can't penalize the no-LSM case by a percent  
or two to add that kind of data.  When TOMOYO is loaded, it wants to  
do access control based on process execution trees for which data  
DOES NOT EXIST!!!  Not only that, but the processes which originally  
ran the one you care about (and which you'd need to recreate that  
data) may have exited anywhere from seconds to years before.  It is  
fundamentally IMPOSSIBLE to recreate that data, even if you could  
solve the problems of how to do it while the system is running  
without racing with existing process operations.  Imagine a process  
which hasn't had security data tagged to it yet which opens thousands  
of FIFOs per second, waits for your tagging code to assign security  
data to them in the filesystem, and then removes them; if you did it  
right you could prevent the code from EVER completely tagging every  
object (even assuming you could recreate enough information).

Such a need to add extra security data to multiple classes of objects  
is *fundamental* to any security module (isn't that the whole  
point?)  As such, you can't just "modprobe" one and expect it to  
work.  That's like mounting an ext2 filesystem, and then later trying  
to "modprobe ext3" and dynamically switch to the ext3 code and enable  
journalling all at once ON THE MOUNTED FILESYSTEM!!!

Sure, theoretically it *could* be done, but the code complexity is  
hardly worth it (plus nobody has yet even tried posting patches to  
make it happen).

> Consider the use case of joe admin who is running enterprise- 
> supported RHEL or SLES, and wants to try some newfangled LSM  
> FooSecureMod thingie.  So he grabs a machine, config's selinux=0 or  
> apparmor=0 and loads his own module on boot, and plays with it. He  
> even likes FooSecure, better than SELinux or AppArmor, and wants to  
> roll it out across his data center.

Flatly impossible.  You simply cannot "load" a security module and  
hope to provide any useful information about the system's present  
state.  If you want comprehensive security it has to be there before  
a single byte of userspace code is executed.  SELinux sort-of handles  
unlabelled objects by treating them with a small set of initial  
"types", but that's only enough to get the system up enough to  
actually relabel objects with type-transitions (after init loads the  
selinux policy it reexecs itself, before doing anything else).

> So to solve the problem James & Kyle are concerned with, and  
> preserve user choice, how about we *only* remove the ability to  
> rmmod, and leave in place the ability to modprobe? Or even easier,  
> LSMs that don't want to be unloaded can just block rmmod, and  
> simple LSMs that can be unloaded safely can permit it.

An LSM simple enough to unload would be too simple for anybody to  
want to load in the first place (even capabilities can have this  
problem).  What kind of security module would you load that doesn't  
need to add security data to objects?

Then of course there's also the -ENOPATCH problem.

Cheers,
Kyle Moffett

