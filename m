Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYDBGbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYDBGbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYDBGbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:31:25 -0400
Received: from relay.gothnet.se ([82.193.160.251]:3112 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751730AbYDBGbY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:31:24 -0400
Message-ID: <47F32816.4060806@tungstengraphics.com>
Date: Wed, 02 Apr 2008 08:30:46 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com> <47F11ED3.40803@tungstengraphics.com> <47F2A202.1040900@linux.intel.com> <47F2A948.5070108@tungstengraphics.com> <47F2B788.1030101@linux.intel.com>
In-Reply-To: <47F2B788.1030101@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Hellström wrote:
>> Arjan van de Ven wrote:
>>> Thomas Hellström wrote:
>>>> Given this problem, the previously mentioned use-case, and the fact 
>>>> that we mostly really use user-space mappings,
>>>> Is there a possibility we could add the following functions to 
>>>> Dave's patch (provided they would work as intended, of course, 
>>>> namely invalidate / bring back the kernel mapping).
>>>
>>> sadly there are multiple mappings, both in theory and practice.
>>> Especially the _np / _p functions specifically work on only the 
>>> mapping you specify.
>>>
>>> For this to work we would need to somehow make a "mark all mappings 
>>> NP, but please only do the kernel ones" kind of thing.
>>> The semantics of that are... lets say messy at best.
>> Hmm, I'm not sure I follow you here. Are you saying that it's illegal 
>> to have an NP mapping of a page (which, If I understand it correctly, 
>> means no mapping at all) at the same time as you have a, say 
>> user-space WC mapping pointing to the same physical page?
>
> no.
> What I'm saying is that even if you make one mapping NP, it's hard to 
> know you got all of them,
> even just the kernel one.
>
>>
>> I was under the impression that calling CPA on the kernel mapping of 
>> that page would do the rest?
>
> this is not a correct assumption in general, especially not for things 
> like
> "present".
> If a page is mapped 3 times in the kernel, and you set one to "np", 
> the others
> WILL stay mapped.
>
> (and CPA itself no longer exists period ;)
But what mappings are there,  immediately after alloc_page(), that 
set_memory_np won't catch? Certainly kmap_atomic() used to leave some 
stale mappings floating around, but that has been fixed as far as I can 
tell, and I guess we must be able to assume that a driver keeps track of 
its own kernel mappings and kill them before calling set_memory_np.

Drivers relying on set_memory_uc touching all mappings the driver hasn't 
set up itself must then have the same problem and needs to be fixed; 
referring in particular to agpgart for which driver the old CPA 
functionality was once created, IIRC.

We should probably get this right as soon as possible, as the agpgart 
driver is (and has for the last couple of years been) relying on wc / uc 
aliasing to be legal. If we can fix this with set_memory_np / 
set_memory_p that would be great, and would have some additional 
benefits for the drm memory manager as well.

/Thomas






