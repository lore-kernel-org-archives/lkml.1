Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXJVMwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXJVMwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXJVMw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:52:29 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:33598 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXJVMw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:52:29 -0400
Message-ID: <471C9C70.8000206@keyaccess.nl>
Date: Mon, 22 Oct 2007 14:49:52 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] unlock before bug returns
References: <471C0697.1040906@tiscali.nl> <471C11E5.2000003@tiscali.nl>	 <20071022001045.131ea465@bree.surriel.com>	 <471C930D.4000004@tiscali.nl> <84144f020710220540i7be08eednf40db8367669825f@mail.gmail.com>
In-Reply-To: <84144f020710220540i7be08eednf40db8367669825f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2007 02:40 PM, Pekka Enberg wrote:

> On 10/22/07, Roel Kluin <12o3l@tiscali.nl> wrote:
>> diff --git a/mm/slab.c b/mm/slab.c
>> index cfa6be4..20c58dc 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -1606,8 +1606,10 @@ void __init kmem_cache_init(void)
>>                 struct kmem_cache *cachep;
>>                 mutex_lock(&cache_chain_mutex);
>>                 list_for_each_entry(cachep, &cache_chain, next)
>> -                       if (enable_cpucache(cachep))
>> +                       if (enable_cpucache(cachep)) {
>> +                               mutex_unlock(&cache_chain_mutex);
>>                                 BUG();
>> +                       }
>>                 mutex_unlock(&cache_chain_mutex);
>>         }
> 
> NAK. This will cause double-unlock when CONFIG_BUG is disabled. It's
> incorrect to assume that BUG() will always terminate the current
> process.

(which by the way also means that the "return;" delete from your original 
patch changes behaviour for !CONFIG_BUG, and probably not for the better).

Rene.

