Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbXK0C3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbXK0C3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXK0C3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:29:32 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:44179 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXK0C3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:29:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a/A113r6KJFoIWZpTLBa/bajJr8R4V9DwYb96FgTa1XolMbbNYyQKrkgO69+aZWMPa4OmIntkxuoyRFyWqd8jgUih//yFYUQpbWjmQ/GGTeTGuoP73IoVIq1Xk6SclhYlopoqGOMFekHF2ntz2DpWjEC+Eihq8Tl4cbPlB2Zlg0=
Date: Tue, 27 Nov 2007 10:26:10 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Dave Hansen <haveblue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-mm@kvack.org
Subject: [Patch](Resend) mm/sparse.c: Improve the error handling for
	sparse_add_one_section()
Message-ID: <20071127022609.GA4164@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <1195507022.27759.146.camel@localhost> <20071123055150.GA2488@hacking> <20071126191316.99CF.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126191316.99CF.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 07:19:49PM +0900, Yasunori Goto wrote:
>Hi, Cong-san.
>
>>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>>  
>>  	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
>>  
>>  out:
>>  	pgdat_resize_unlock(pgdat, &flags);
>> -	if (ret <= 0)
>> -		__kfree_section_memmap(memmap, nr_pages);
>> +
>>  	return ret;
>>  }
>>  #endif
>
>Hmm. When sparse_init_one_section() returns error, memmap and 
>usemap should be free.

Hi, Yasunori.

Thanks for your comments. Is the following one fine for you?

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
 
@@ -403,10 +411,6 @@ int sparse_add_one_section(struct zone *
 		goto out;
 	}
 
-	if (!usemap) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
 	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
@@ -414,7 +418,7 @@ int sparse_add_one_section(struct zone *
 out:
 	pgdat_resize_unlock(pgdat, &flags);
 	if (ret <= 0)
-		__kfree_section_memmap(memmap, nr_pages);
+		kfree(usemap);
 	return ret;
 }
 #endif

