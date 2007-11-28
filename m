Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbXK1MsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbXK1MsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbXK1MsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:48:03 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:53858 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761204AbXK1MsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=d8zp6Kq0oIHQwjPTf8eOzFxUqCazxa8a9SO3+MOVsQZwUqCGgIcMfRBaYrtO5wTDMgiFUcRQp4aBnljTt+RBytS+kULYPd5PCuA8raFniKKe+ylDS63Gcg2riZZPk/dzc2/ZGyPCV8Siej86PIetN6ImoGGBPzLREvp266dvg44=
Date: Wed, 28 Nov 2007 20:44:20 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-mm@kvack.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [Patch](Resend) mm/sparse.c: Improve the error handling for
	sparse_add_one_section()
Message-ID: <20071128124420.GJ2464@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <1195507022.27759.146.camel@localhost> <20071123055150.GA2488@hacking> <20071126191316.99CF.Y-GOTO@jp.fujitsu.com> <20071127022609.GA4164@hacking> <1196189625.5764.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196189625.5764.36.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 10:53:45AM -0800, Dave Hansen wrote:
>On Tue, 2007-11-27 at 10:26 +0800, WANG Cong wrote:
>> 
>> @@ -414,7 +418,7 @@ int sparse_add_one_section(struct zone *
>>  out:
>>         pgdat_resize_unlock(pgdat, &flags);
>>         if (ret <= 0)
>> -               __kfree_section_memmap(memmap, nr_pages);
>> +               kfree(usemap);
>>         return ret;
>>  }
>>  #endif 
>
>Why did you get rid of the memmap free here?  A bad return from
>sparse_init_one_section() indicates that we didn't use the memmap, so it
>will leak otherwise.

Sorry, I was confused by the recursion. This one should be OK.

Thanks.



Improve the error handling for mm/sparse.c::sparse_add_one_section().  And I
see no reason to check 'usemap' until holding the 'pgdat_resize_lock'.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -391,9 +391,17 @@ int sparse_add_one_section(struct zone *
 	 * no locking for this, because it does its own
 	 * plus, it does a kmalloc
 	 */
-	sparse_index_init(section_nr, pgdat->node_id);
+	ret = sparse_index_init(section_nr, pgdat->node_id);
+	if (ret < 0)
+		return ret;
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id, nr_pages);
+	if (!memmap)
+		return -ENOMEM;
 	usemap = __kmalloc_section_usemap();
+	if (!usemap) {
+		__kfree_section_memmap(memmap, nr_pages);
+		return -ENOMEM;
+	}
 
 	pgdat_resize_lock(pgdat, &flags);
 
@@ -403,18 +411,16 @@ int sparse_add_one_section(struct zone *
 		goto out;
 	}
 
-	if (!usemap) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
-	if (ret <= 0)
+	if (ret <= 0) {
+		kfree(usemap);
 		__kfree_section_memmap(memmap, nr_pages);
+	}
 	return ret;
 }
 #endif
