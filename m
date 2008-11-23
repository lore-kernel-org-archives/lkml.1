Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYKWLEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYKWLEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYKWLEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:04:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:9567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbYKWLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MmRKKzwsu4vXmf6bS0V1TzN63d5UF+w/AgdRFiYPoXZRfIcJUCzsHodLWhGkcE3qud
         oaCvWDBjGvXCKJwqBIYH+v5StznOEIcsU+rGG+owP8UdO3MCQ1XJcl5vzjEhJuqk0FHT
         mSob+zu3PMnsFfvC23b3PijN9zu55wBWoLnY8=
Message-ID: <492938A4.9020502@gmail.com>
Date: Sun, 23 Nov 2008 13:04:04 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/3] tracing/stack-tracer: fix locking
References: <20081123085310.GF30453@elte.hu> <1227436748-17075-2-git-send-email-edwintorok@gmail.com> <20081123105211.GC30453@elte.hu> <49293777.8070404@gmail.com> <20081123110114.GD30453@elte.hu>
In-Reply-To: <20081123110114.GD30453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-23 13:01, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> On 2008-11-23 12:52, Ingo Molnar wrote:
>>     
>>> * Török Edwin <edwintorok@gmail.com> wrote:
>>>
>>>   
>>>       
>>>> +		down_read(&mm->mmap_sem);
>>>> +		vma = find_vma(mm, ip);
>>>>  		if (vma) {
>>>>  			file = vma->vm_file;
>>>>  			vmstart = vma->vm_start;
>>>>  		}
>>>> +		up_read(&mm->mmap_sem);
>>>>  	}
>>>>  	if (file) {
>>>>  		ret = trace_seq_path(s, &file->f_path);
>>>>     
>>>>         
>>> and now it's "file" that is held without a reference and possibly 
>>> racy.
>>>   
>>>       
>> I'll move the (file) inside the mmap_sem too, since file is part of 
>> vma, and you need mmap_sem to access the vma nobody can modify 
>> (file) if they don't hold mmap_sem. Am I right?
>>     
>
> yeah - you can use the mm lock for that as the vma holds a reference 
> to the file. This works as long as none of the seq functions called 
> with this lock held can provoke a user pagefault (they shouldnt, but i 
> havent checked in detail).
>   

It calls d_path, that access only kernel structures AFAICT, so it can't
provoke a *user* pagefault.
Not sure about kernel pagefaults, but they shouldn't matter.

Best regards,
--Edwin
