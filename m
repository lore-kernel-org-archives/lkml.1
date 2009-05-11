Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZEKUq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZEKUq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZEKUqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:46:19 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:42956 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZEKUqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:46:18 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>
In-Reply-To: <20090511175626.GA4758@kroah.com>
References: <20090509143742.GA27663@kroah.com>
	 <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
	 <20090511175626.GA4758@kroah.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 11 May 2009 16:41:57 -0400
Message-Id: <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 10:56 -0700, Greg KH wrote:
> On Mon, May 11, 2009 at 01:40:30PM -0400, David P. Quigley wrote:
> > I took the patches and applied them to Linus' tree and installed the
> > kernel on a Fedora 10 box with SELinux enabled and it oopses on startup.
> > The oops happens every time I boot up so I can reproduce it as needed to
> > help fix it. I've attached my kernel config in case that helps and have
> > pasted the oops below. If needed I can provide the entire dmesg output.
> 
> If you disable selinux at the boot command line, does this oops not
> happen?
> 
> thanks for testing and reporting this,
> 
> greg k-h

So if I boot SELinux with enforcing mode turned off (enforcing=0) it
boots without oopsing. I would assume that booting with SELinux
completely disabled does the same thing. I narrowed it down to this one
system call.

----
type=SYSCALL msg=audit(05/11/2009 14:07:11.756:4) : arch=x86_64 syscall=open success=yes exit=3 a0=7fffaf25dfe0 a1=2 a2=0 a3=8 items=0 ppid=1 pid=2329 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=tty5 ses=4294967295 comm=mingetty exe=/sbin/mingetty subj=system_u:system_r:getty_t:s0 key=(null) 
type=AVC msg=audit(05/11/2009 14:07:11.756:4) : avc:  denied  { create } for  pid=2329 comm=mingetty name=vcs5 scontext=system_u:system_r:getty_t:s0 tcontext=system_u:object_r:tmpfs_t:s0 tclass=chr_file 
type=AVC msg=audit(05/11/2009 14:07:11.756:4) : avc:  denied  { add_name } for  pid=2329 comm=mingetty name=vcs5 scontext=system_u:system_r:getty_t:s0 tcontext=system_u:object_r:tmpfs_t:s0 tclass=dir 
type=AVC msg=audit(05/11/2009 14:07:11.756:4) : avc:  denied  { mknod } for  pid=2329 comm=mingetty capability=mknod scontext=system_u:system_r:getty_t:s0 tcontext=system_u:system_r:getty_t:s0 tclass=capability 
type=AVC msg=audit(05/11/2009 14:07:11.756:4) : avc:  denied  { write } for  pid=2329 comm=mingetty name=/ dev=tmpfs ino=4 scontext=system_u:system_r:getty_t:s0 tcontext=system_u:object_r:tmpfs_t:s0 tclass=dir 
----

Basically what this means is that getty attempted an open system call
which would have failed with an SELinux permission denial. What I think
might be happening here is that getty tries to open the tty device and
the devtmpfs kicks in and tries to create the tty devices. The problem
is in doing this it uses the credentials of the current process which in
this case is getty, and since it is trying to create them on a tmpfs
instead of a directory labeled properly it is failing. Now even if these
permissions fail it shouldn't be possible to bug the kernel with it.
This makes me think that there is a problem some where in the error
handling code.

This however does highlight a problem with the fact that device node
labeling isn't being done properly. It should be possible to create this
fs with a different name such that it doesn't appear as a tmpfs file
system to SELinux. If it appears as a devtmpfs file system then we can
specify the root label and labels on the other devices properly in
policy. Also it is concerning that creating the node is being done with
the credentials of the current process because it means that
applications which have no business creating device nodes will have to
have policy allowing them to do so. 

Dave

