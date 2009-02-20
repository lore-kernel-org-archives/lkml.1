Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZBTN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZBTN6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZBTN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:58:09 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:45012 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZBTN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:58:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oSIYUG2WSOATROKovJMpW6j+HpmztkkwqWBZBKHX3F2UNiWh66i+5WYDSEv3TNk1wE
         f3KVxIVn3TkqWvK1Z+rqNSanVDYcKyI2FlpdYFUzwAVjo+L7Nyf/e7SqHq97WCJYIOpH
         bgwE3gsC4mpjamBgQUTBvjjkX7FAatFxA4IRw=
MIME-Version: 1.0
In-Reply-To: <20090220135000.GA9616@elte.hu>
References: <20090220134121.GA19575@damson.getinternet.no>
	 <20090220135000.GA9616@elte.hu>
Date: Fri, 20 Feb 2009 15:58:03 +0200
X-Google-Sender-Auth: 01cca77b28516149
Message-ID: <84144f020902200558t716325fbp9d354946ef8fa8e@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 3:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> @@ -537,7 +538,7 @@ static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
>>
>>       if (nr) {
>>               spin_lock(&vmap_area_lock);
>> -             list_for_each_entry(va, &valist, purge_list)
>> +             list_for_each_entry_safe(va, n_va, &valist, purge_list)
>>                       __free_vmap_area(va);
>>               spin_unlock(&vmap_area_lock);
>
> ah, indeed:
>
>        list_del_rcu(&va->list);
>
> i suspect it could be hit big time in a workload that opens more
> than 512 files, as expand_files() uses a vmalloc()+vfree() pair
> in that case.
>
> Nice catch! .29 must-have. The bug was introduced in
> v2.6.27-5616-gdb64fe0:
>
>  db64fe0: mm: rewrite vmap layer
>
> So 2.6.28 is affected too.
>
> Acked-by: Ingo Molnar <mingo@elte.hu>

Oh, I wish more people would run their code under kmemcheck... ;-)
