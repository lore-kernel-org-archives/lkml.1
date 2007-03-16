Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXCPHit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXCPHit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXCPHis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:38:48 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:41710 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752966AbXCPHis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:38:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=2cYOd2/SBqYKazMipLy+IpmwN+m/qL2/Z7qwQxzKQatlzSqv9XkNBQ7yAdMXAXDR9iXFCEKjwRivnbAaitsX9DHu3pnaYL3vYOb8mExWPAeZY7rpG+AMvBFUY+yoBDpj4haI70Uo4qRyp55Cv+zhE4xgRkTBrpGiC8fADFqNsf8=  ;
X-YMail-OSG: pvxxAmoVM1lXi4_ydmvbWJScsd1Ykx9jtxJmujrEgSNKz2BMbPsHcvcka2GTjPG8cz_039gvszDCMLA92yaJ5XS3zEZpnQMFc3lNwcXQRq4ICvMktm3Vz2LlHq5HEcZL3pKsdHDlpFmJeUE-
Message-ID: <45FA4984.9000506@yahoo.com.au>
Date: Fri, 16 Mar 2007 18:38:44 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI> <45FA458C.8050605@yahoo.com.au> <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> Pekka J Enberg wrote:
> 
>>>	/*
>>>- 	 * Not holding ->mmap_sem here.
>>>+ 	 * Not holding ->mmap_sem here but we must watch out for page
>>>+ 	 * faults and after the shared mappings have been taken down
>>>+ 	 * and sys_mmap() trying to remap the revoked range.
>>>  */
>>>  vma->vm_flags |= VM_REVOKED;
>>>  smp_mb();
>>>@@ -455,7 +457,7 @@ 	int err = 0;
> 
> 
> On Fri, 16 Mar 2007, Nick Piggin wrote:
> 
>>You're still modifying vm_flags without down_write mmap_sem, so this will
>>corrupt vm_flags.
> 
> 
> Uhm, you're right, two concurrent writes and we can lose some bits so a 
> barrier doesn't work. Too bad as we're under mapping->i_mmap_lock here and 
> thus cannot take ->mmap_sep...
> 

Could you try something like walk the i_mmap lists to find mms with vmas that
haven't need revoking, then each time you find one, take a ref on the mm, drop
i_mmap_lock, take mmap_sem, and walk all its vmas looking for any that reference
the inode?

Bit of a roundabout way to go, but it might work.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
