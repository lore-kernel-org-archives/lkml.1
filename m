Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYE2Dgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYE2Dgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYE2Dgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:36:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbYE2Dgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:36:39 -0400
Date: Wed, 28 May 2008 20:30:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-Id: <20080528203013.5a927d30.akpm@linux-foundation.org>
In-Reply-To: <1212031046.4747.57.camel@new-host.home>
References: <1211555145.16195.18.camel@new-host>
	<20080528012242.a0e98d87.akpm@linux-foundation.org>
	<1212031046.4747.57.camel@new-host.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 23:17:26 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Wed, 2008-05-28 at 01:22 -0700, Andrew Morton wrote: 
> > On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > 
> > > This is a re-release of Integrity Measurement Architecture(IMA) as an
> > > independent Linunx Integrity Module(LIM) service provider, which implements
> > > the new LIM must_measure(), collect_measurement(), store_measurement(), and
> > > display_template() API calls. The store_measurement() call supports two 
> > > types of data, IMA (i.e. file data) and generic template data.
> > > 
> > > When store_measurement() is called for the IMA type of data, the file 
> > > measurement and the file name hint are used to form an IMA template.
> > > IMA then calculates the IMA template measurement(hash) and submits it 
> > > to the TPM chip for inclusion in one of the chip's Platform Configuration 
> > > Registers (PCR).  
> > > 
> > > When store_measurement() is called for generic template data, IMA 
> > > calculates the measurement(hash) of the template data, and submits 
> > > the template measurement to the TPM chip for inclusion in one of the
> > > chip's Platform Configuration Registers(PCR).
> > > 
> > > In order to view the contents of template data through securityfs, the
> > > template_display() function must be defined in the registered 
> > > template_operations.  In the case of the IMA template, the list of 
> > > file names and files hashes submitted can be viewed through securityfs. 
> > > 
> > > IMA can be included or excluded in the kernel configuration.  If
> > > included in the kernel and the IMA_BOOTPARAM is selected, IMA can 
> > > also be enabled/disabled on the kernel command line with 'ima='.
> > > 
> > 
> > - I see lots of user file I/O being done from within the kernel. 
> >   This makes eyebrows raise.  Also some other eyebrow-raising
> >   file-related things in there.
> 
> The amount of I/O is dependent on the number of files being measured.
> The default policy measures a whole lot.  An LSM specific integrity 
> policy would cut down on the number of files being measured. For now,
> either remove the third rule in default_rules or replace the default
> rules with a new policy. To load a new policy execute:
> 	./integrity_load < policy

The problem is that the code is doing in-kernel user file I/O *at all*.
It's a red flag.

Look who else is using kernel_read(): just the exec code.  Plus
something in v9fs which I'd better not look at.

>
> ...
>
> > - timespec_set() is unneeeded - just use struct assignment (ie: "=")
> 
> Am confused.  timespec_set is doing an assignment. Should I
> replace timespec_set with a memcpy?

	struct timespec a, b;

	a = b;
> 
> > - All the games with mtimes should be described in the changelog too.
> 
> Ok. The timespec_recent and mtime issues are part of the same problem
> of detecting when a file has been modified.

Can't use inode.i_version?

> 
> > - ima_fixup_inodes looks like it will race and crash against a
> >   well-timed unmount.  I expect you will need to bump s_count before
> >   dropping sb_lock.  See writeback_inodes() for an example.
> 
> ima_fixup_inodes() is called once at initialization.  

What is "initialisation"?  During initcalls?  Are there even any files
in cache at that time?  I bet we can arrange for the answer to become
"no".


