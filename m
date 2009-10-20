Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZJTDSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZJTDSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 23:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZJTDSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 23:18:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50198 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZJTDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 23:18:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qDzj+P3DayGu7Ejnc1kKXu1NICZaQDYnbjXRzYeMtaedE1rTX+Ds8A5KDKofVbNCT
	YCWSKGpBKpV3lLy93QG+Q==
Date: Mon, 19 Oct 2009 20:18:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: add numa node symlink for cpu devices in sysfs
In-Reply-To: <20091019213430.32729.78995.stgit@bob.kio>
Message-ID: <alpine.DEB.1.00.0910192016010.25264@chino.kir.corp.google.com>
References: <20091019212740.32729.7171.stgit@bob.kio> <20091019213430.32729.78995.stgit@bob.kio>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Alex Chiang wrote:

> You can discover which CPUs belong to a NUMA node by examining
> /sys/devices/system/node/$node/
> 

You mean /sys/devices/system/node/node# ?

> However, it's not convenient to go in the other direction, when looking at
> /sys/devices/system/cpu/$cpu/
> 

.../cpu/cpu# ?

> Yes, you can muck about in sysfs, but adding these symlinks makes
> life a lot more convenient.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/base/node.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index ffda067..47a4997 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -227,6 +227,7 @@ struct node node_devices[MAX_NUMNODES];
>   */
>  int register_cpu_under_node(unsigned int cpu, unsigned int nid)
>  {
> +	int ret;
>  	struct sys_device *obj;
>  
>  	if (!node_online(nid))
> @@ -236,9 +237,13 @@ int register_cpu_under_node(unsigned int cpu, unsigned int nid)
>  	if (!obj)
>  		return 0;
>  
> -	return sysfs_create_link(&node_devices[nid].sysdev.kobj,
> +	ret = sysfs_create_link(&node_devices[nid].sysdev.kobj,
>  				&obj->kobj,
>  				kobject_name(&obj->kobj));
> +
> +	return sysfs_create_link(&obj->kobj,
> +				 &node_devices[nid].sysdev.kobj,
> +				 kobject_name(&node_devices[nid].sysdev.kobj));
>  }
>  
>  int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)

That can't be right, you're ignoring the return value of the first 
sysfs_create_link().

The return values of register_cpu_under_node() and 
unregister_cpu_under_node() are always ignored, so it would probably be 
best to convert these to be void functions.  That doesn't mean you can 
simply ignore the result of the first sysfs_create_link(), though: the 
second should probably be suppressed if the first returns an error.
