Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYHUIoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYHUIoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYHUIoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:44:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:53355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYHUIoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:44:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: checkpoint/restart ABI
Date: Thu, 21 Aug 2008 10:43:40 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
References: <20080807224033.FFB3A2C1@kernel> <200808112347.50245.arnd@arndb.de> <48AD0379.9030705@cs.columbia.edu>
In-Reply-To: <48AD0379.9030705@cs.columbia.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211043.41387.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19XNaCFH6/vsAc3Qki97nHuHGVz1mMdIS4fqV7
 naa7c+/at/wKlqEpoUfuNvhJAsurmyYCxhm2AWYBFMX5GDAOYY
 FRqZ1OoXCKNG7pBMDakhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Oren Laadan wrote:
> 
> Arnd Bergmann wrote:

> Extending this view in the context of security - we can require sysadmin
> privilege to restart, and then sysadmin is responsible for the contents
> of the file. The kernel will ensure the the data isn't corrupted. Much
> like with loading a kenrel module - the admin may load any sort of crap.
> Then, sysadmin may, for instance, add a signature on a checkpointed file
> to verify it's integrity.
> 
> (Well, one problem with this scheme in the context of self-checkpoint
> would be - who can be trusted to generate the signature in that case).

Sorry, I don't buy that argument. I'm convinced that an implementation
is possible where any user can load checkpoints of tasks that he could
create by starting the processes directly. If you argue that loading
a corrupted checkpoint can cause any problems, then I would assume
the restart code needs better permission and sanity checks.

> Using a single handle (crid or a special file descriptor) to identify
> the whole checkpoint is very useful - to be able to stream it (eg. over
> the network, or through filters). It is also very important for future
> features and optimizations. For example, to reduce downtime of the
> application during checkpoint, one can use COW for dirty pages, and
> only write-back the entire data after the application resumes execution.
> Or imagine a use-case where one would like to keep the entire checkpoint
> in memory. These are pretty hard to do if you split the handling between
> multiple files or handles.

right.

> > On the restart side, I think the most consistent interface would
> > be a new binfmt_chkpt implementation that you can use to execve
> > a checkpoint, just like you execute an ELF file today. The binfmt
> > can be a module (unlike a syscall), so an administrator that is
> > afraid of the security implications can just disable it by not
> > loading the module. In an execve model, the parent process can
> > set up anything related to credentials as good as it's allowed
> > to and then let the kernel do the rest.
> 
> This is an interesting idea but not without its problems. In particular,
> a successful execve() by one thread destroys all the others.

Right, execve currently assumes that the new process starts up with
a single thread, but a potential binfmt_chkpt would need to potentially
start multithreaded. I guess this either requires execve to reuse
the existing threads (assuming they have been set up correctly in
advance) or to create new ones according to the context of the
checkpoint data. It may not be as easy as I thought initially, but
both seem possible.
Restarting a whole set of processes from a checkpoint would be
a relatively simple extension of that.

> Also, it isn't clear how this can work with pre-copying and live-migration;
> And finally, I'm not sure how to handle shared objects in this manner.

What do you mean with pre-copying?
How is live-migration different from restarting a previously saved
task from the same machine?


> As for kernel module - it is easy to implement most of the checkpoint
> restart functionality in a kernel module, leaving only the syscall stubs
> in the kernel.

Yeah, I've done the same in spufs, but I still think it's ugly ;-)

	Arnd <><
