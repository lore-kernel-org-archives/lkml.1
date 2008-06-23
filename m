Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYFWCSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYFWCSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYFWCSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:18:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:48812 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYFWCSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ei9VjrDBFXGmW2IzZqvxgTSs/UG2I/gQ4RO2loNZsiTizWfK3W7idUQIZbjmtBq6d2
         7GxpUyKV7twk4hIbW+r/+a+7N85avUmdXlM94SoZdUcSWncZSKGAiG+slI6hYu2ay+Op
         gg1n/YZy4f5/qGyKkJ9qsw6qYJxsDEGVVWOcw=
Message-ID: <485F07E4.4020400@gmail.com>
Date: Mon, 23 Jun 2008 11:18:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Benjamin Thery <benjamin.thery@bull.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 10/11] netns: Enable tagging for net_class directories
 in sysfs
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170731.597904070@theryb.frec.bull.fr>
In-Reply-To: <20080618170731.597904070@theryb.frec.bull.fr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery wrote:
> --- linux-mm.orig/fs/sysfs/mount.c
> +++ linux-mm/fs/sysfs/mount.c
> @@ -16,6 +16,8 @@
>  #include <linux/mount.h>
>  #include <linux/pagemap.h>
>  #include <linux/init.h>
> +#include <linux/nsproxy.h>
> +#include <net/net_namespace.h>
>  
>  #include "sysfs.h"
>  
> @@ -78,6 +80,7 @@ static int sysfs_fill_super(struct super
>  	root->d_sb = sb;
>  	sb->s_root = root;
>  	sb->s_fs_info = info;
> +	info->tag.net_ns = hold_net(current->nsproxy->net_ns);
>  	return 0;
>  
>  out_err:
> @@ -95,6 +98,9 @@ static int sysfs_test_super(struct super
>  	struct sysfs_super_info *info = sysfs_info(sb);
>  	int found = 1;
>  
> +	if (task->nsproxy->net_ns != info->tag.net_ns)
> +		found = 0;
> +
>  	return found;
>  }
>  
> @@ -131,6 +137,8 @@ static void sysfs_kill_sb(struct super_b
>  	struct sysfs_super_info *info = sysfs_info(sb);
>  
>  	kill_anon_super(sb);
> +	if (info->tag.net_ns)
> +		release_net(info->tag.net_ns);
>  	kfree(info);
>  }

Ouch... Please don't hard code net_ns functions directly from sysfs.
Please make a proper abstraction for ns, make net_ns register it and
sysfs test the abstract ns.

Thanks.

-- 
tejun
