Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZJKMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZJKMRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZJKMRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:17:54 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47536 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZJKMRx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bkzET54fMDXFz/iEY77fSEpCx0ZObfRwzbazUgOLXmBswetAUIqLqmHjTmt2A3J7q4
         8kbvcqZXVzS1cIMUXsktv6M10K7SA2ICYIUgfmgdgmFeI6bFXoLxK03rlNRLZO9XmEwl
         Hd+wJDoEStk2NoKq3ZpdZIU942Uqfq+hP5VXk=
MIME-Version: 1.0
In-Reply-To: <28675.1248957636@turing-police.cc.vt.edu>
References: <1244461122-3303-1-git-send-email-alexander.shishckin@gmail.com>
	 <71a0d6ff0907290917u1f0c0e68p8036d53c69320392@mail.gmail.com>
	 <28675.1248957636@turing-police.cc.vt.edu>
Date: Sun, 11 Oct 2009 15:17:42 +0300
Message-ID: <71a0d6ff0910110517v1068d7cyd8bb076abab23ed5@mail.gmail.com>
Subject: Re: [PATCH] [RFC] List per-process file descriptor consumption when 
	hitting file-max
From: Alexander Shishkin <alexander.shishckin@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/30  <Valdis.Kletnieks@vt.edu>:
> On Wed, 29 Jul 2009 19:17:00 +0300, Alexander Shishkin said:
>>Is there anything dramatically wrong with this one, or could someone please review this?
>
>
>> +               for_each_process(p) {
>> +                       files = get_files_struct(p);
>> +                       if (!files)
>> +                               continue;
>> +
>> +                       spin_lock(&files->file_lock);
>> +                       fdt = files_fdtable(files);
>> +
>> +                       /* we have to actually *count* the fds */
>> +                       for (count = i = 0; i < fdt->max_fds; i++)
>> +                               count += !!fcheck_files(files, i);
>> +
>> +                       printk(KERN_INFO "=> %s [%d]: %d\n", p->comm,
>> +                                       p->pid, count);
>
> 1) Splatting out 'count' without a hint of what it is isn't very user friendly.
> Consider something like "=> %s[%d]: open=%d\n" instead, or add a second line
> to the 'VFS: file-max' printk to provide a header.
Fair enough.

> 2) What context does this run in, and what locks/scheduling considerations
> are there? On a large system with many processes running, this could conceivably
> wrap the logmsg buffer before syslog has a chance to get scheduled and read
> the stuff out.
That's a good point.

> 3) This can be used by a miscreant to spam the logs - consider a program
> that does open() until it hits the limit, then goes into a close()/open()
> loop to repeatedly bang up against the limit. Every 2 syscalls by the
> abuser could get them another 5,000+ lines in the log - an incredible
> amplification factor.
>
> Now, if you fixed it to only print out the top 10 offending processes, it would
> make it a lot more useful to the sysadmin, and a lot of those considerations go
> away, but it also makes the already N**2 behavior even more expensive...
That's a good idea. I think some kind of rate-limiting can be applied here too.

> At that point, it would be good to report some CPU numbers by running a abusive
> program that repeatedly hit the limit, and be able to say "Even under full
> stress, it only used 15% of a CPU on a 2.4Ghz Core2" or similar...
I'll see what I can do.
Thanks for your comments and ideas!

Regards,
--
Alex
