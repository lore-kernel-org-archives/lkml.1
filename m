Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbZLRA6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbZLRA6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZLRA62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:58:28 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:50211 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZLRA60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SLm8CKUAD4YWVNuwZNAnnwoWKgVzu8zGpejR3iUmLBDVRx+01wBzfQGEdhmM41BVH+
         B6Qa+lLvqGxO7fSibm0vIx0KBWZczcn5JuQw1xKK+QKUx5JJcdUjRa8SugE1LQ06eVTl
         sZcURsnA9B/tUDhJr5xPtRdck4w4QY4KDc+Ak=
MIME-Version: 1.0
In-Reply-To: <AFE3AE33-41FB-42EE-A861-9C6CC1D1F435@kernel.crashing.org>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
	 <20091216164144.daff5468.kim.phillips@freescale.com>
	 <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
	 <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
	 <4B2A6DFA.6000504@intel.com>
	 <AFE3AE33-41FB-42EE-A861-9C6CC1D1F435@kernel.crashing.org>
Date: Thu, 17 Dec 2009 17:58:23 -0700
X-Google-Sender-Auth: e624ad32f5e2b2f7
Message-ID: <e9c3a7c20912171658r48f13600kfdfb41a75efa9838@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
From: Dan Williams <dan.j.williams@intel.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "B04825@freescale.com" <B04825@freescale.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Vishnu Suresh <Vishnu@freescale.com>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
       Dipen Dudhat <Dipen.Dudhat@freescale.com>,
       Maneesh Gupta <Maneesh.Gupta@freescale.com>,
       "R58472@freescale.com" <R58472@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 11:45 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>> The specific case it is needed for Talitos/raid is a channel switch interrupt.  The interrupt causes the cleanup operation to be run which will kick off any pending dependent operations on the xor channel.  In the raid case we only have callbacks at the end of a chain, so we need the interrupt to kick the engine in an operation chain like xor->copy->xor->callback.
>
> Ok, I'm still confused as to how the DMA interrupt interacts with the Talitos/raid side of things.  The should be completely independent (separate interrupts, separate IP blocks).
>

To keep hardware implementation details out of md/raid the async_tx
api provides support for managing cross-channel dependency chains.
When the raid5 code submits a xor->copy->xor chain the api prepares
all the descriptors across all the involved channels but then delays
submission as needed to maintain ordering.  So at a minimum we need
two interrupts in this scenario one from Talitos to kick the
submission of the copy-descriptor to fsldma when the first xor
completes, and another one to kick the submission of the second
xor-descriptor on Talitos when fsldma completes the copy.  Needless to
say it is more efficient when a channel has all the capabilities, but
this channel switch mechanism has proven effective on iop3xx and
ppc4xx.

--
Dan
