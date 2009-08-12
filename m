Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZHLFne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZHLFne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 01:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZHLFnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 01:43:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:38521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZHLFnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 01:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k0CkdYBdaJv3Eg7sqDdEnIjL0Nq+T6UjCpXjqQ1bTmhpnKJqfvPrUQ5GTeSiHkGZ/x
         gkSKS7fim+vwyeHhsiE46leU8bOJF3aJlof5Ew8WlwRv/ULr8oXQGk4N27TVha3rEl99
         rd5IP0c1cVPc1Kt2zy8yBhzj7Osnjjkuc/mug=
MIME-Version: 1.0
In-Reply-To: <20090812044837.GC5330@wotan.suse.de>
References: <20090811110902.255877673@suse.de>
	 <20090811111607.310739140@suse.de> <20090811200711.GA24213@lenovo>
	 <20090812044837.GC5330@wotan.suse.de>
Date: Wed, 12 Aug 2009 09:43:32 +0400
Message-ID: <aa79d98a0908112243u1a5ccb33wc51a3e9ace3e97df@mail.gmail.com>
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/09, Nick Piggin <npiggin@suse.de> wrote:
> On Wed, Aug 12, 2009 at 12:07:11AM +0400, Cyrill Gorcunov wrote:
>> [npiggin@suse.de - Tue, Aug 11, 2009 at 09:09:06PM +1000]
>> ...
>> | +static void update_queue_simple(struct sem_array *sma, ushort semnum)
>> | +{
>> | +	if (unlikely(sma->complex_count)) {
>> | +		update_queue(sma);
>> | +	} else {
>> | +		struct sem *sem;
>> | +
>> | +		sem = &sma->sem_base[semnum];
>> | +		if (sem->semval > 0)
>> | +			update_negv_queue(sma, sem);
>> | +		if (sem->semval == 0)
>> | +			update_zero_queue(sma, sem);
>> | +	}
>> | +}
>> | +
>> ...
>>
>> Hi Nick,
>>
>> mostly probably miss something but can't we trgigger BUG_ON at updating
>> zero queue if semaphore was created with undo list and via new operation
>> reached -ERANGE on undo value?
>>
>> Again, I could be missing something or plain wrong. Just a thought.
>
> Hi Cyrill,
>
> Thanks for looking... Hmm, you mean BUG_ON(error) due to try_atomic_semop
> returning -ERANGE? I think it should not be possible because it should
> prevent any operation from bringing the undo list to -ERANGE so then any
> operation which does not modify the sem value should not go out of range
> I think.
>
> (I think it would be a bug if we ever return -ERANGE for a wait-for-zero
> operation).
>
> Thanks,
> Nick
>
Thanks for explanation, Nick! I meant exactly that.
