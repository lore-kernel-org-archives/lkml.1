Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbYHTCp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbYHTCp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHTCpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:45:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:42271 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYHTCpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:45:12 -0400
Date: Tue, 19 Aug 2008 19:44:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
 linux interface for  for access scanning
In-Reply-To: <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>
Message-ID: <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <20080818171500.78590801@lxorguk.ukuu.org.uk>  <1219080504.15566.65.camel@localhost.localdomain>  <20080818182556.13ced58f@lxorguk.ukuu.org.uk> 
 <1219082097.15566.82.camel@localhost.localdomain>  <20080818183540.GA5470@cs.cmu.edu> <1219085176.15566.100.camel@localhost.localdomain> <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having talked with Eric a bit more it looks like we have some fairly 
fundamentally different views on the scope of how this sort of thing would 
be used and that is causing us to talk about different things.

we are both looking at the threat model of trying to provide hooks so that 
data is scanned before allowing programs to use it (neither of us is 
talking about trying to do LSM things). where we differ is the uses we 
expect the hooks to be put to.

please note that I am trying to state Erics position, I may be mistaken.

Eric is viewing this through the AV point of view,
   this means

He doesn't expect there to be many scanners on a system
   initally he was only thinking of one.

He expects the interactions between the scanners to be simple (i.e. all 
scanners must bless a file or it's considered bad)
   the policy is simple and will always be the same

He expect AV signatures to change rapidly
   so storing the results of scans is of very limited value

He is expecting the scanning software to set the policy
   so there is no reason to have a system/distro defined policy

He is thinking that any ability to avoid doing the scan is a security 
hole.


these things are leading him to the kernel-based implementation that he 
posted.



I am seeing things (I think) a bit more broadly (definantly differently).

I think that the availability of a general 'this file was written to' 
interface in the kernel combined with 'take action before opening' will 
lead to many uses beyond AV work.
   these include things like filesystem indexers, HSM systems, backup 
software as well as security scanners (IDS, 'tripwire', as well as AV)

I expect to see IDS type scanners, possibly multiple ones on a machine, 
each fairly simple and not trying to do a complete job, but authoritative 
within it's area.
   this means that the interaction between approvals is more complex and 
not something that should be coded into the kernel, it should be 
configured in userspace.

becouse of things like indexers, backups, and IDS type I see great value 
in storing the fact that a file was scanned across reboots for some users 
(other users may not want to trust the system without re-scanning it after 
a reboot in case the files were changed)

In an enterprise environment I can see value in having much of the 
scanning done by one system and trusted by other systems
   this pushes for permanent, disk-based caching of scan results

I expect the distro/sysadmin to set the policy, in part becouse I expect 
to see multiple scanners and the thought of each of them setting system 
policy seemd a recipe for problems.

As part of the overall policy settings I think that there are cases where 
it's appropriate for many programs to not have the files scanned before 
accessing them (trivial examples for non-HSM environments, wc, tar, file, 
backup software)
   while this can open security holes, so can setting permissions and LSM 
configs. getting this right is part of the responsibility of the sysadmin 
(and the distro has the responsibility of giving the sysadmin reasonably 
sane defaults to start from)


these things are leading me to advocate using xattr as the result cache 
(so it will survive reboots), and userspace libraries for the hooks into 
open/read/mmap/etc (to allow for the more complex policies that I expect 
to see)


Eric has one other significant advantage, he has produced code, and is 
presumably payed to work on this (based on his posts and @redhat address)

I am a user/tester advocating a design that I think is superior, but am 
not likly to end up being the one to code it. besides the time involved, I 
consider myself a decent programmer, but don't consider myself to be ready 
to tackle this sort of task (either the kernel hooks or the userspace 
library hooks).



At this point I think opinions are needed for how generalized these hooks 
should be, and how difficult it should be for things on a system to be 
configured to bypass the scans.

thoughts?

David Lang
