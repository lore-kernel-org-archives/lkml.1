Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbYFKHtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbYFKHtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYFKHtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:49:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:47137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYFKHtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=gZOKZr2xbB2sOt5w9l+qfyHvVdHyfUdAVlE4yW0v9iFKGyWPFYMp7FfFsd2WNrm+Qo
         Yvvzm4wKYjzfxcxvyFvC18E9EC1rjsPSvO6CotWdiBeXaac/mdyvTlGNew7Ar+jnp/lR
         BeVOeQT5hdszJud1XjKkpZ4FNaWFobXM6nPC8=
Message-ID: <7c86c4470806110049g76247b4ex5e1b77af78d8dd7c@mail.gmail.com>
Date: Wed, 11 Jun 2008 09:49:44 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch 02/21] perfmon2 minimal: generic headers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080610072914.3b6b2cfe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484dafc4.0af6660a.54fb.1b26@mx.google.com>
	 <20080610072914.3b6b2cfe@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,


On Tue, Jun 10, 2008 at 4:29 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 09 Jun 2008 15:33:40 -0700 (PDT)
> eranian@googlemail.com wrote:
>
>> +#ifndef __LINUX_PERFMON_H__
>> +#define __LINUX_PERFMON_H__
>> +
>> +/*
>> + * This file contains all the user visible generic definitions for
>> the
>> + * interface. Model-specific user-visible definitions are located in
>> + * the asm/perfmon.h file.
>> + */
>> + */
>> +#define PFM_BVSIZE(x)        (((x)+(sizeof(u64)<<3)-1) /
>> (sizeof(u64)<<3)) +#define PFM_PMD_BV PFM_BVSIZE(PFM_MAX_PMDS)
>
> can't use u64 in userspace headers; must use __u64
>
>
Will fix that.


>> + * default value for the user and group security parameters in
>> + * /proc/sys/kernel/perfmon/sys_group
>> + * /proc/sys/kernel/perfmon/task_group
>
> hmmm that smells funky.
>
Will clarify this.


>> +/*
>> + * perfmon version number
>> + */
>> +#define PFM_VERSION_MAJ               2U
>> +#define PFM_VERSION_MIN               99U
>> +#define PFM_VERSION           (((PFM_VERSION_MAJ&0xffff)<<16)|\
>> +                               (PFM_VERSION_MIN & 0xffff))
>> +#define PFM_VERSION_MAJOR(x)  (((x)>>16) & 0xffff)
>> +#define PFM_VERSION_MINOR(x)  ((x) & 0xffff)
>
> I'm very nervous when seeing something like this in userspace headers;
> you need to assume that the app has been compiled with a very different
> version of the headers than the currently running kernel.... either the
> version of perfmon doesn't matter, in which case these don't belong
> here, or it does and it should be a runtime query.
>
I think you bring up a good point. There is indeed a way of querying the version
via /sysfs.

However the question is how does an application know which API version
it was compiled
for, so it can compare with what it finds in /sysfs? That ought to be
somewhere in the
public headers that the application was compiled with.


>
>
>> +#ifndef __LINUX_PERFMON_KERN_H__
>> +#define __LINUX_PERFMON_KERN_H__
>> +/*
>> + * This file contains all the definitions of data structures,
>> variables, macros
>> + * that are to be shared between generic code and arch-specific code
>> + *
>> + * For generic only definitions, use perfmon/perfmon_priv.h
>> + */
>> +#ifdef __KERNEL__
>
> no need for #ifdef __KERNEL__, just don't expose the header to
> userspace.
>
You are right. Will remove that.

>> +/*
>> + * logging
>> + */
>> +#define PFM_ERR(f, x...)  printk(KERN_ERR     "perfmon: " f "\n", ##
>> x) +#define PFM_WARN(f, x...) printk(KERN_WARNING "perfmon: " f "\n",
>> ## x) +#define PFM_LOG(f, x...)  printk(KERN_NOTICE  "perfmon: " f
>> "\n", ## x) +#define PFM_INFO(f, x...) printk(KERN_INFO    "perfmon:
>> " f "\n", ## x) +
>
> hmmm what's wrong with the current set of macros the kernel has for
> these?
>
I think these simply prefix the message with "perfmon:" so you know
which subsystems the messages are from.
You do it in one place instead of duplicating the "perfmon: " string everywhere.
