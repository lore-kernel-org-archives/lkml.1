Return-Path: <linux-kernel-owner+w=401wt.eu-S1763894AbYCFTQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763894AbYCFTQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYCFTQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:16:14 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYCFTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:16:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=CdvzQPJcgBlcE1/3AO8sqq5HF5A7TNKdr5ji01d/GLHKN9ki/cbpOXCGoEsMVRMcS
	JcMDCJlvzr3DmSTBdnNag==
Date: Thu, 6 Mar 2008 11:10:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot
 time
In-Reply-To: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>
Message-ID: <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com>
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Balbir Singh wrote:

> @@ -3010,3 +3020,16 @@ static void cgroup_release_agent(struct 
>  	spin_unlock(&release_list_lock);
>  	mutex_unlock(&cgroup_mutex);
>  }
> +
> +static int __init cgroup_disable(char *str)
> +{
> +	int i;
> +	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +		struct cgroup_subsys *ss = subsys[i];
> +		if (!strcmp(str, ss->name)) {
> +			ss->disabled = 1;
> +			break;
> +		}
> +	}
> +}
> +__setup("cgroup_disable=", cgroup_disable);

This doesn't handle spaces very well, so isn't it possible for the name of 
a current or future cgroup subsystem to be specified after cgroup_disable= 
on the command line and have it disabled by accident?

> diff -puN Documentation/kernel-parameters.txt~cgroup_disable Documentation/kernel-parameters.txt
> --- linux-2.6.25-rc4/Documentation/kernel-parameters.txt~cgroup_disable	2008-03-06 17:57:32.000000000 +0530
> +++ linux-2.6.25-rc4-balbir/Documentation/kernel-parameters.txt	2008-03-06 18:00:32.000000000 +0530
> @@ -383,6 +383,10 @@ and is between 256 and 4096 characters. 
>  	ccw_timeout_log [S390]
>  			See Documentation/s390/CommonIO for details.
>  
> +	cgroup_disable= [KNL] Enable disable a particular controller
> +			Format: {name of the controller}
> +			See /proc/cgroups for a list of compiled controllers
> +

This works on multiple controllers, though, if they follow 
cgroup_disable=, so the documentation and format should reflect that.
