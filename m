Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZEUWPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZEUWPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZEUWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:15:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34969 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbZEUWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:15:34 -0400
Subject: Re: [PATCH] IMA: Minimal IMA policy and boot param for TCB IMA
 policy
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, safford@watson.ibm.com
In-Reply-To: <20090521194706.5050.93139.stgit@dhcp231-142.rdu.redhat.com>
References: <20090521194706.5050.93139.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 18:15:33 -0400
Message-Id: <1242944133.3478.14.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 15:47 -0400, Eric Paris wrote:
> The IMA TCB policy is dangerous.  A normal use can use all of a system's
> memory (which cannot be freed) simply by building and running lots of
> executables.  The TCB policy is also nearly useless because logging in as root
> often causes a policy violation when dealing with utmp, thus rendering the
> measurements meaningless.
> 
> There is no good fix for this in the kernel.  A full TCB policy would need to
> be loaded in userspace using LSM rule matching to get both a protected and
> useful system.  But, if too little is measured before userspace can load a real
> policy one again ends up with a meaningless set of measurements.  One option
> would be to put the policy load inside the initrd in order to get it early
> enough in the boot sequence to be useful, but this runs into trouble with the
> LSM.  For IMA to measure the LSM policy and the LSM policy loading mechanism
> it needs rules to do so, but we already talked about problems with defaulting
> to such broad rules....
> 
> IMA also depends on the files being measured to be on an FS which implements
> and supports i_version.  Since the only FS with this support (ext4) doesn't
> even use it by default it seems silly to have any IMA rules by default.

IMA measures files based on policy.  It re-measures files based on
changes to i_version, which is incremented only if the filesystem is
mounted with 'iversion' support. (ext3 can be mounted with iversion.) In
order to re-measure any file in the TCB that changes, the iversion
option needs to be added in rc.sysinit, when the root filesystem is
remounted, and in /etc/fstab for other filesystems.

> This should reduce the performance overhead of IMA to near 0 while still
> letting users who choose to configure their machine as such to inclue the
> ima_tcb kernel paramenter and get measurements during boot before they can
> load a customized, reasonable policy in userspace.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
> ---
> 
>  Documentation/kernel-parameters.txt |    6 ++++++
>  security/integrity/ima/ima_policy.c |   30 +++++++++++++++++++++++++++---
>  2 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 95c523a..6a90c27 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -914,6 +914,12 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Formt: { "sha1" | "md5" }
>  			default: "sha1"
> 
> +	ima_tcb		[IMA]
> +			Load a policy which meets the needs of the Trusted
> +			Computing Base.  This means IMA will measure all
> +			programs exec'd, files mmap'd for exec, and all files
> +			opened for read by uid=0.
> +
>  	in2000=		[HW,SCSI]
>  			See header of drivers/scsi/in2000.c.
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index fd72d77..e127839 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -45,9 +45,17 @@ struct ima_measure_rule_entry {
>  	} lsm[MAX_LSM_RULES];
>  };
> 
> -/* Without LSM specific knowledge, the default policy can only be
> +/*
> + * Without LSM specific knowledge, the default policy can only be
>   * written in terms of .action, .func, .mask, .fsmagic, and .uid
>   */
> +
> +/*
> + * The minimum rule set to allow for full TCB coverage.  Measures all files
> + * opened or mmap for exec and everything read by root.  Dangerous because
> + * normal users can easily run the machine out of memory simply building
> + * and running executables.
> + */
>  static struct ima_measure_rule_entry default_rules[] = {
>  	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
>  	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
> @@ -59,6 +67,8 @@ static struct ima_measure_rule_entry default_rules[] = {
>  	 .flags = IMA_FUNC | IMA_MASK},
>  	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
>  	 .flags = IMA_FUNC | IMA_MASK},
> +	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
> +	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
>  };
> 
>  static LIST_HEAD(measure_default_rules);
> @@ -67,6 +77,14 @@ static struct list_head *ima_measure;
> 
>  static DEFINE_MUTEX(ima_measure_mutex);
> 
> +static bool ima_use_tcb __initdata;
> +static int __init default_policy_setup(char *str)
> +{
> +	ima_use_tcb = 1;
> +	return 1;
> +}
> +__setup("ima_tcb", default_policy_setup);
> +
>  /**
>   * ima_match_rules - determine whether an inode matches the measure rule.
>   * @rule: a pointer to a rule
> @@ -162,9 +180,15 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
>   */
>  void __init ima_init_policy(void)
>  {
> -	int i;
> +	int i, entries;
> +
> +	/* if !ima_use_tcb set entries = 0 so we load NO default rules */
> +	if (ima_use_tcb)
> +		entries = ARRAY_SIZE(default_rules);
> +	else
> +		entries = 0;
> 
> -	for (i = 0; i < ARRAY_SIZE(default_rules); i++)
> +	for (i = 0; i < entries; i++)
>  		list_add_tail(&default_rules[i].list, &measure_default_rules);
>  	ima_measure = &measure_default_rules;
>  }
> 

