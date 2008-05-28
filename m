Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYE1I3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYE1I3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYE1I2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:28:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbYE1I2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:28:51 -0400
Date: Wed, 28 May 2008 01:22:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-Id: <20080528012242.a0e98d87.akpm@linux-foundation.org>
In-Reply-To: <1211555145.16195.18.camel@new-host>
References: <1211555145.16195.18.camel@new-host>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> This is a re-release of Integrity Measurement Architecture(IMA) as an
> independent Linunx Integrity Module(LIM) service provider, which implements
> the new LIM must_measure(), collect_measurement(), store_measurement(), and
> display_template() API calls. The store_measurement() call supports two 
> types of data, IMA (i.e. file data) and generic template data.
> 
> When store_measurement() is called for the IMA type of data, the file 
> measurement and the file name hint are used to form an IMA template.
> IMA then calculates the IMA template measurement(hash) and submits it 
> to the TPM chip for inclusion in one of the chip's Platform Configuration 
> Registers (PCR).  
> 
> When store_measurement() is called for generic template data, IMA 
> calculates the measurement(hash) of the template data, and submits 
> the template measurement to the TPM chip for inclusion in one of the
> chip's Platform Configuration Registers(PCR).
> 
> In order to view the contents of template data through securityfs, the
> template_display() function must be defined in the registered 
> template_operations.  In the case of the IMA template, the list of 
> file names and files hashes submitted can be viewed through securityfs. 
> 
> IMA can be included or excluded in the kernel configuration.  If
> included in the kernel and the IMA_BOOTPARAM is selected, IMA can 
> also be enabled/disabled on the kernel command line with 'ima='.
> 

- I see lots of user file I/O being done from within the kernel. 
  This makes eyebrows raise.  Also some other eyebrow-raising
  file-related things in there.

- A complicated-looking in-kernel string parser which is implementing
  an new and apparently-undocumented user->kernel ABI.

- Some GFP_ATOMICs which can hopefully become GFP_KERNEL.

- timespec_set() is unneeeded - just use struct assignment (ie: "=")

- timespec_recent() looks a bit hacky.  The problems which are being
  solved here should be described in the changelog.  Perhaps we can
  think of a better way, but first we have to know about it.

- shouldn't ima_inode_init() initialise tv_usec too?

- All the games with mtimes should be described in the changelog too.

- All the `static struct integrity_operations' instances could be
  made const.  And lots of other foo_operations too, I expect.

  That will lead to a constification chase all over the place, but
  it's probably for the best.  This is after all a "security" feature
  and there is perhaps some benefit in getting your eminently
  hijackable function pointers into read-only memory.

- ima_fixup_inodes looks like it will race and crash against a
  well-timed unmount.  I expect you will need to bump s_count before
  dropping sb_lock.  See writeback_inodes() for an example.

- bug: ima_fixup_inodes() does a GFP_KERNEL allocation inside
  inode->i_lock.  This bug shouldn't have got this far.  Please always
  enable all kernel debugging features when testing code. 
  Documentation/SubmitChecklist has useful things.

- inode.i_lock is defined as an innermost lock which is used for
  protecting data internal to the inode.  You appear to be using it for
  way too much stuff in here.

- It would be useful to add a comment explaining why
  late_initcall(init_ima) is using late_initcall() rather than plain
  old module_init().  Because it is impossible for the reader to
  determine this information from the implementation.

- mutex_init(&ima_extend_list_mutex) is unneeded.

- Does ima_add_digest_entry() need to use the unreliable GFP_ATOMIC?

  This matters.  This is a security feature and if that
  kmalloc(GFP_ATOMIC) fails (as it easily can do) then I expect the
  system will either be insecure or will outright malfunction.

- Why does CONFIG_IMA_BOOTPARAM exist, and can it be removed (ie:
  made unconditional)?

- Similarly CONFIG_IMA_BOOTPARAM_VALUE.  Let's be decisive here -
  distributors only get one shot at setting these things.

- mode_setup() will identify itself as "mode_setup" in its KERN_INFO
  printk.  That's a bit unhelpful.  I'd suggest that all/most printks
  here be prefixed with "integrity:".

- GFP_ATOMICs everywhere :(

- As ima_htable.violations "can overflow", atomic_long_t might be a
  better choice of type.

- skip_measurement(): the hard-coded test for PROC_SUPER_MAGIC,
  SYSFS_MAGIC etc is quite unpleasant.  Surely there is a better way.

-
	+/**
	+ * ima_must_measure - measure decision based on policy.
	+ * @d - pointer to struct ima_data containing ima_args_data

  So if we know the type of d, did we _have_ to make it void*?  It's
  much better to use the C yype system if at all possible.

- ditto ima_collect_measurement()

Generally: the code is all moderately intrusive into the VFS and this
sort of thing does need careful explanation and justification, please. 
Once we have some understanding of what you're trying to achieve here
we will inevitably ask "can't that be done in userspace".  So it would
be best if your description were to preemptively answer all that.  


