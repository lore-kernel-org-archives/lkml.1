Return-Path: <linux-kernel-owner+w=401wt.eu-S935333AbZAPRH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333AbZAPRH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZAPRHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:07:47 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:32887 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZAPRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:07:46 -0500
Message-ID: <4970BE8F.9090705@oracle.com>
Date: Fri, 16 Jan 2009 09:06:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
Subject: Re: mmotm 2009-01-14-20-31 uploaded (gfs2)
References: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>	 <496F8AED.3020604@oracle.com>	 <1232101203.3554.3.camel@localhost.localdomain>	 <20090116084352.9f35b822.akpm@linux-foundation.org> <1232125371.9571.587.camel@quoit>
In-Reply-To: <1232125371.9571.587.camel@quoit>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4970BE93.00E2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Whitehouse wrote:
> Hi,
> 
> On Fri, 2009-01-16 at 08:43 -0800, Andrew Morton wrote:
>> On Fri, 16 Jan 2009 10:20:03 +0000 Steven Whitehouse <swhiteho@redhat.com> wrote:
>>
>>> Hi,
>>>
>>> On Thu, 2009-01-15 at 11:13 -0800, Randy Dunlap wrote:
>>>> akpm@linux-foundation.org wrote:
>>>>> The mm-of-the-moment snapshot 2009-01-14-20-31 has been uploaded to
>>>>>
>>>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>>>
>>>>> and will soon be available at
>>>>>
>>>>>    git://git.zen-sources.org/zen/mmotm.git
>>>>
>>>> when CONFIG_FILE_LOCKING=n:
>>>>
>>>> mmotm-2009-0114-2031/fs/gfs2/ops_file.c:746: error: 'generic_setlease' undeclared here (not in a function)
>>>>
>>>>
>>>> since generic_setlease() is a macro/define in that case.
>>>>
>>> Hmm, it looks like I'll have to do this, in that case:
>>>
>>> diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
>>> index 99d726f..4580335 100644
>>> --- a/fs/gfs2/ops_file.c
>>> +++ b/fs/gfs2/ops_file.c
>>> @@ -743,7 +743,9 @@ const struct file_operations *gfs2_file_fops_nolock = &(const struct file_operat
>>>  	.fsync		= gfs2_fsync,
>>>  	.splice_read	= generic_file_splice_read,
>>>  	.splice_write	= generic_file_splice_write,
>>> +#ifdef CONFIG_FILE_LOCKING
>>>  	.setlease	= generic_setlease,
>>> +#endif /* CONFIG_FILE_LOCKING */
>>>  };
>>>  
>>>  const struct file_operations *gfs2_dir_fops_nolock = &(const struct file_operations){
>>>
>>>
>>> which is not ideal, but I don't see any easy way to avoid the #ifdef,
>>>
>> Take a look in fs.h:
>>
>> #define generic_setlease(a, b, c) ({ -EINVAL; })
>>
>> If that wasn't a stupid macro, your code would have compiled and ran
>> just as intended.
>>
> There doesn't seem to be an easy answer though. If I #define it to NULL,
> that upsets other parts of the code that rely on that macro, and if I
> turn it into a inline function which returns -EINVAL, then presumably I
> can't take its address for my file_operations.

No, gcc will allow &inline_func and out-of-line it if it is needed (AFAIK;
I've seen a few cases of that).

> I could create a small function which then calls generic_setlease I
> suppose, but is that any better than this? Its not really very neat
> which ever I choose :(


-- 
~Randy
