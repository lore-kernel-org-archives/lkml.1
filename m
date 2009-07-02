Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZGBCuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZGBCuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZGBCtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:49:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24412 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZGBCtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:49:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ugvGJv2dX8aYkc7XW/sFRhNrje5K+MYCg0lnAJSjpnWB5tIiwny43oImbCPhXQLaD
	VRwaMpQrD3qjQxIOP1HXQ==
MIME-Version: 1.0
In-Reply-To: <20090702112814.ddf0c280.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
	 <20090702112814.ddf0c280.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Jul 2009 19:49:48 -0700
Message-ID: <6599ad830907011949h13598e36m45b85ae76900b90a@mail.gmail.com>
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 7:28 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Open issues:
>>
>> - should the specification be via a name= option as in this patch, or
>>   should we simply use the "device name" as passed to the mount()
>>   system call?  Using the device name is more conceptually clean and
>>   consistent with the filesystem API; however, given that the device
>>   name is currently ignored by cgroups, this would lead to a
>>   user-visible behaviour change.
>>
>
> IMHO, name= option is good because people think device name for pseudo file
> system has no meanings. I think just leaving it as "no meaning" is better.
>

Yes, I guess that makes sense. That was Li Zefan's opinion too.

>>
>> +#define MAX_CGROUP_ROOT_NAMELEN 64
>> +
>
> I don't like long names but....isn't this too short ? How about NAME_MAX ?
>


>
>>  /*
>>   * A cgroupfs_root represents the root of a cgroup hierarchy,
>>   * and may be associated with a superblock to form an active
>> @@ -93,6 +95,9 @@ struct cgroupfs_root {
>>
>>       /* The path to use for release notifications. */
>>       char release_agent_path[PATH_MAX];
>> +
>> +     /* The name for this hierarchy - may be empty */
>> +     char name[MAX_CGROUP_ROOT_NAMELEN];
>>  };
>>
> If you don't want to make cgroupfs_root bigger,
>
>        cgroupfs_root {
>                ......
>                /* this must be the bottom of struct */
>                char name[0];
>        }
>
> Is a choice.

I'd rather avoid something like that since I think it's less readable
- I'd probably just make the name into a pointer in that case.

>
> BTW, reading a patch, any kind of charactors are allowed ?

Yes, other than \000 of course. I guess maybe I should use
seq_escape() to print the name to avoid confusion in the event that
people put whitespace in there, or else just ban whitespace (or maybe
all non-alphanumeric chars).

Paul
