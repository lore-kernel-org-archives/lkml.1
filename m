Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYE2DRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYE2DRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYE2DRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:17:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43047 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYE2DRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:17:30 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528012242.a0e98d87.akpm@linux-foundation.org>
References: <1211555145.16195.18.camel@new-host>
	 <20080528012242.a0e98d87.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 23:17:26 -0400
Message-Id: <1212031046.4747.57.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-28 at 01:22 -0700, Andrew Morton wrote: 
> On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > This is a re-release of Integrity Measurement Architecture(IMA) as an
> > independent Linunx Integrity Module(LIM) service provider, which implements
> > the new LIM must_measure(), collect_measurement(), store_measurement(), and
> > display_template() API calls. The store_measurement() call supports two 
> > types of data, IMA (i.e. file data) and generic template data.
> > 
> > When store_measurement() is called for the IMA type of data, the file 
> > measurement and the file name hint are used to form an IMA template.
> > IMA then calculates the IMA template measurement(hash) and submits it 
> > to the TPM chip for inclusion in one of the chip's Platform Configuration 
> > Registers (PCR).  
> > 
> > When store_measurement() is called for generic template data, IMA 
> > calculates the measurement(hash) of the template data, and submits 
> > the template measurement to the TPM chip for inclusion in one of the
> > chip's Platform Configuration Registers(PCR).
> > 
> > In order to view the contents of template data through securityfs, the
> > template_display() function must be defined in the registered 
> > template_operations.  In the case of the IMA template, the list of 
> > file names and files hashes submitted can be viewed through securityfs. 
> > 
> > IMA can be included or excluded in the kernel configuration.  If
> > included in the kernel and the IMA_BOOTPARAM is selected, IMA can 
> > also be enabled/disabled on the kernel command line with 'ima='.
> > 
> 
> - I see lots of user file I/O being done from within the kernel. 
>   This makes eyebrows raise.  Also some other eyebrow-raising
>   file-related things in there.

The amount of I/O is dependent on the number of files being measured.
The default policy measures a whole lot.  An LSM specific integrity 
policy would cut down on the number of files being measured. For now,
either remove the third rule in default_rules or replace the default
rules with a new policy. To load a new policy execute:
	./integrity_load < policy

policy:
#
# Integrity measure policy
#
func=BPRM_CHECK 
func=FILE_MMAP mask=MAY_EXEC
#func=INODE_PERMISSION mask=MAY_READ

integrity_load.c:
/* 
 * integrity_load.c 
 *
 * Strip comments from integrity measurement policy file and load 
 * policy rules into the kernel by writing to security/ima/policy.
 *
 */
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int fd;
	char *policyname = "/sys/kernel/security/ima/policy";
	char *line = NULL;
	ssize_t len = 0, readcnt;
	int rc = 0;

	if (argc == 2)
		policyname = argv[1];

	fd = open(policyname, O_WRONLY);
	if (fd == -1) {
		perror("opening policy");
		exit(EXIT_FAILURE);
	}
	while ((readcnt = getline(&line, &len, stdin)) != -1) {
		if (*line == '#')
			continue;
		printf("%s", line);
		rc = write(fd, line, readcnt);
		if (rc == -1) {
			perror("write");
			break;
		}
	}

	close(fd);
	if (line)
		free(line);
	return (rc == -1) ? EXIT_FAILURE : EXIT_SUCCESS;
}

> - A complicated-looking in-kernel string parser which is implementing
>   an new and apparently-undocumented user->kernel ABI.

oops, will document.

> - Some GFP_ATOMICs which can hopefully become GFP_KERNEL.
Ok.

> - timespec_set() is unneeeded - just use struct assignment (ie: "=")

Am confused.  timespec_set is doing an assignment. Should I
replace timespec_set with a memcpy?

> - timespec_recent() looks a bit hacky.  The problems which are being
>   solved here should be described in the changelog.  Perhaps we can
>   think of a better way, but first we have to know about it.

Ok.

> - shouldn't ima_inode_init() initialise tv_usec too?

I don't think it matters.  timespec_equal checks that the mtime in
the iint and inode are the same.  If they are the same then we don't
need to recalculate the hash, unless it's been updated in really
quick succession.

> - All the games with mtimes should be described in the changelog too.

Ok. The timespec_recent and mtime issues are part of the same problem
of detecting when a file has been modified.

> - All the `static struct integrity_operations' instances could be
>   made const.  And lots of other foo_operations too, I expect.
> 
>   That will lead to a constification chase all over the place, but
>   it's probably for the best.  This is after all a "security" feature
>   and there is perhaps some benefit in getting your eminently
>   hijackable function pointers into read-only memory.

Ok.

> - ima_fixup_inodes looks like it will race and crash against a
>   well-timed unmount.  I expect you will need to bump s_count before
>   dropping sb_lock.  See writeback_inodes() for an example.

ima_fixup_inodes() is called once at initialization.  

> - bug: ima_fixup_inodes() does a GFP_KERNEL allocation inside
>   inode->i_lock.  This bug shouldn't have got this far.  Please always
>   enable all kernel debugging features when testing code. 
>   Documentation/SubmitChecklist has useful things.

sorry.

> - inode.i_lock is defined as an innermost lock which is used for
>   protecting data internal to the inode.  You appear to be using it for
>   way too much stuff in here.
> 
> - It would be useful to add a comment explaining why
>   late_initcall(init_ima) is using late_initcall() rather than plain
>   old module_init().  Because it is impossible for the reader to
>   determine this information from the implementation.
> 
> - mutex_init(&ima_extend_list_mutex) is unneeded.

Ok.

> - Does ima_add_digest_entry() need to use the unreliable GFP_ATOMIC?
> 
>   This matters.  This is a security feature and if that
>   kmalloc(GFP_ATOMIC) fails (as it easily can do) then I expect the
>   system will either be insecure or will outright malfunction.

Ok.

> - Why does CONFIG_IMA_BOOTPARAM exist, and can it be removed (ie:
>   made unconditional)?
> 
> - Similarly CONFIG_IMA_BOOTPARAM_VALUE.  Let's be decisive here -
>   distributors only get one shot at setting these things.

Fine with me.

> - mode_setup() will identify itself as "mode_setup" in its KERN_INFO
>   printk.  That's a bit unhelpful.  I'd suggest that all/most printks
>   here be prefixed with "integrity:".

Yes, will do throughout.

> - GFP_ATOMICs everywhere :(

Will address throughout.

> - As ima_htable.violations "can overflow", atomic_long_t might be a
>   better choice of type.
> 
> - skip_measurement(): the hard-coded test for PROC_SUPER_MAGIC,
>   SYSFS_MAGIC etc is quite unpleasant.  Surely there is a better way.

Yes, one solution is to add policy support so that rules could be 
defined instead of actually hard coding each and every fs magic 
number here in skip_measurement. This is on my list of todo's.

> Generally: the code is all moderately intrusive into the VFS and this
> sort of thing does need careful explanation and justification, please. 
> Once we have some understanding of what you're trying to achieve here
> we will inevitably ask "can't that be done in userspace".  So it would
> be best if your description were to preemptively answer all that.  

Ok.

