Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYLBQu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYLBQu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYLBQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:50:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:22630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYLBQur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=CoDvsMfKu6j5Jqj1YEjDHdo7XIu2zg4zOjNROP9vUER+f75+RNrNGCNNqLLj0+jZ/S
         ZfaLvA2VTsmZcG8r7olFtgcoipcIbu5o/MD7RdjUSzPmV1FVszT2RIx6iM8ZhSvmKseM
         ZjO2l91O8/j2ab2I0eofqDyBngjy8uH4OaQBY=
Message-ID: <cfd18e0f0812020850v90b2e03me7dd43cf314a409@mail.gmail.com>
Date: Tue, 2 Dec 2008 11:50:45 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [PATCH] getrusage: fill ru_maxrss value
Cc: "Jiri Pirko" <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-api@vger.kernel.org
In-Reply-To: <20081202160507.GA14524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081202131802.5252b96d@psychotron.englab.brq.redhat.com>
	 <20081202160507.GA14524@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 11:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 12/02, Jiri Pirko wrote:
>>
>> Based on the patch previously posted by Frank Mayhar:
>> http://kerneltrap.org/mailarchive/linux-kernel/2007/9/20/264772
>>
>> Changed to do not panic and to set the value properly. Also made some
>> modifications as Oleg suggested. maxrss value is set to pages as "time"
>> application converts it co KBs.
>>
>> This patch enables "time" application to show maxresident value
>> correctly.
>
> I believe the changelog could be a bit more descriptive ;)
> And I think the patch needs more CCs. (Hugh and Michael cc'ed).

Thanks Oleg.

Jiri: linux-api@ should also be CCed on API changes; see
Documentation/SubmitChecklist and
http://thread.gmane.org/gmane.linux.ltp/5658

> What about exec? Should we preserve signal_struct->maxrss, or should
> we reset it? I don't know what is the right behaviour, but imho it
> should be consistent with task_mem()/xacct_add_tsk(). And since
> bprm_mm_init() does not copy ->hiwater_xxx, perhaps we should reset.
> Or we should change the exec_mmap() path to preserve ->hiwater_xxx,
> I dunno.
>
>> Note that even without this patch applied there is a race between two
>> parallel update_hiwater_rss() callers.
>>
>> [...snip...]
>> @@ -1051,6 +1051,8 @@ NORET_TYPE void do_exit(long code)
>>       if (tsk->mm) {
>>               update_hiwater_rss(tsk->mm);
>>               update_hiwater_vm(tsk->mm);
>> +
>> +             tsk->signal->maxrss = tsk->mm->hiwater_rss;
>
> Yes. But still it is not good the patch adds new racy calls
> (k_getrusage() too). And in fact I think this code in do_exit()
> should die, and we can update signal->maxrss in exit_mm().
>
> Unless I missed something, the "if (tsk->mm) {}" code in
> do_exit() is not needed because xacct_add_tsk() is not right
> anyway. What we imho need is get_mm_hiwater_xxx(), can be
> also used by task_mm().
>
> I'll send the patch a bit later, then we can tweak this patch.
>
> Do you agree?
>
> (just in case, I don't mean that mm/ uses update_hiwater_xxx()
>  "safely", afaics try_to_unmap can race with unmap_region
>  for example, but still).
>
> Oleg.
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
