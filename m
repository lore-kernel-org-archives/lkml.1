Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbXF2Xsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbXF2Xsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 19:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXF2XsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 19:48:22 -0400
Received: from smtpout.mac.com ([17.250.248.184]:58404 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXF2XsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 19:48:21 -0400
In-Reply-To: <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org> <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
Cc: Andy Isaacson <adi@hexapodia.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Date: Fri, 29 Jun 2007 19:48:12 -0400
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 29, 2007, at 16:12:58, Davide Libenzi wrote:
> On Fri, 29 Jun 2007, Andy Isaacson wrote:
>> I still think that using uid in mm_struct is wrong, and some kind  
>> of abstraction is required.  I called this "free pool" in  
>> <20070628061911.GA16986@hexapodia.org>, but I think that name is  
>> misleading -- I am not proposing that this should be part of the  
>> management of free pages, but should be a label which abstracts  
>> "safe to share freed pages among" groups.  Then different SELinux  
>> protection domains would simply have different labels.
>
> I think I answered this one at least a couple of times, but anyawy.  
> First, that can be whatever cookie we choose. At the moment UID is  
> used because it makes easier a fit into _mapcount. Second, SeLinux  
> will be able to  disable the feature on a per-process base, or  
> globally.
>
> Anything else?

Well I would be very interested in actually being able to use this  
feature under SELinux, I think that just the underlying "can-I-use- 
this-page" logic needs modification.  Maybe "MAP_REUSABLE"?  That  
would both imply that we can accept reused (IE: nonzeroed) memory  
*AND* that the current page may be reused (IE: remapped without  
zeroing), although you could conceivably have one flag for each  
case.  The userspace allocator should be able to (when prompted by  
MAP_REUSABLE) look in a page "pool" of sorts before falling back to a  
zeroed page.  The pool would be created for a given "key" the first  
time it unmaps MAP_REUSABLE pages, possibly using the memory freed by  
said unmap.

The real trick is how to define the "key".  The default, without  
LSMs, should be something like the UID.  SELinux, on the other hand,  
would probably want to use some kind of hash of the label as the  
"key", (and store the label in each pool, as well).  That way SELinux  
could have a simple access-vector check for process:reusepage, as  
well as an access-vector check and type transition for  
"freereusablepage".  Then a policy could allow most user processes to  
unconditionally reuse pages (which would end up in the access-vector- 
cache and therefore be fast), while security-sensitive processes like  
ssh-agent could neither reuse pages nor have their pages reused, even  
if they request it.

Cheers,
Kyle Moffett

