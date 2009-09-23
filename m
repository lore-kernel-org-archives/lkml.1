Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZIWQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZIWQwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZIWQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:52:16 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:50503 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZIWQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pa3k+e+lDWBabTWhl7vosTJOmXh22jhvZbHncIEYq7PC3vzCyTMPQsNk7ugnk37xRX
         9bOx2+7D9o2AEoQSOOEJMouLs+PSj3T3/L+lkj06xjlUgXVUO7h4l1NQuuya+4xmKSV9
         JWAUVytW9MerfVA2/+yaTDuTQ3ryfFg1C7LXw=
Message-ID: <4ABA523F.7000601@tuffmail.co.uk>
Date: Wed, 23 Sep 2009 17:52:15 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       linux-modules@vger.org
Subject: Re: module: Speed up symbol resolution during module loading
References: <1253626112-18429-1-git-send-email-alan-jenkins@tuffmail.co.uk> <200909231002.16759.rusty@rustcorp.com.au>
In-Reply-To: <200909231002.16759.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC to lkml fixed :-/]

Rusty Russell wrote:
> On Tue, 22 Sep 2009 10:58:28 pm Alan Jenkins wrote:
>   
>> The following series applies against v2.6.31. It sorts the tables of builtin
>> symbols, so the module loader can resolve them using a binary search.
>>
>> The kbuild changes to achieve this are less scary than I expected.  I'm
>> optimistic that they can be accepted without radical alteration :-).
>>
>> Quoting from the last patch in this series:
>>
>> "On my EeePC 701, coldplug is mainly cpu bound and takes 1.5 seconds
>> during boot. perf showed this change eliminated 20% of cpu cycles during
>> coldplug, saving 0.3 seconds of real time.
>>     
>
> Hi Alan,
>
>    This seems useful, but wouldn't it be simpler to just sort at boot time?
> The same could be done for modules, possibly reducing code.
>
> Alternately, there's a standard way of hashing ELF symbols, but I'm not sure
> we can convince the linker to generate it for vmlinux (I haven't looked
> though).
>
> Thanks!
> Rusty.
>   

I'm concerned that people would object to the extra overhead at boot
time.  I've hacked up a prototype to sort at boot time and it takes 7ms
on the same hardware.  That's just under than the average time saved
loading one of my modules.  But the comparison is dodgy because it
doesn't include side-effects (on cache) for the sort.  The break-even
point will depend on the specific modules used.

That 7ms will be pure overhead in some cases - i.e. if your config is
"localyesconfig" (build in all currently used modules), but you keep
modules enabled to allow some flexibility.  I'm not happy about that myself.

Hash tables have a similar disadvantage.  They would add more
unswappable pages, in order to optimise a function which is only
significant at boot time.  Binary search already brings symbol
resolution down from ~60% of modprobe's time to ~7%.  The nice thing
about using sorted tables that they stay the same size.

Regards
Alan
