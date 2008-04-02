Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYDBODg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYDBODg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYDBOD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:03:27 -0400
Received: from mga06.intel.com ([134.134.136.21]:33084 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbYDBOD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:03:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,593,1199692800"; 
   d="scan'208";a="266546436"
Message-ID: <47F391BD.1060306@linux.intel.com>
Date: Wed, 02 Apr 2008 07:01:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com> <47F11ED3.40803@tungstengraphics.com> <47F2A202.1040900@linux.intel.com> <47F2A948.5070108@tungstengraphics.com> <47F2B788.1030101@linux.intel.com> <47F32816.4060806@tungstengraphics.com> <47F3294E.8090805@linux.intel.com> <47F32EDD.1080306@tungstengraphics.com>
In-Reply-To: <47F32EDD.1080306@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:
> Arjan van de Ven wrote:
>> Thomas Hellström wrote:
>>
>>> But what mappings are there,  immediately after alloc_page(), that 
>>> set_memory_np won't catch? 
>>
>> For example on x86 64bit, the kernel text is mapped (to allow 
>> relocatable) in another
>> space as well.. and to allow 2Mb tlbs for this, that second mapping is 
>> bigger than it strictly needs to be.
>> So your alloc_page() could get a page from the free pool that comes 
>> from the pages that have a second mapping
>> due to this rounding.
>> (and more fun, since it's close to frequently accessed memory, the hw 
>> prefetchers may actually just decide to pull
>> such pages into the cache preemptively)
>>
>>
>>> Drivers relying on set_memory_uc touching all mappings the driver 
>>> hasn't set up itself must then have the same problem and needs to be 
>>> fixed; referring in particular to agpgart for which driver the old 
>>> CPA functionality was once created, IIRC.
>>
>> "uc" is different than "np"; for "uc" the implementation, if your cpu 
>> needs this, will fix
>> up the shadow text mappings already today.
>>
>> for "present" this doesn't make sense, since no cpu needs this.
> If this is the checkalias() thingy in x86/pageattr.c, it looks like it 
> doesn't handle np different from the uc case. It does obviously skip NX 
> bit manipulations, though.
> 
> Anyway, a more direct question: If we were to fix whatever's missing for 
> the code to fixup the x86-64 shadow text mapping, would you be opposing 
> this way 

I do really oppose set_memory_np/p to work on anything but the mapping it is handled.
that _uc and co touch other mappings is a cpu specific property and an implementation
detail to the API. If/When CPUs exist that don't have issues with aliases, those CPUs
will not change the other mappings.

 > to fix the long standing uc/wc aliasing issue, provided we

I'm not opposed to a real fix. I am opposed to a bad hack.

> don't hit any other problems, like clflush() refusing to run on an NP page?

yes clflush doesn't work on not present pages ;)
