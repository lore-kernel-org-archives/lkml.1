Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbYBAVbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbYBAVbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbYBAVba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:31:30 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:18771 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbYBAVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:31:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dlOdoU2/wLSFpiqywnx4HvW/+3sUKpWolRl6nLCabPxwLquawQa3gPhTAGY4NogngHdK7MGHs7qGKzfnUDmazqqNQGoA/c7f2u0lpkDTbLtdQ7M3D8mJ3PhZrV67VOjuVOf3SJ8HOvnSWoZbSs/0IAAWHHUFlkRODGrlqJNGlsg=
Message-ID: <e9c3a7c20802011331j2064afe5vc6228fe8363e15de@mail.gmail.com>
Date: Fri, 1 Feb 2008 14:31:28 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: crypto/async_tx/* doesn't build on s390
Cc: heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au, neilb@suse.de,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080201123738.24988af7@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0C7297FA1D2D244A9C7F6959C0BF1E521D1C6C@azsmsx413.amr.corp.intel.com>
	 <20080201123738.24988af7@gondolin.boeblingen.de.ibm.com>
X-Google-Sender-Auth: f667cd398cc58fb8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 4:37 AM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Thu, 31 Jan 2008 12:49:00 -0700,
> "Williams, Dan J" <dan.j.williams@intel.com> wrote:
>
> > I am mistaken, the 'depends on ARCH...' precludes HAS_DMA.  Perhaps the compiler is emitting a call to async_tx_find_channel when it needs to be inline?  On x86 do_async_xor is successfully compiled away when CONFIG_DMA_ENGINE=n.
>
> Just checked why it compiled for me on one box but not on the other and
> found that deactivating CONFIG_SECTION_MISMATCH makes it go away. Hmm...
>

Here is what I have come up with as a fix.

--
Dan

---
async_tx: prevent do_async_xor from compiling on !HAS_DMA archs

With the addition of -fno-inline in CONFIG_DEBUG_SECTION_MISMATCH
do_async_xor is no longer compiled away on !HAS_DMA archs like s390.
Other async_tx calls to the dma-api are already open coded inline.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_xor.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2575f67..393f07d 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -41,6 +41,14 @@ do_async_xor(struct dma_async_tx_descriptor *tx,
struct dma_device *device,
        enum dma_data_direction dir;
        int i;

+       /* if this function is not inlined we need to prevent
+        * the rest of the routine from compiling on !HAS_DMA
+        * archs
+        */
+       #ifndef CONFIG_DMA_ENGINE
+       return;
+       #endif
+
        pr_debug("%s: len: %zu\n", __FUNCTION__, len);

        dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
