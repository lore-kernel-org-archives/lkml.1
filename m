Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbYDJOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbYDJOCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYDJOCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:02:46 -0400
Received: from saeurebad.de ([85.214.36.134]:56228 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbYDJOCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:02:45 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andreas Schwab <schwab@suse.de>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: [PATCH] Stay below upper pmd boundary on pte range walk
References: <47FC95AD.1070907@tiscali.nl> <87zls3qhop.fsf@saeurebad.de>
	<jer6dd9ajn.fsf@sykes.suse.de>
Date: Thu, 10 Apr 2008 16:01:49 +0200
In-Reply-To: <jer6dd9ajn.fsf@sykes.suse.de> (Andreas Schwab's message of "Thu,
	10 Apr 2008 14:09:00 +0200")
Message-ID: <878wzlzu42.fsf_-_@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andreas Schwab <schwab@suse.de> writes:

> Johannes Weiner <hannes@saeurebad.de> writes:
>
>>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>>> ---
>>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>>> index 1cf1417..6615f0b 100644
>>> --- a/mm/pagewalk.c
>>> +++ b/mm/pagewalk.c
>>> @@ -15,7 +15,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>  		       break;
>>>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>>>  
>>> -	pte_unmap(pte);
>>> +	pte_unmap(pte - 1);
>>>  	return err;
>>>  }
>>
>> This does not make any sense to me.
>
> There is something fishy here.  If the loop ends because addr == end
> then pte has been incremented past the pmd page for addr, no?

Whoops, yes.  But Roel's fix breaks if the break is taken in the first
iteration of the loop, because the pte is then out of the lower bounds
of the pmd page.  Please see attached fix.

	Hannes

---

After the loop in walk_pte_range() pte might point to the first address
after the pmd it walks.  The pte_unmap() is then applied to something
bad.

Spotted by Roel Kluin and Andreas Schwab.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

A bug is unlikely, though.  kunmap_atomic() looks up the kmap entry by
map-type instead of the address the pte points.  So the worst thing I
could find with a quick grep was that a wrong TLB entry is being
flushed.  Still, the code is wrong :)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 1cf1417..cf3c004 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -13,7 +13,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
 		if (err)
 		       break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (addr += PAGE_SIZE, addr != end && pte++);
 
 	pte_unmap(pte);
 	return err;
