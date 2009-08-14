Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZHNCBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZHNCBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZHNCBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:01:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZHNCBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:01:33 -0400
Message-ID: <4A84C55A.40300@redhat.com>
Date: Fri, 14 Aug 2009 10:00:58 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: jmorris@namei.org, eparis@parisplace.org, sds@tycho.nsa.gov,
       serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: fix memory leak in sel_make_bools
References: <1250151976-19399-1-git-send-email-dfeng@redhat.com> <200908131455.15381.paul.moore@hp.com>
In-Reply-To: <200908131455.15381.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 02:55 AM, Paul Moore wrote:
> On Thursday 13 August 2009 04:26:16 am Xiaotian Feng wrote:
>> In sel_make_bools, kernel allocates memory for bool_pending_names[i]
>> with security_get_bools. So if we just free bool_pending_names, those
>> memories for bool_pending_names[i] will be leaked.
>>
>> This patch resolves dozens of following kmemleak report after resuming
>> from suspend:
>> unreferenced object 0xffff88022e4c7380 (size 32):
>>    comm "init", pid 1, jiffies 4294677173
>>    backtrace:
>>      [<ffffffff810f76b5>] create_object+0x1a2/0x2a9
>>      [<ffffffff810f78bb>] kmemleak_alloc+0x26/0x4b
>>      [<ffffffff810ef3eb>] __kmalloc+0x18f/0x1b8
>>      [<ffffffff811cd511>] security_get_bools+0xd7/0x16f
>>      [<ffffffff811c48c0>] sel_write_load+0x12e/0x62b
>>      [<ffffffff810f9a39>] vfs_write+0xae/0x10b
>>      [<ffffffff810f9b56>] sys_write+0x4a/0x6e
>>      [<ffffffff81011b82>] system_call_fastpath+0x16/0x1b
>>      [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>> ---
>>   security/selinux/selinuxfs.c |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
>> index b4fc506..ab93472 100644
>> --- a/security/selinux/selinuxfs.c
>> +++ b/security/selinux/selinuxfs.c
>> @@ -979,7 +979,11 @@ static int sel_make_bools(void)
>>   	u32 sid;
>>
>>   	/* remove any existing files */
>> -	kfree(bool_pending_names);
>> +	if (bool_pending_names) {
>> +		for (i = 0; i<  bool_num; i++)
>> +			kfree(bool_pending_names[i]);
>> +		kfree(bool_pending_names);
>> +	}
>>   	kfree(bool_pending_values);
>>   	bool_pending_names = NULL;
>>   	bool_pending_values = NULL;
>
> Since the code seems to rely on 'bool_num' in other places to ensure we don't
> walk off the end of the array it is probably safe to omit the 'if
> (bool_pending_names) ...' conditional and just rely on the for loop to do the
> right thing.
Thanks for point out, I'll resend V2 patch :-)

