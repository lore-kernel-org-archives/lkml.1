Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbZLRWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbZLRWRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZLRWRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:17:45 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:38838 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZLRWRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RWgrr64xkiXO5tKICZ2YEKQ5kvlqpeAXjcy2hSrGj2t+5hxtJXtmS549el2ymQwRjg
         E4YlBHmj5rJVN+IJeX4P0dL3W/dR4i/Eg4OoJCdbvRAE4c86hJXXR+MrWHJp2Vsn8Bq8
         f8X2TPZYt2HpdJ3qxrhs/AHEO6sbKIlE0Pmzg=
MIME-Version: 1.0
In-Reply-To: <3A45394FD742FA419B760BB8D398F9ED01059526@zch01exm26.fsl.freescale.net>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
	 <20091216164144.daff5468.kim.phillips@freescale.com>
	 <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
	 <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
	 <4B2A6DFA.6000504@intel.com>
	 <3A45394FD742FA419B760BB8D398F9ED01059526@zch01exm26.fsl.freescale.net>
Date: Fri, 18 Dec 2009 15:17:42 -0700
X-Google-Sender-Auth: 8ceaa4081a6e093e
Message-ID: <e9c3a7c20912181417v2b8155e5w23fb3cee02b9a4c9@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
From: Dan Williams <dan.j.williams@intel.com>
To: Li Yang-R58472 <r58472@freescale.com>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Kumar Gala <galak@kernel.crashing.org>, herbert@gondor.apana.org.au,
       Tabi Timur-B04825 <B04825@freescale.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Suresh Vishnu-B05022 <B05022@freescale.com>,
       linux-crypto@vger.kernel.org,
       Dudhat Dipen-B09055 <B09055@freescale.com>,
       Gupta Maneesh-B18878 <B18878@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 8:02 AM, Li Yang-R58472 <r58472@freescale.com> wrote:
>
>>Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for
>>Async_tx XOR offload
>>
>>Ira W. Snyder wrote:
>>> Yes, I have used the device_prep_dma_interrupt()
>>functionality quite a
>>> while back. However, I found it to be pretty much useless.
>>
>>The specific case it is needed for Talitos/raid is a channel
>>switch interrupt.  The interrupt causes the cleanup operation
>>to be run which will kick off any pending dependent operations
>>on the xor channel.  In the raid case we only have callbacks
>>at the end of a chain, so we need the interrupt to kick the
>>engine in an operation chain like
>>xor->copy->xor->callback.
>
> I am wondering if can use more callbacks to kick off pending dependent operations?
> Like xor->callback->copy->callback->xor->callback?
>

No, the callback field is reserved for clients of the api.  What you want is:

xor->cleanupT->copy->cleanupF->xor->cleanupT->callback

Where cleanupT is the Talitos descriptor cleanup routine and cleanupF
is from fsldma.  The assumption is that the interrupt kicks the
cleanup routine and that calls dma_run_dependencies().

--
Dan
