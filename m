Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYGROpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYGROpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYGROov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:44:51 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:28704 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbYGROot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rQZx3HTLyrG0haV4FD8ExQcWNLDZU21A0bNTcyvNQ0T5x5uSam3Wfn309Ob+6ufnMV
         VAjbPzGrGfkD1GB/RxXhEngwt5nFCPzheWWUdLBl7MarxAc2ZdZ8NTZV9Xvk+uVEK5KC
         IU7YcGanyP4KA3ihSE/6znVOEirASUM3rwSyQ=
Message-ID: <84144f020807180744w40677f6dm790d2caee3ca0d15@mail.gmail.com>
Date: Fri, 18 Jul 2008 17:44:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080718101624.GA7107@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <20080718054626.GA3338@2ka.mipt.ru>
	 <84144f020807180202l6c703234ic3a2b57e73a1d89a@mail.gmail.com>
	 <20080718101624.GA7107@2ka.mipt.ru>
X-Google-Sender-Auth: 0e3f028efea40421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Fri, Jul 18, 2008 at 12:02:26PM +0300, Pekka Enberg
(penberg@cs.helsinki.fi) wrote:
>> > Out of curiosity, why does it scream at allocation time?
>>
>> Because it's checking for use-after-free errors. The object is
>> poisoned with POISON_FREE when it's free'd and we verify the poison
>> values at allocation time.

On Fri, Jul 18, 2008 at 1:16 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Does it also scream on double free event? Just to closer guilty
> circles... 0x9c offset is somewhere at the very end of the skbuff
> structure, likely skb->users.

Yeah. See the free_debug_processing() function in mm/slub.c for
details (the on_freelist() part). However, if you look at slab_free()
you can see that in the SLUB fast-path we don't do any of these
debugging checks. So you can end up with slab corruption without a
nice error message.

                                  Pekka
