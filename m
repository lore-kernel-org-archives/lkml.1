Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZGMLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZGMLbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZGMLbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:31:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZGMLbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:31:17 -0400
Message-ID: <4A5B1B9F.20708@redhat.com>
Date: Mon, 13 Jul 2009 14:33:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, dave.mccracken@oracle.com,
       linux-mm@kvack.org, sunil.mushran@oracle.com, alan@lxorguk.ukuu.org.uk,
       Anthony Liguori <anthony@codemonkey.ws>,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH 0/4] (Take 2): transcendent memory
 ("tmem") for Linux
References: <d05df0b0-e932-4525-8c9e-93f6cb792903@default>
In-Reply-To: <d05df0b0-e932-4525-8c9e-93f6cb792903@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 12:08 AM, Dan Magenheimer wrote:
>> Can you explain how it differs for the swap case?  Maybe I don't
>> understand how tmem preswap works.
>>      
>
> The key differences I see are the "please may I store something"
> API and the fact that the reply (yes or no) can vary across time
> depending on the state of the collective of guests.  Virtual
> disk cacheing requires the host to always say yes and always
> deliver persistence.

We need to compare tmem+swap to swap+cache, not just tmem to cache.  
Here's how I see it:

tmem+swap swapout:
   - guest copies page to tmem (may fail)
   - guest writes page to disk

cached drive swapout:
   - guest writes page to disk
   - host copies page to cache

tmem+swap swapin:
   - guest reads page from tmem (may fail)
   - on tmem failure, guest reads swap from disk
   - guest drops tmem page

cached drive swapin:
   - guest reads page from disk
   - host may satisfy read from cache

tmem+swap ageing:
   - host may drop tmem page at any time

cached drive ageing:
   - host may drop cached page at any time

So they're pretty similar.  The main difference is that tmem can drop 
the page on swapin.  It could be made to work with swap by supporting 
the TRIM command.

> I can see that this is less of a concern
> for KVM because the host can swap... though doesn't this hide
> information from the guest and potentially have split-brain
> swapping issues?
>    

Double swap is bad for performance, yes.  CMM2 addresses it nicely.  
tmem doesn't address it at all - it assumes you have excess memory.

> (thanks for the great discussion so far... going offline mostly now
> for a few days)
>    

I'm going offline too so it cancels out.

-- 
error compiling committee.c: too many arguments to function

