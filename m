Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbXGAAWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbXGAAWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 20:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbXGAAV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 20:21:58 -0400
Received: from smtpout.mac.com ([17.250.248.178]:54721 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbXGAAV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 20:21:58 -0400
In-Reply-To: <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org> <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com> <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com> <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com> <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>
Cc: Andy Isaacson <adi@hexapodia.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Date: Sat, 30 Jun 2007 20:21:52 -0400
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 30, 2007, at 19:57:18, Davide Libenzi wrote:
> On Sat, 30 Jun 2007, Kyle Moffett wrote:
>> Very simple case:  SELinux is turned on, an s9 (IE: TOP_SECRET)  
>> process calls free(), and an s3 (IE: UNCLASSIFIED) process calls  
>> malloc(), getting the data from the TOP_SECRET process.
>
> Note that you use *s3* and *s9*. Those will be two different  
> context cookies.  SeLinux will have its own way to set the cookie  
> in the mm_struct, to *s3* in one case, and to *s9* in the other  
> case. This will make things so that they'll never see each other  
> pages.

Except s3 and s9 aren't complete cookies.  A complete label might be:  
"system_u:system_r:apache2_t:s3" for an unclassified apache web- 
server process, or "kmoffett_u:secadmin_r:usershell_t:s9" for me  
logged in with a top-secret label in my security-administrator role.   
That's why you'd need to call an LSM hook to get a unique identifier,  
as the LSM would actually need to allocate identifiers for  
equivalence classes.  Secondly, processes may change labels as they  
run, so you couldn't just call it once and cache the result, you  
would need to call it for every freed page (or every re-use of a page).

>>> It is very easy, assuming a simple unsigned long cookie is enough  
>>> for
>>> SeLinux, to fit in the current MAP_NOZERO.   Well, we have to change
>>> something in the current struct page _mapcount reuse, but that  
>>> doable. There
>>> is one line to change, that is the line where the cookie is  
>>> assigned  to the
>>> mm_struct.

I do think a single unsigned long cookie would work, as long as you  
have an LSM hook:

int process_equivalence_class(struct task_struct *task, unsigned long  
*result);

If it returns 0 then you can use the result as a page cookie,  
otherwise you can't reuse pages for this process at all.

Cheers,
Kyle Moffett

