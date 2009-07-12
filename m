Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZGLR2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZGLR2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 13:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbZGLR2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 13:28:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbZGLR2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 13:28:05 -0400
Message-ID: <4A5A1D15.1090809@redhat.com>
Date: Sun, 12 Jul 2009 20:27:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Schwidefsky <schwidefsky@de.ibm.com>,
       chris.mason@oracle.com, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <426e84ca-be31-40ac-a4c1-42cd9677d86c@default>
In-Reply-To: <426e84ca-be31-40ac-a4c1-42cd9677d86c@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2009 07:28 PM, Dan Magenheimer wrote:
>> Having no struct pages is also a downside; for example this
>> guest cannot
>> have more than 1GB of anonymous memory without swapping like mad.
>> Swapping to tmem is fast but still a lot slower than having
>> the memory
>> available.
>>      
>
> Yes, true.  Tmem offers little additional advantage for workloads
> that have a huge variation in working set size that is primarily
> anonymous memory.  That larger scale "memory shaping" is left to
> ballooning and hotplug.
>    

And this is where the policy problems erupt.  When do you balloon in 
favor of tmem?  which guest do you balloon? do you leave it to the 
administrator? there's the host's administrator and the guests' 
administrators.

CMM2 solves this neatly by providing information to the host.  The host 
can pick the least recently used page (or a better algorithm) and evict 
it using information from the guest, either dropping it or swapping it.  
It also provides information back to the guest when it references an 
evicted page: either the guest needs to recreate the page or it just 
needs to wait.

>> tmem makes life a lot easier to the hypervisor and to the guest, but
>> also gives up a lot of flexibility.  There's a difference
>> between memory
>> and a very fast synchronous backing store.
>>      
>
> I don't see that it gives up that flexibility.  System adminstrators
> are still free to size their guests properly.  Tmem's contribution
> is in environments that are highly dynamic, where the only
> alternative is really sizing memory maximally (and thus wasting
> it for the vast majority of time in which the working set is smaller).
>    

I meant that once a page is converted to tmem, there's a limited amount 
of things you can do with it compared to normal memory.  For example 
tmem won't help with a dcache intensive workload.

> I'm certainly open to identifying compromises and layer modifications
> that help meet the needs of both Xen and KVM (and others).  For
> example, if we can determine that the basic hook placement for
> precache/preswap (or even just precache for KVM) can be built
> on different underlying layers, that would be great!
>    

I'm not sure preswap/precache by itself justifies tmem since it can be 
emulated by backing the disk with a cached file.  What I'm missing in 
tmem is the ability for the hypervisor to take a global view on memory; 
instead it's forced to look at memory and tmem separately.  That's fine 
for Xen since it can't really make any decisions on normal memory 
(lacking swap); on the other hand kvm doesn't map well to tmem since 
"free memory" is already used by the host pagecache.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

