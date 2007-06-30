Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXF3XqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXF3XqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXF3XqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:46:11 -0400
Received: from smtpout.mac.com ([17.250.248.173]:65269 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbXF3XqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:46:10 -0400
In-Reply-To: <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0> <EC4CE052-5514-465E-92D2-9D50DA970DDC@mac.com> <20070629193954.GL9157@hexapodia.org> <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com> <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>
Cc: Andy Isaacson <adi@hexapodia.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Date: Sat, 30 Jun 2007 19:46:02 -0400
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 30, 2007, at 15:03:07, Davide Libenzi wrote:
> Hmm, why would you need MAP_REUSABLE? If a page is visible at any  
> time for a given UID, and you have a login under such UID, you can  
> fetch the content of the page at any time (ie, ptrace_attach,  
> gdb, ...).

Not under SELinux or other LSMs.  I suppose those could live without  
a 15% performance improvement in some workloads, but it would be nice  
if we could avoid it.  Essentially, UID is a really poor way to  
define process-security-equivalence classes in some systems.  If you  
really want to define such classes then you need to add LSM hooks to  
manage the equivalence classes.

> I think the focus should be to find a case where under the  
> currently implemented policy for MAP_NOZERO, MAP_NOZERO represent a  
> loss of security WRT no MAP_NOZERO.

Very simple case:
SELinux is turned on, an s9 (IE: TOP_SECRET) process calls free(),  
and an s3 (IE: UNCLASSIFIED) process calls malloc(), getting the data  
from the TOP_SECRET process.

>> The real trick is how to define the "key".  The default, without  
>> LSMs, should be something like the UID.  SELinux, on the other  
>> hand, would probably want to use some kind of hash of the label as  
>> the "key", (and store the label in each pool, as well).  That way  
>> SELinux could have a simple access-vector check for  
>> process:reusepage, as well as an access-vector check and type  
>> transition for "freereusablepage".  Then a policy could allow most  
>> user processes to unconditionally reuse pages (which would end up  
>> in the access-vector-cache and therefore be fast), while security- 
>> sensitive processes like ssh-agent could neither reuse pages nor  
>> have their pages reused, even if they request it.
>
> It is very easy, assuming a simple unsigned long cookie is enough  
> for SeLinux, to fit in the current MAP_NOZERO.   Well, we have to  
> change something in the current struct page _mapcount reuse, but  
> that doable. There is one line to change, that is the line where  
> the cookie is assigned  to the mm_struct.

I think if you create the concept of a "process equivalence class"  
and add an LSM hook for it, then the unsigned long could just store  
which equivalence class the page is in.  The default without LSMs  
would be to use mutual-ptraceability as the equivalence class (IE:  
the UID with a proviso for SUID binaries).  LSMs should be able to  
create a process_equivalence_class hook which when called returns an  
unsigned long identifying the "equivalence class" (IE: pool) into  
which the page is placed when freed (or ((unsigned long)-1) to  
forcibly zero the page).  When a process requests a maybe-not-zeroed  
page, the LSM hook would be called again to determine what  
equivalence class should be used, (or ((unsigned long)-1) for dont- 
use-any-class).

Cheers,
Kyle Moffett
