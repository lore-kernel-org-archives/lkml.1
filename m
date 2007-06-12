Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXFLHu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXFLHu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXFLHuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:50:16 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:39905 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXFLHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:50:15 -0400
Message-ID: <466E4FF6.8040709@free.fr>
Date: Tue, 12 Jun 2007 09:49:10 +0200
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: PATCH -mm] fix create_new_namespaces() return value
References: <466D5830.9010200@fr.ibm.com> <466D76DC.7020900@us.ibm.com>
In-Reply-To: <466D76DC.7020900@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> 
> 
> Cedric Le Goater wrote:
> 
>> The following patch modifies create_new_namespaces() to also use the
>> errors returned by the copy_*_ns routines and not to systematically
>> return ENOMEM.
>>
> 
> In my initial version, I did same. It doesn't work :(
> 
> copy_*_ns() routines doesn't return any errors. All they return is NULL
> in case of a
> failure + with the exception of copy_mnt_ns, there are no other failure
> cases.

mnt ant uts namespaces return NULL right but this is not true for ipc namespace 
which returns -ENOMEM. user namespace returns -EINVAL if CONFIG_USER_NS is not 
selected. I expect pid namespace to do same and net namespace to do even more.

> So, there is no way to find out why the copy_*_ns() routines failed from
> create_new_namespaces().
> If you really really want to do this, change all copy_*_ns() routines to
> returns meaningful errors instead of NULL.

I will certainly do and change mnt ant uts namespaces to return -ENOMEM but
we will still require the patch below.

>> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
>> Cc: Serge E. Hallyn <serue@us.ibm.com>
>> Cc: Badari Pulavarty <pbadari@us.ibm.com>
>> Cc: Pavel Emelianov <xemul@openvz.org>
>> Cc: Herbert Poetzl <herbert@13thfloor.at>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>> kernel/nsproxy.c |   23 +++++++++++++++++------
>> 1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> Index: 2.6.22-rc4-mm2/kernel/nsproxy.c
>> ===================================================================
>> --- 2.6.22-rc4-mm2.orig/kernel/nsproxy.c
>> +++ 2.6.22-rc4-mm2/kernel/nsproxy.c
>> @@ -58,30 +58,41 @@ static struct nsproxy *create_new_namesp
>>             struct fs_struct *new_fs)
>> {
>>     struct nsproxy *new_nsp;
>> +    int err;
>>
>>     new_nsp = clone_nsproxy(tsk->nsproxy);
>>     if (!new_nsp)
>>         return ERR_PTR(-ENOMEM);
>>
>>     new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, new_fs);
>> -    if (IS_ERR(new_nsp->mnt_ns))
>> +    if (IS_ERR(new_nsp->mnt_ns)) {
>> +        err = PTR_ERR(new_nsp->mnt_ns);
>>         goto out_ns;
>> +    }
>>
>>     new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns);
>> -    if (IS_ERR(new_nsp->uts_ns))
>> +    if (IS_ERR(new_nsp->uts_ns)) {
>> +        err = PTR_ERR(new_nsp->uts_ns);
>>         goto out_uts;
>> +    }
>>
>>     new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
>> -    if (IS_ERR(new_nsp->ipc_ns))
>> +    if (IS_ERR(new_nsp->ipc_ns)) {
>> +        err = PTR_ERR(new_nsp->ipc_ns);
>>         goto out_ipc;
>> +    }
>>
>>     new_nsp->pid_ns = copy_pid_ns(flags, tsk->nsproxy->pid_ns);
>> -    if (IS_ERR(new_nsp->pid_ns))
>> +    if (IS_ERR(new_nsp->pid_ns)) {
>> +        err = PTR_ERR(new_nsp->pid_ns);
>>         goto out_pid;
>> +    }
>>
>>     new_nsp->user_ns = copy_user_ns(flags, tsk->nsproxy->user_ns);
>> -    if (IS_ERR(new_nsp->user_ns))
>> +    if (IS_ERR(new_nsp->user_ns)) {
>> +        err = PTR_ERR(new_nsp->user_ns);
>>
> Hmm.. copy_user_ns() ? I don't see this in rc4-mm2.

it's in the -mm stack.

C. 
