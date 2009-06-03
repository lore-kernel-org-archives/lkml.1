Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZFCO4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZFCO4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZFCOz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:55:58 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52041 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZFCOz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:55:57 -0400
X-Greylist: delayed 1352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 10:55:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=clxqS33ZJEdtD1HQ54xla99LE48z1HNojV22y0ibf+KrkkSDQaGa18uyrDLVsnLf+u
         Uc17T7iZ6NcO//S1eQlycAWO6Gpj1fzMUGm5gLDL8lYszY2A1fP3mhnrDQOMg5a/EXzq
         eg7tdCbNZF6z3bmrCdsn3NBq1fSTasKUm4guY=
MIME-Version: 1.0
In-Reply-To: <20090603142908.GJ5736@alberich.amd.com>
References: <20090603142727.GI5736@alberich.amd.com>
	 <20090603142908.GJ5736@alberich.amd.com>
Date: Wed, 3 Jun 2009 16:33:25 +0200
Message-ID: <36ca99e90906030733o14a84043ma8e83f6451e78895@mail.gmail.com>
Subject: Re: [PATCH 1/5] topology: introduce cpu_node information for 
	multi-node processors
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 16:29, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
>
> New topology attributes are
> - cpu_node_id (id of the internal node)
> - cpu_node_siblings and cpu_node_siblings_list
>  (siblings on the same internal node)
Looks good. Thank you.

Acked-by: Bert.Wesarg@googlemail.com

>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/base/topology.c  |   10 ++++++++++
>  include/linux/topology.h |    9 +++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/topology.c b/drivers/base/topology.c
> index bf6b132..1e35a43 100644
> --- a/drivers/base/topology.c
> +++ b/drivers/base/topology.c
> @@ -103,6 +103,9 @@ static ssize_t show_##name##_list(struct sys_device *dev,           \
>  define_id_show_func(physical_package_id);
>  define_one_ro(physical_package_id);
>
> +define_id_show_func(cpu_node_id);
> +define_one_ro(cpu_node_id);
> +
>  define_id_show_func(core_id);
>  define_one_ro(core_id);
>
> @@ -110,6 +113,10 @@ define_siblings_show_func(thread_cpumask);
>  define_one_ro_named(thread_siblings, show_thread_cpumask);
>  define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
>
> +define_siblings_show_func(cpu_node_cpumask);
> +define_one_ro_named(cpu_node_siblings, show_cpu_node_cpumask);
> +define_one_ro_named(cpu_node_siblings_list, show_cpu_node_cpumask_list);
> +
>  define_siblings_show_func(core_cpumask);
>  define_one_ro_named(core_siblings, show_core_cpumask);
>  define_one_ro_named(core_siblings_list, show_core_cpumask_list);
> @@ -119,6 +126,9 @@ static struct attribute *default_attrs[] = {
>        &attr_core_id.attr,
>        &attr_thread_siblings.attr,
>        &attr_thread_siblings_list.attr,
> +       &attr_cpu_node_id.attr,
> +       &attr_cpu_node_siblings.attr,
> +       &attr_cpu_node_siblings_list.attr,
>        &attr_core_siblings.attr,
>        &attr_core_siblings_list.attr,
>        NULL
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 7402c1a..976a130 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -180,6 +180,9 @@ int arch_update_cpu_topology(void);
>  #ifndef topology_physical_package_id
>  #define topology_physical_package_id(cpu)      ((void)(cpu), -1)
>  #endif
> +#ifndef topology_cpu_node_id
> +#define topology_cpu_node_id(cpu)              ((void)(cpu), 0)
> +#endif
>  #ifndef topology_core_id
>  #define topology_core_id(cpu)                  ((void)(cpu), 0)
>  #endif
> @@ -189,12 +192,18 @@ int arch_update_cpu_topology(void);
>  #ifndef topology_core_siblings
>  #define topology_core_siblings(cpu)            cpumask_of_cpu(cpu)
>  #endif
> +#ifndef topology_cpu_node_siblings
> +#define topology_cpu_node_siblings(cpu)                topology_core_siblings(cpu)
> +#endif
>  #ifndef topology_thread_cpumask
>  #define topology_thread_cpumask(cpu)           cpumask_of(cpu)
>  #endif
>  #ifndef topology_core_cpumask
>  #define topology_core_cpumask(cpu)             cpumask_of(cpu)
>  #endif
> +#ifndef topology_cpu_node_cpumask
> +#define topology_cpu_node_cpumask(cpu)         topology_core_cpumask(cpu)
> +#endif
>
>  /* Returns the number of the current Node. */
>  #ifndef numa_node_id
> --
> 1.6.3.1
>
>
>
>
