Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYDHO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYDHO5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYDHO5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:57:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYDHO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:57:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DcirP2sKUmVXitdy9KNOw3qftA58mXMZ3qUvlyzc84c6RZXCoKbE9xIyByW4xF+v1
	/pqjdk6kdP/QlqE0IJhYA==
Message-ID: <6599ad830804080757w7942e4ddtc1381230541613a2@mail.gmail.com>
Date: Tue, 8 Apr 2008 07:57:15 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Disable the memory controller by default (v3)
Cc: andi@firstfloor.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Pavel Emelianov" <xemul@openvz.org>, hugh@veritas.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080408114613.8165.69030.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408114613.8165.69030.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 4:46 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  If everyone agrees on this approach and likes it, should we push this
>  into 2.6.25?
>
>  Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Looks good to me - although I wouldn't bother with the "inline" on
cgroup_turnonoff()

Acked-by: Paul Menage <menage@google.com>

>  ---
>
>   Documentation/kernel-parameters.txt |    3 +++
>   kernel/cgroup.c                     |   17 +++++++++++++----
>   mm/memcontrol.c                     |    1 +
>   3 files changed, 17 insertions(+), 4 deletions(-)
>
>  diff -puN kernel/cgroup.c~memory-controller-default-option-off kernel/cgroup.c
>  --- linux-2.6.25-rc8/kernel/cgroup.c~memory-controller-default-option-off       2008-04-07 16:24:28.000000000 +0530
>  +++ linux-2.6.25-rc8-balbir/kernel/cgroup.c     2008-04-08 16:04:49.000000000 +0530
>  @@ -3063,7 +3063,7 @@ static void cgroup_release_agent(struct
>         mutex_unlock(&cgroup_mutex);
>   }
>
>  -static int __init cgroup_disable(char *str)
>  +static inline int __init cgroup_turnonoff(char *str, int disable)
>   {
>         int i;
>         char *token;
>  @@ -3076,13 +3076,22 @@ static int __init cgroup_disable(char *s
>                         struct cgroup_subsys *ss = subsys[i];
>
>                         if (!strcmp(token, ss->name)) {
>  -                               ss->disabled = 1;
>  -                               printk(KERN_INFO "Disabling %s control group"
>  -                                       " subsystem\n", ss->name);
>  +                               ss->disabled = disable;
>                                 break;
>                         }
>                 }
>         }
>         return 1;
>   }
>  +
>  +static int __init cgroup_disable(char *str)
>  +{
>  +       return cgroup_turnonoff(str, 1);
>  +}
>   __setup("cgroup_disable=", cgroup_disable);
>  +
>  +static int __init cgroup_enable(char *str)
>  +{
>  +       return cgroup_turnonoff(str, 0);
>  +}
>  +__setup("cgroup_enable=", cgroup_enable);
>  diff -puN mm/memcontrol.c~memory-controller-default-option-off mm/memcontrol.c
>  --- linux-2.6.25-rc8/mm/memcontrol.c~memory-controller-default-option-off       2008-04-07 16:24:28.000000000 +0530
>  +++ linux-2.6.25-rc8-balbir/mm/memcontrol.c     2008-04-07 16:40:22.000000000 +0530
>  @@ -1104,4 +1104,5 @@ struct cgroup_subsys mem_cgroup_subsys =
>         .populate = mem_cgroup_populate,
>         .attach = mem_cgroup_move_task,
>         .early_init = 0,
>  +       .disabled = 1,
>   };
>  diff -puN Documentation/kernel-parameters.txt~memory-controller-default-option-off Documentation/kernel-parameters.txt
>  --- linux-2.6.25-rc8/Documentation/kernel-parameters.txt~memory-controller-default-option-off   2008-04-07 16:38:25.000000000 +0530
>  +++ linux-2.6.25-rc8-balbir/Documentation/kernel-parameters.txt 2008-04-07 17:53:28.000000000 +0530
>  @@ -382,8 +382,11 @@ and is between 256 and 4096 characters.
>                         See Documentation/s390/CommonIO for details.
>
>         cgroup_disable= [KNL] Disable a particular controller
>  +       cgroup_enable=  [KNL] Enable a particular controller
>  +                       For both cgroup_enable and cgroup_enable
>                         Format: {name of the controller(s) to disable}
>                                 {Currently supported controllers - "memory"}
>  +                               {Memory controller is disabled by default}
>
>         checkreqprot    [SELINUX] Set initial checkreqprot flag value.
>                         Format: { "0" | "1" }
>  _
>
>  --
>         Warm Regards,
>         Balbir Singh
>         Linux Technology Center
>         IBM, ISTL
>
