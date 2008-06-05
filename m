Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYFEErp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYFEErp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 00:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYFEEri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 00:47:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYFEErh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 00:47:37 -0400
Date: Wed, 4 Jun 2008 21:47:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information
 [4th try]
Message-Id: <20080604214715.bbebe325.akpm@linux-foundation.org>
In-Reply-To: <20080604154454.GD11300@solarflare.com>
References: <20080604154454.GD11300@solarflare.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 16:44:56 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:

> Not all architectures and configurations define CPU topology information.
> This can result in an empty topology directory in sysfs, and requires
> in-kernel users to protect all uses with #ifdef - see
> <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> 
> The documentation of CPU topology specifies what the defaults should be
> if only partial information is available from the hardware.  So we can
> provide these defaults as a fallback.
> 
> This patch:
> 
> - Adds default definitions of the 4 topology macros to <linux/topology.h>
> - Changes drivers/base/topology.c to use the topology macros unconditionally
>   and to cope with definitions that aren't lvalues
> - Updates documentation accordingly

See, this is what I meant.  After your patch we have:

#ifdef arch_provides_topology_pointers
#define define_siblings_show_map(name)					\
static ssize_t show_##name(struct sys_device *dev, char *buf)	\
{									\
	unsigned int cpu = dev->id;					\
	cpumask_t siblings = topology_##name(cpu);			\
	return show_cpumap(0, &siblings, buf);				\
}

#define define_siblings_show_list(name)					\
static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
{									\
	unsigned int cpu = dev->id;					\
	cpumask_t siblings = topology_##name(cpu);			\
	return show_cpumap(1, &siblings, buf);				\
}

#else
#define define_siblings_show_map(name)					\
static ssize_t show_##name(struct sys_device *dev, char *buf)	\
{									\
	unsigned int cpu = dev->id;					\
	cpumask_t mask = topology_##name(cpu);				\
	return show_cpumap(0, &mask, buf);				\
}

#define define_siblings_show_list(name)					\
static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
{									\
	unsigned int cpu = dev->id;					\
	cpumask_t mask = topology_##name(cpu);				\
	return show_cpumap(1, &mask, buf);				\
}
#endif

they're the same!
