Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYCaR1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYCaR1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYCaR1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:27:15 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:5803 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751891AbYCaR1P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:27:15 -0400
Message-ID: <47F11ED3.40803@tungstengraphics.com>
Date: Mon, 31 Mar 2008 19:26:43 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com>
In-Reply-To: <47F11616.3020403@linux.intel.com>
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
>>>
>>>> Let me rehprase. Not really time-critical but it is of some 
>>>> importance that CPA is done quickly.
>>>> We're dealing with the tradeoff of reading from uncached device memory 
>>>
>>> uncached or write combining ?
>> The user-space mappings (the ones that we really use) are usually 
>> write-combined, whereas the kernel mappings are uncached. (I think 
>> this is OK since both mapping types implies no cache coherency). 
>
> This is not officially allowed and may tripple fault your cpu..
> To comply with the spec one needs to have ALL mappings the same 
> unfortunately.
> (And yes, this is a hard problem)
>
Hmm...

Given this problem, the previously mentioned use-case, and the fact that 
we mostly really use user-space mappings,
Is there a possibility we could add the following functions to Dave's 
patch (provided they would work as intended, of course, namely 
invalidate / bring back the kernel mapping).
Then we can set up a pool of unmapped pages, avoid frequent use of CPA 
and everybody's happy.

int set_memory_array_np(unsigned long *addr, int addrinarray)
{
    return change_page_attr_clr(addr, addrinarray,
                    __pgprot(_PAGE_PRESENT  |  _PAGE_RW), 1);
}
EXPORT_SYMBOL(set_memory_array_np);

int set_memory_array_p(unsigned long *addr, int addrinarray)
{
    return change_page_attr_set(addr, addrinarray,
                    __pgprot(_PAGE_PRESENT  |  _PAGE_RW), 1);
}
EXPORT_SYMBOL(set_memory_array_p);

/Thomas



