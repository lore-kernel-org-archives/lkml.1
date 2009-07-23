Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZGWG11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZGWG11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZGWG11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:27:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZGWG10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:27:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=sVdWhdxXiyOo6/hJj/njsr5F/asbUrgNfNnH9qboMnLfiZ1LXSM5jE/BwUUPKsUmP
	2Q5OeK6vKvp5Ai0xc8hPA==
MIME-Version: 1.0
In-Reply-To: <4A68013A.2020302@cn.fujitsu.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
	 <20090722195029.7481.94700.stgit@menage.mtv.corp.google.com>
	 <4A68013A.2020302@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 23:27:23 -0700
Message-ID: <6599ad830907222327s31340956y9783db39d076520f@mail.gmail.com>
Subject: Re: [PATCH 1/4] Support named cgroups hierarchies
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:20 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> +The name should match [\w.-]+
>> +
>
> "[\w._-]+" ?
>
> But I double we need to check this.

\w includes '_'

>>  static int cgroup_set_super(struct super_block *sb, void *data)
>>  {
>>       int ret;
>> -     struct cgroupfs_root *root = data;
>> +     struct cgroup_sb_opts *opts = data;
>> +
>> +     /* If we don't have a new root, we can't set up a new sb */
>> +     if (!opts->new_root)
>> +             return -EINVAL;
>> +
>
> I think this should be BUG_ON(). If set_super() is called,
> we are allocating a new root, so opts->new_root won't be NULL.

Not true - if you try to mount a hierarchy by name, but with no
subsystem options, then we don't construct a new root, but we still
call sget(). If we find a superblock with the right name then we use
it, else sget() will allocate a new superblock and call
cgroup_set_super(), at which point we need to fail.

>
>> +             struct cgroupfs_root *new_root = cgroup_root_from_opts(&opts);
>
> Why not just declare new_root in the beginning of cgroup_get_sb()?

Because it's not needed for the entire scope of the function. Keeping
its scope as small as possible makes it clearer what it's being used
for.

Paul
