Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZLUBqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZLUBqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZLUBqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:46:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:38121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbZLUBqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:46:32 -0500
Message-ID: <4B2ED310.1070709@kernel.org>
Date: Sun, 20 Dec 2009 17:44:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 4/12] pci: add failed_list to record failed one for	pci_bus_assign_resources
 -v2
References: <4B2BE9DD.3040504@kernel.org>  <4B2BEC2C.7030503@kernel.org> <1261352711.26429.43.camel@dc7800.home>
In-Reply-To: <1261352711.26429.43.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Fri, 2009-12-18 at 12:55 -0800, Yinghai Lu wrote:
>> so later we can do sth with those failed one
>>
>> -v2: store start, end, flags aside. so could keep res cleared when assign
>>      failed. and make following assignment of its children do not go wild
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/pci/setup-bus.c |   66 +++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 62 insertions(+), 4 deletions(-)
>>
>> Index: linux-2.6/drivers/pci/setup-bus.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/setup-bus.c
>> +++ linux-2.6/drivers/pci/setup-bus.c
>> @@ -27,7 +27,52 @@
>>  #include <linux/slab.h>
>>  #include "pci.h"
>>  
>> -static void pbus_assign_resources_sorted(const struct pci_bus *bus)
>> +struct resource_list_x {
>> +	struct resource_list_x *next;
>> +	struct resource *res;
>> +	struct pci_dev *dev;
>> +	resource_size_t start;
>> +	resource_size_t end;
>> +	unsigned long flags;
>> +};
>> +
>> +static void add_to_failed_list(struct resource_list_x *head,
>> +				 struct pci_dev *dev, struct resource *res)
>> +{
>> +	struct resource_list_x *list = head;
>> +	struct resource_list_x *ln = list->next;
>> +	struct resource_list_x *tmp;
>> +
>> +	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
>> +	if (!tmp) {
>> +		pr_warning("add_to_failed_list: kmalloc() failed!\n");
>> +		return;
>> +	}
>> +
>> +	tmp->next = ln;
>> +	tmp->res = res;
>> +	tmp->dev = dev;
>> +	tmp->start = res->start;
>> +	tmp->end = res->end;
>> +	tmp->flags = res->flags;
>> +	list->next = tmp;
>> +}
>> +
>> +static void free_failed_list(struct resource_list_x *head)
>> +{
>> +	struct resource_list_x *list, *tmp;
>> +
>> +	for (list = head->next; list;) {
>> +		tmp = list;
>> +		list = list->next;
>> +		kfree(tmp);
>> +	}
>> +
>> +	head->next = NULL;
>> +}
> 
> This patch adds a call to add_to_failed_list(), but no call to
> free_failed_list(), so at first glance, this patch appears to introduce
> a leak.  I see that it actually doesn't because you pass around a NULL
> 'fail_head', so you never actually call add_to_failed_list(), but it
> would make more sense if you added the alloc and matching free in a
> single patch.

free_failed_list will free them all.


YH
