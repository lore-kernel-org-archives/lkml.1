Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbXJAEPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbXJAEPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 00:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXJAEPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 00:15:21 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:47663 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751098AbXJAEPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 00:15:19 -0400
X-YMail-OSG: Fc.EKnwVM1kiJVKA7dk93fjzer5Bu5LLB1aZkcGOG_aMPsmhdfZVe10Cy6MOLgxm1v.WSad1VQ--
X-RocketYMMF: rancidfat
Date: Sun, 30 Sep 2007 21:15:18 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: "Serge E. Hallyn" <serge@hallyn.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20071001034724.GA28534@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <527669.54986.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serge@hallyn.com> wrote:

> ...
> > +A process can see the smack label it is running with by
> > +reading /proc/self/attr/current. A privileged process can
> > +set the process smack by writing there.
> 
> Ok, so to control smack label transitions, basically you would
> run with CAP_MAC_OVERRIDE (see my note later) so that you're
> allowed to change your smack label by writing to
> /proc/self/attr/current, then you drop CAP_MAC_OVERRIDE, then you're
> no longer able to change your label?  I.e. no inherent label changing
> rules through smack itself?

That is correct. Smack task labels do not change spontaniously.

> Just making sure I have that right.  If I do, then I think at least
> defining the word 'privileged' above, given that this is mac,
> would help.

Good idea.

> ...
> > --- linux-2.6.23-rc8-base/security/smack/Kconfig	1969-12-31
> 16:00:00.000000000 -0800
> > +++ linux-2.6.23-rc8-smack/security/smack/Kconfig	2007-09-25
> 15:30:38.000000000 -0700
> > @@ -0,0 +1,10 @@
> > +config SECURITY_SMACK
> > +	bool "Simplified Mandatory Access Control Kernel Support"
> > +	depends on NETLABEL && SECURITY_NETWORK
> > +	default n
> > +	help
> > +	  This selects the Simplified Mandatory Access Control Kernel.
> > +	  Smack is useful for sensitivity, integrity, and a variety
> > +	  of other mandatory security schemes.
> > +	  If you are unsure how to answer this question, answer N.
> 
> Might point out that no other modules must be compiled in along with
> smack, and that smack will do posix capabilities.

Also a good idea.

> ...
> > +/**
> > + * smk_write_load - write() for /smack/load
> > + * @filp: file pointer, not actually used
> > + * @buf: where to get the data from
> > + * @count: bytes sent
> > + * @ppos: where to start
> > + *
> > + * Returns number of bytes written or error code, as appropriate
> > + */
> > +static ssize_t smk_write_load(struct file *file, const char __user *buf,
> > +			      size_t count, loff_t *ppos)
> > +{
> > +	struct smack_rule rule;
> > +	ssize_t rc = count;
> > +	char *data = NULL;
> > +	char subjectstr[SMK_LABELLEN];
> > +	char objectstr[SMK_LABELLEN];
> > +	char modestr[8];
> > +	char *cp;
> > +
> > +
> > +	if (!capable(CAP_MAC_OVERRIDE))
> > +		return -EPERM;
> > +	/*
> > +	 * No partial writes.
> > +	 */
> > +	if (*ppos != 0)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * 80 characters per line ought to be enough.
> > +	 */
> > +	if (count > SMACK_LIST_MAX * 80)
> > +		return -ENOMEM;
> > +
> > +	data = kzalloc(count + 1, GFP_KERNEL);
> > +	if (data == NULL)
> > +		return -ENOMEM;
> > +
> > +	if (copy_from_user(data, buf, count) != 0) {
> > +		kfree(data);
> > +		return -EFAULT;
> > +	}
> > +
> > +	*(data + count) = '\0';
> > +
> > +	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
> > +		if (*++cp == '\0')
> > +			break;
> > +		if (sscanf(cp, "%23s %23s %7s\n", subjectstr, objectstr,
> > +			   modestr) != 3) {
> > +			printk("%s:%d bad scan\n", __func__, __LINE__);
> > +			break;
> > +		}
> > +		rule.smk_subject = smk_import(subjectstr, 0);
> > +		if (rule.smk_subject == NULL)
> > +			break;
> > +		rule.smk_object = smk_import(objectstr, 0);
> > +		if (rule.smk_object == NULL)
> > +			break;
> > +		rule.smk_access = 0;
> > +		if (strpbrk(modestr, "rR") != NULL)
> > +			rule.smk_access |= MAY_READ;
> > +		if (strpbrk(modestr, "wW") != NULL)
> > +			rule.smk_access |= MAY_WRITE;
> > +		if (strpbrk(modestr, "xX") != NULL)
> > +			rule.smk_access |= MAY_EXEC;
> > +		if (strpbrk(modestr, "aA") != NULL)
> > +			rule.smk_access |= MAY_APPEND;
> > +		smk_set_access(&rule);
> > +		printk("%s:%d rule %s %s 0x%x\n", __func__, __LINE__,
> > +			(char *)rule.smk_subject, (char *)rule.smk_object,
> > +			rule.smk_access);
> 
> Are you sure this isn't something you'd like to really audit?
> 
> (Sorry if that's been asked before)

There is work required to audit, SELinux, and LSM that will be
required before Smack or any other module can really use audit
properly. Smack using audit would be nice, but there are already
interesting cases that don't require it. I have fixing up audit
on my todo list, and have made some proposals. It will require
a group effort between audit, SELinux, Smack, and LSM.

> ...
> > +#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
> 
> We're basically inevitably going to be switching to 64-bit caps
> "any day now".  Should we just go ahead and do it here?  Now
> maybe we should use a less contraversial name than 'mac override'
> like 'CAP_MAC_POLICY_ADMIN' :), but I guess CAP_MAC_OVERRIDE
> is honest.
> 
> (I had started a 64-bit caps patch, but then got stuck trying to
> decide whether something needed to be done about
> task_capability_lock...)
> 
> Well, I guess you wouldn't want to bog down your patch to
> that, but would you take your own bit once it was available,
> or are you happy just using CAP_LINUX_IMMUTABLE?

I would be delighted to have a bit of my very own. The granularity
advocates might suggest I use more than one.

Thank you for the comments.


Casey Schaufler
casey@schaufler-ca.com
