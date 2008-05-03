Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYECOf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYECOf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYECOfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:35:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:55441 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbYECOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=s/EZFO2nQp75XqZiu0fHNn/JChJaaTpHT7DKI7NzkO/HxJNDYmS6wWwpayhKqfQ5ODQWrxCnLoKIjaAvWPTCi3Ok/rJeSRF4p2lPHDJoTcrzh30gJrHp38pR41CgSgtB6If8UT8qS3BPG+bJ/aizgcng7TKYeszvaT7f0vpMfv4=
Date: Sat, 3 May 2008 22:39:43 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Eric Youngdale <ericy@cais.com>, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] fs/binfmt_elf.c: fix a wrong free
Message-ID: <20080503143942.GE3986@hack>
References: <20080503124610.GA3986@hack> <Pine.LNX.4.64.0805031625150.20470@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805031625150.20470@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 04:26:11PM +0300, Pekka J Enberg wrote:
>On Sat, 3 May 2008, WANG Cong wrote:
>> Fix a wrong free in fs/binfmt_elf.c::elf_core_dump().
>> 
>> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Eric Youngdale <ericy@cais.com>
>> 
>> ---
>>  fs/binfmt_elf.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index b25707f..43254e3 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -2032,10 +2032,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>>  
>>  end_coredump:
>>  	set_fs(fs);
>> +	free_note_info(&info);
>>  
>>  cleanup:
>>  	kfree(elf);
>> -	free_note_info(&info);
>>  	return has_dumped;
>>  }
>
>Looks like fill_note_info() requires that you call free_note_info() if it 
>fails; otherwise we'll leak memory. So perhaps something like the 
>following totally untested patch?
>

Hi, Pekka!

Thanks for your comments. Yes, it seems that fill_note_info() is ugly.
:-) How about the below one?

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f6d5a9d..357b503 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1900,7 +1900,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
-		goto cleanup;
+		goto ret;
 	
 	segs = current->mm->map_count;
 #ifdef ELF_CORE_EXTRA_PHDRS
@@ -2034,8 +2034,9 @@ end_coredump:
 	set_fs(fs);
 
 cleanup:
-	kfree(elf);
 	free_note_info(&info);
+	kfree(elf);
+ret:
 	return has_dumped;
 }
 

