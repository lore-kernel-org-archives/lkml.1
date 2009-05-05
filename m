Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZEENp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZEENp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZEENpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:45:09 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:38836 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZEENpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:45:07 -0400
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Organization: IBM
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2.6.30-rc5] ehea: fix invalid pointer access
Date: Tue, 5 May 2009 15:45:05 +0200
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, themann@de.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com, osstklei@de.ibm.com
References: <200905051319.05806.hannes.hering@linux.vnet.ibm.com> <25628.1241514687@redhat.com> <26110.1241525994@redhat.com>
In-Reply-To: <26110.1241525994@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051545.05877.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009 14:19:54 David Howells wrote:
> In that case, you might want to move the prefetchw() calls in the following:
> 
> 		pref = skb_array[x];
> 	-	prefetchw(pref);
> 	-	prefetchw(pref + EHEA_CACHE_LINE);
> 	+	if (pref) {
> 	+		prefetchw(pref);
> 	+		prefetchw(pref + EHEA_CACHE_LINE);
> 
> to before the if-statement.  That way the CPU can be attempting the prefetch
> whilst it's chewing over the test and branch.  prefetching shouldn't fault on
> a bad address.
> 
> David
Hi David,

you are right so far, but actually the prefetch calls on POWER also contain
an if statement to check if the address is valid (i. e. non-zero). We never
have the case that the pref != NULL and pref->data == NULL. And the situation
of pref==NULL is very rare. This means there is no benefit moving our if
statement down from performance perspective if we assume that our if does not
take longer then the if in the prefetch command. We can add an
if(likely(pref) if you like. In fact doing the if statement as we do it now
we actually save the prefetch if statements in case we hit the situation of
pref==NULL.

Regards

Hannes
