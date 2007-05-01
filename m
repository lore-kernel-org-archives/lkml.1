Return-Path: <linux-kernel-owner+w=401wt.eu-S1423799AbXEAFml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423799AbXEAFml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946592AbXEAFml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:42:41 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:39758 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423799AbXEAFmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:42:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=1F+K0puxMKHYvmzCnJJBX83WaL6gL9mECAT9TACPEF1SDB/oZutDBDthzJgI1OCF46ZrvtF6Z8zO2NH2WA/ogzd91ETtBxBpqjxeLVQc/N27niMUhwEwMy3ZS3hjTUaS1n9vDKcl1LgEPscFYm3ZWuGBcNVIetTFXVCc+juYS4M=  ;
X-YMail-OSG: md9_N7YVM1k7ZmQK5HSygVMkQYbigqAUeqSw3N5u5XGU7l9C59jFJLDXdCUByCDWYY0PbA5KkYhj5aMo5s9lbKhZpB5Dabz7ATkY0rhBIM2M9x_HK9U-
Message-ID: <4636D346.2010507@yahoo.com.au>
Date: Tue, 01 May 2007 15:42:30 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miguel Figueiredo <elmig@debianpt.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 frozen for a few minutes, swapping to disk
References: <46347335.7080601@debianpt.org> <20070430003031.2e89fbc1.akpm@linux-foundation.org>
In-Reply-To: <20070430003031.2e89fbc1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 29 Apr 2007 11:28:05 +0100 Miguel Figueiredo <elmig@debianpt.org> wrote:
> 
> 
>>Hi all,
>>
>>today, with 2.6.21, my laptop had a really odd behaviour. It started 
>>writing to disk for a few minutes with no interactivity at all (no 
>>redraw on screen, only hdd led on). It's the first time i noticed 
>>OOM-killer started do kill programs.
>>
>>It was totally unresponsive for minutes, after back to life it had a 
>>load of ~19.0, and 300+ MB on swap (first time i saw this).
>>
>>It's an HP pavillon core duo 2.0 GHz, 1 GB RAM
>>
>>kern.log details: 
>>http://www.debianpt.org/~elmig/pool/kernel/20070429/kern.log
>>.config: http://www.debianpt.org/~elmig/pool/kernel/20070429/2.6.21.config
>>dmesg: http://www.debianpt.org/~elmig/pool/kernel/20070429/dmesg
>>
>>As this is the first time it happened and it felt odd i am reporting.
>>
>>If aditional info is needed please CC me as i am not on the list.
>>
> 
> 
> hm, a genuine oom on an all-ext3 data=ordered i386 system, just like a
> million other people.  How very weird.
> 
> I assume all those pages on the LRU are pagecache pages which for some
> reason we're unable to reclaim.

It looks like it used up all swap? I'd guess a memory leak in some
application, or maybe a page refcount leak somewhere.


> 
> If some privileged application went berzerk mlock()ing everything then that
> might explain it.  It sounds improbable, but then, something improbable has
> happened.
> 
> We cleverly managed to not display the pagecache totals in the oom-killer
> output.  Could you please take a copy of /proc/meminfo after an
> oom-killing, send that?  And /proc/vmstat, I guess.
> 
> If you're keen, we could eliminate the mlock possibility by adding this:
> 
> --- a/mm/mlock.c~a
> +++ a/mm/mlock.c
> @@ -127,6 +127,8 @@ asmlinkage long sys_mlock(unsigned long 
>  	unsigned long lock_limit;
>  	int error = -ENOMEM;
>  
> +	return 0;
> +
>  	if (!can_do_mlock())
>  		return -EPERM;
>  
> @@ -151,6 +153,8 @@ asmlinkage long sys_munlock(unsigned lon
>  {
>  	int ret;
>  
> +	return 0;
> +
>  	down_write(&current->mm->mmap_sem);
>  	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
>  	start &= PAGE_MASK;
> _
> 

-- 
SUSE Labs, Novell Inc.
